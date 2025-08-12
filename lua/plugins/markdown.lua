return {
  { "godlygeek/tabular", "preservim/vim-markdown" },
  {
    "junegunn/vim-easy-align",
    keys = {
      {
        "gaa",
        "<Plug>(EasyAlign)",
        mode = { "n", "x" },
        desc = "easy align column",
        { noremap = true, silent = true },
      },
      {
        "gat",
        "<cmd>set nowrap<cr>:normal! vip<cr>:EasyAlign *|<cr>",
        mode = { "n", "x" },
        desc = "Align Markdown table on |",
        { noremap = true, silent = true },
      },
    },
  },
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
    },
  },
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    lazy = true, -- 设置为延迟加载
    config = function()
      -- 完全禁用自动渲染
      require("diagram").setup({
        integrations = {
          require("diagram.integrations.markdown"),
          require("diagram.integrations.neorg"),
        },
        events = {
          render_buffer = {}, -- 清空所有自动渲染事件
          clear_buffer = { "BufLeave" },
        },
        renderer_options = {
          mermaid = {
            theme = "forest",
          },
          plantuml = {
            charset = "utf-8",
          },
          d2 = {
            theme_id = 1,
          },
          gnuplot = {
            theme = "dark",
            size = "800,600",
          },
        },
      })
    end,
    init = function()
      -- 在插件加载前就设置键盘映射
      local function manual_render_diagram()
        -- 确保插件已加载
        require("diagram")

        -- 获取当前光标位置
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local line_num = cursor_pos[1]

        -- 检查是否在 mermaid 代码块中
        local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local in_diagram_block = false
        local block_start, block_end = nil, nil
        local diagram_type = nil

        -- 向上查找代码块开始
        for i = line_num, 1, -1 do
          local line = buf_lines[i]
          if line:match("^%s*```mermaid") then
            block_start = i
            in_diagram_block = true
            diagram_type = "mermaid"
            break
          elseif line:match("^%s*```plantuml") then
            block_start = i
            in_diagram_block = true
            diagram_type = "plantuml"
            break
          elseif line:match("^%s*```d2") then
            block_start = i
            in_diagram_block = true
            diagram_type = "d2"
            break
          elseif line:match("^%s*```gnuplot") then
            block_start = i
            in_diagram_block = true
            diagram_type = "gnuplot"
            break
          elseif line:match("^%s*```") then
            break
          end
        end

        -- 如果找到开始，查找结束
        if in_diagram_block then
          for i = line_num, #buf_lines do
            if i > block_start and buf_lines[i]:match("^%s*```%s*$") then
              block_end = i
              break
            end
          end
        end

        -- 如果光标在图表块中，手动触发渲染
        if in_diagram_block and block_start and block_end then
          -- 创建一个临时的自动命令来触发渲染
          local bufnr = vim.api.nvim_get_current_buf()

          -- 使用 vim.schedule 确保在下一个事件循环中执行
          vim.schedule(function()
            -- 临时启用渲染事件并立即触发
            vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = bufnr })
            -- 或者直接调用 diagram 的内部渲染函数
            local diagram = require("diagram")
            -- 如果插件有公开的渲染方法，可以直接调用
            -- diagram.render_buffer(bufnr) -- 这可能需要查看插件源码
          end)

          print(string.format("Rendering %s diagram...", diagram_type))
        else
          print("Cursor not in diagram block")
        end
      end

      -- 设置键盘映射，但只在 markdown 或 neorg 文件中生效
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "norg" },
        callback = function()
          vim.keymap.set("n", "K", manual_render_diagram, {
            buffer = true,
            desc = "Manual diagram render",
          })
        end,
      })
    end,
  },
}
