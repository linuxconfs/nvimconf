return {
  -- {
  --   "voldikss/vim-floaterm",
  --   ft = "python", -- 只在 Python 文件类型加载
  --   keys = {
  --     { "<leader>py", "<cmd>FloatermReplSendNewlineOrStart<CR>", mode = "n", desc = "Python REPL Start" },
  --     { "<leader>pe", "<cmd>FloatermReplSend<CR>", mode = "n", desc = "Execute Line" },
  --     { "<leader>pe", "<cmd>FloatermReplSendVisual<CR>", mode = "x", desc = "Execute Selection" },
  --     { "<leader>pq", "<cmd>FloatermReplSendExit<CR>", mode = "n", desc = "Quit REPL" },
  --     { "<leader>pt", "<cmd>FloatermReplSendBlock<CR>", mode = "n", desc = "Execute Block" },
  --     { "<leader>pc", "<cmd>FloatermReplSendClear<CR>", mode = "n", desc = "Clear REPL" },
  --   },
  -- },
  -- { "leoatchina/vim-floaterm-repl" },
  --
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {},
  },
  {
    -- FULLY EVALUATE iron.nvim before touching anything else
    --  Likes => all the keymaps make 100% sense, esp `isb` for block (cell deliniator)
    --    multiple languages (i.e. python, lua, shell)
    --  Actually using terminal windows makes sense as most of the time I am not gonna be using that terminal, just sending commands with keymaps
    --
    -- "Vigemus/iron.nvim",
    "g0t4/iron.nvim",
    branch = "fix-clear-repl",
    -- dir = "~/repos/github/g0t4/iron.nvim",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },

    config = function()
      local core = require("iron.core")
      local ll = require("iron.lowlevel")
      local marks = require("iron.marks")

      local function ensure_open()
        -- FYI based on https://github.com/g0t4/iron.nvim/blob/d8c2869/lua/iron/core.lua#L254-L274
        local meta = vim.b[0].repl

        if not meta or not ll.repl_exists(meta) then
          ft = ft or ll.get_buffer_ft(0)
          -- if data == nil then return end
          meta = ll.get(ft)
        end

        -- If the repl doesn't exist, it will be created
        if not ll.repl_exists(meta) then
          meta = core.repl_for(ft)
        end

        return meta
      end

      local function ensure_open_and_cleared()
        -- STATUS:
        -- - btw, this works for ipython
        -- - works with lua to stop the empty scrollback lines after ctrl-l
        -- - buggy for fish shell is all (so far that I have found)
        --
        -- clear scrollback somehow clears in lua (kinda, the lines go away but empty lines still are there in scrollback)
        -- for almost all other shells (i.e. ipython, fish) the scrollback is still there entirely
        core.clear_repl()
        -- TODO do I not wanna open it if its closed, when it comes to clear commands?
        local meta = ensure_open()
        if meta == nil then
          return
        end

        -- vim.fn.feedkeys("^L", 'n') -- if wanna send self, need to switch buffers first vim.api.nvim_set_current_buf(bufnr) + vim.defer_fn if needed
        -- DOES NOT FULLY WORK
        --  interesting when I use this myself in fish terminal buffer it does work
        --  focus and go into terminal mode
        --  Ctrl-L
        --  :set scrollback=1
        --  :set scrollback=100000
        --  FOR NOW try not to rely on too much scrolling backwards is likely best bet

        local sb = vim.bo[meta.bufnr].scrollback
        -- hack to truncate scrollback, works in ipython, half way clears in fish
        vim.bo[meta.bufnr].scrollback = 1
        vim.bo[meta.bufnr].scrollback = sb

        return meta
      end

      local function clear_then(func)
        return function()
          ensure_open_and_cleared()
          func()
        end
      end

      local function send_top_block_then_current_block()
        -- previously, I would just run whole file `isf` then `icb` for current block...
        --  this collapses that into one command and hopefully obviates running code I don't care about if I can make top block comprise most if not all init and otherwise have each block be standalone
        --  I could come up with more conventions for related blocks... but lets KISS for now

        local meta = ensure_open_and_cleared()
        if not meta then
          return
        end

        -- PRN add check for blocks before running whole file?
        -- FOR NOW assume user knows that there are blocks and just run it
        --    that means the whole file runs (twice) if there are no blocks
        --    or if cursor in top block already, it runs that twice then

        local cursor_position = vim.api.nvim_win_get_cursor(0)
        -- PRN capture scroll position and restore it after send? ... OR can I redo parts of iron.nvim to not scroll the buffer when selecting the commands that are going to be run?

        -- move cursor to top of file
        vim.cmd("norm gg")
        -- FYI if this is jarring to jump around, then lets extract logic to get contents of a given block based on a line #
        --     use:   https://github.com/g0t4/iron.nvim/blob/d8c2869/lua/iron/core.lua#L517-L547
        core.send_code_block()
        ensure_open_and_cleared()

        vim.api.nvim_win_set_cursor(0, cursor_position)

        -- run block user wanted run
        core.send_code_block()
      end

      -- ok I ❤️  THESE:
      vim.keymap.set(
        "n",
        "<leader>icm",
        clear_then(function()
          core.run_motion("send_motion")
        end),
        { desc = "clear => send motion" }
      )
      vim.keymap.set(
        "v",
        "<leader>icv",
        clear_then(function()
          core.send(nil, core.mark_visual())
        end),
        { desc = "clear => send visual" }
      )
      vim.keymap.set("n", "<leader>icf", clear_then(core.send_file), { desc = "clear => send file" })
      vim.keymap.set("n", "<leader>icl", clear_then(core.send_line), { desc = "clear => send line" })
      vim.keymap.set("n", "<leader>icp", clear_then(core.send_paragraph), { desc = "clear => send paragraph" })
      -- reminder, with `isp` iron.nvim uses `iron.send_paragraph({})` ... do I need the ({}) for any reason? so far no issues
      vim.keymap.set("n", "<leader>icb", clear_then(core.send_code_block), { desc = "clear => send block" })
      vim.keymap.set(
        "n",
        "<leader>icn",
        clear_then(function()
          core.send_code_block(true)
        end),
        { desc = "clear => send block and move to next block" }
      )
      vim.keymap.set(
        "n",
        "<leader>ict",
        clear_then(send_top_block_then_current_block),
        { desc = "clear => run top block then current block" }
      )
      vim.keymap.set(
        "n",
        "<leader>ist",
        send_top_block_then_current_block,
        { desc = "run top block then current block" }
      )
      vim.keymap.set("n", "<leader>icc", ensure_open_and_cleared, { desc = "clear" })
      --

      -- TODO LATER... try this instead for capturing terminal output:) ... out of time for now
      -- TODO add this to ensure_open above when making new repl (to test)
      --    later would need to fuse (monkey patch?) with iron.nvim
      -- repl.last_command_output = {}
      -- local capturing = false
      -- local bufnr = vim.api.nvim_get_current_buf()
      --
      --   this event approach would be much more robust and work across REPLs (terminals)
      -- -- Capture TermOutput lines only for this buffer
      -- -- FYI this is not a real event... however see on_stdout with termopen()
      --  or TextChanged events
      -- vim.api.nvim_create_autocmd("TermOutput", {
      --     buffer = bufnr,
      --     callback = function(args)
      --         if capturing then
      --             table.insert(repl.last_command_output, args.data)
      --         end
      --     end,
      -- })
      --
      -- -- Watch for command start and stop
      -- vim.api.nvim_create_autocmd("TermRequest", {
      --     buffer = bufnr,
      --     callback = function()
      --         local msg = vim.v.termrequest
      --         if string.sub(msg, 1, 7) == '\x1b]133;C' then
      --             capturing = true
      --             repl.last_command_output = {} -- reset for new command
      --         elseif string.sub(msg, 1, 7) == '\x1b]133;D' then
      --             capturing = false
      --             print("Captured lines:", #repl.last_command_output)
      --         end
      --     end,
      -- })
      local function WIP_test_copy_cmd_output_using_tmp_file()
        local current_buf = vim.api.nvim_get_current_buf()

        local meta = ensure_open()
        if meta == nil then
          return
        end

        local tmpfile = vim.fn.tempname() -- SO DARN LONG
        --
        -- good for testing
        -- local tmpfile = "/tmp/test" .. current_buf -- semi-unique, per buffer name :)
        -- vim.fn.system('trash "' .. tmpfile .. '"') -- test only, nuke file first

        -- ** "one shot" autocmd fires when command finishes
        local autocmd_id
        autocmd_id = vim.api.nvim_create_autocmd({ "TermRequest" }, {
          buffer = meta.bufnr, -- only events from the terminal with the REPL
          desc = "detect when REPL is done running a command so I can copy its output",
          callback = function(ev)
            -- FYI ev has bufnr IIRC
            -- print("TReq", vim.v.termrequest)

            -- PRN other fallbacks too aside from D? i.e. if D is missed I s/b able to do on A/B too
            --   (just double check they don't happen at the wrong early time too)

            if string.sub(vim.v.termrequest, 1, 7) == "\x1b]133;D" then
              vim.api.nvim_del_autocmd(autocmd_id)
              autocmd_id = nil -- don't run twice

              local commented_out_lines = {}
              -- TODO add error handling, sommetimes the file isn't found... I wonder if a command timing is such that the file is just about to be written to and this gets ahead? and so it needs to wait in that case at least one time past the first failure?
              local file = io.open(tmpfile)
              for line in file:lines() do
                local commented = "# " .. line
                table.insert(commented_out_lines, commented)
              end

              -- paste into original buffer
              vim.api.nvim_set_current_buf(current_buf)
              vim.api.nvim_put(commented_out_lines, "l", true, true)
            end
          end,
        })

        local function send_line()
          local linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
          local cur_line = vim.api.nvim_buf_get_lines(0, linenr, linenr + 1, 0)[1]
          local width = vim.fn.strwidth(cur_line)

          if width == 0 then
            return
          end

          marks.set({
            from_line = linenr,
            from_col = 0,
            to_line = linenr,
            to_col = width - 1,
          })

          cur_line_teed = cur_line .. " | tee " .. tmpfile
          core.send(nil, cur_line_teed)
          -- FYI don't even need to clear repl in this case!
        end

        send_line()
      end

      vim.keymap.set("n", "<leader>it", WIP_test_copy_cmd_output_using_tmp_file, { desc = "clear => send test" })

      local function current_line_is_blank()
        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        local current_line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        -- print("current line: '" .. current_line .. "'")
        return current_line:match("^%s*$")
      end

      local function is_line_before_blank_or_first_in_file()
        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        if row == 1 then
          -- edge case, could go either way, I don't intend to put delimiter at start or end of file so not that important in this case
          return true
        end
        local previous_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1]
        -- print("previous line: '" .. previous_line .. "'")
        return previous_line:match("^%s*$")
      end

      local function get_all_block_deviders()
        local config = require("iron.config")

        local repl_definition = config.repl_definition[vim.bo[0].filetype]
        if repl_definition == nil then
          error("No repl definition for this filetype!")
        end

        local all_deviders = config.repl_definition[vim.bo.filetype].block_deviders
        if all_deviders == nil or #all_deviders <= 0 then
          error("No cell delimiting block divider(s) configured for this filetype!")
        end
        return all_deviders
      end

      local function is_a_block_devider_line(line)
        return vim.iter(get_all_block_deviders()):any(function(devider)
          return string.match(line, devider)
        end)
      end

      vim.keymap.set("n", "<leader>ij", function()
        -- move down to next cell
        local start_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
        -- does not include cursor line (that way if on a cell's devider you will jump to next cell not "current" cell
        local all_lines_below_cursor_line = vim.api.nvim_buf_get_lines(0, start_line, 10000, false)
        for lines_below, line in ipairs(all_lines_below_cursor_line) do
          if is_a_block_devider_line(line) then
            -- +1 => line after devider
            local block_line_number = start_line + lines_below + 1
            print("block_line_number: " .. (block_line_number or "none"))
            if lines_below == #all_lines_below_cursor_line then
              -- if the last line is a cell devider then jump to it instead of line after
              block_line_number = block_line_number - 1
            end
            vim.api.nvim_win_set_cursor(0, { block_line_number, 1 })
            break
          end
        end
      end, { desc = "iron" })
      vim.keymap.set("n", "<leader>ik", function()
        -- move up to previous cell
        local start_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
        local all_lines_above_cursor_line = vim.api.nvim_buf_get_lines(0, 1, start_line - 1, false)
        local reversed = vim.fn.reverse(all_lines_above_cursor_line)
        -- print(vim.inspect(reversed))
        for lines_above, line in ipairs(reversed) do
          if is_a_block_devider_line(line) then
            -- jump to end of previous cell is fine, I think that makes more sense when moving upward?
            -- -1 => line before devider
            local block_line_number = start_line - lines_above - 1
            vim.api.nvim_win_set_cursor(0, { block_line_number, 1 })
            break
          end
        end
      end, { desc = "iron" })

      --- return the first block devider
      ---  if there are multiple, it is assumed the first is the preferred one
      local function get_preferred_block_devider()
        -- BTW I am keeping misspelling of devider so as to easily find relevant code

        local config = require("iron.config")

        local repl_definition = config.repl_definition[vim.bo[0].filetype]
        if repl_definition == nil then
          error("No repl definition for this filetype!")
        end

        local first_devider = config.repl_definition[vim.bo.filetype].block_deviders[1]
        if first_devider == nil or #first_devider <= 0 then
          error("No cell delimiting block divider(s) configured for this filetype!")
        end
        return first_devider
      end

      vim.keymap.set("n", "<leader>ib", function()
        -- [i]nsert [b]lock divider
        local preferred_devider = get_preferred_block_devider()

        if not current_line_is_blank() then
          -- move to after/end of paragraph
          vim.api.nvim_feedkeys("}", "n", false)

          vim.defer_fn(function()
            -- without defer, current line always the same original line
            -- OR am I doing something else wrong?

            if not current_line_is_blank() then
              -- if last line of paragraph is last line of file, then it will need a new insert afterward
              --  => this manifests as not being a blank line after }
              local keys = vim.api.nvim_replace_termcodes("o<Esc>", true, false, true)
              vim.api.nvim_feedkeys(keys, "n", false)
            end

            local keys =
              vim.api.nvim_replace_termcodes("o" .. preferred_devider .. "<CR><Esc>cc<Esc>", true, false, true)
            -- FYI cc clears the current line to wipe out comment leader if added (b/c formatoptions contains "o")
            vim.api.nvim_feedkeys(keys, "n", false)
          end, 0)
        else
          if not is_line_before_blank_or_first_in_file() then
            -- make sure blank line before divider
            local keys = vim.api.nvim_replace_termcodes("o<Esc>", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
          end
          local keys =
            vim.api.nvim_replace_termcodes("i" .. preferred_devider .. " <CR><Esc>cc<Esc>", true, false, true)
          vim.api.nvim_feedkeys(keys, "n", false)
          -- FYI b/c I use <CR> to insert a line, that ensures there is a new line after the divider
        end
      end, { desc = "iron" })

      local function open_repl_below()
        vim.cmd("IronRepl") -- toggles open/closed which is fine!
        -- focus stays on current window, so move it to the top which then moves REPL to bottom half
        -- TODO read if open and don't trigger wincmd K if not open?
        vim.cmd("wincmd K") -- if repl toggles close, this might mess up other windows open, let's wait and see if it bothers me
      end
      vim.keymap.set("n", "<leader>irj", open_repl_below, { desc = "open repl split below" })

      local bash_repl_definition = {
        -- command: either a table, or a func that returns a table
        command = { "bash" },
        block_deviders = { "# %%" },
      }

      local python_repl_definition = {

        -- PRN if need be, create a profile for configuring how ipython runs inside of iron.nvim (only if issues with config outside of nvim), --profile foo
        command = { "uv", "run", "ipython", "--no-autoindent" },
        -- command = { "uv", "run", "jupyter", "console" },
        -- command = { "python3" },
        -- FYI careful with bracketed_paste VS bracketed_paste_python!!!
        -- format = require("iron.fts.common").bracketed_paste, -- for ipython?
        -- format = require("iron.fts.common").bracketed_paste_python, -- for python3 not ipython, right?
        format = function(lines, extras)
          local result = require("iron.fts.common").bracketed_paste_python(lines, extras) -- *** defacto is cell per line (yes)
          local filtered = vim.tbl_filter(function(line)
            return not string.match(line, "^%s*#") and not string.match(line, "^%s*```")
          end, result)
          return filtered
        end,
        block_deviders = { "# %%", "#%%" }, -- allow both, I have old files with no space and for now I can use both
        -- use iterm to split pane, not sure this does what ChatGPT thought it would do :)... this just runs iterm in a nested terminal window
        -- command = { "osascript", "-e", [[tell app "iTerm" to tell the current window to create tab with default profile]] },
      }

      core.setup({
        config = {
          scratch_repl = true, -- discard repls?
          repl_definition = {
            zsh = {
              command = { "zsh" },
              block_deviders = { "# %%" },
            },
            sh = bash_repl_definition,
            bash = bash_repl_definition,
            lua = {
              command = { "lua" },
              -- are these not set OOB? or is it diff default for lua?
              block_deviders = { "-- %%" },
            },
            python = python_repl_definition,
            ipynb = python_repl_definition,
            markdown = {
              command = python_repl_definition.command,
              format = python_repl_definition.format,
              block_deviders = { "```python\n```", "```python", "```" }, -- allow both, I have old files with no space and for now I can use both
            },
          },
          repl_filetype = function(bufnr, ft)
            -- set repl filetype (to language used)
            return ft
          end,
          repl_open_cmd = "vertical split", -- use regular window commands
          -- repl_open_cmd = view.split.vertical("50%"), -- DSL style... doesn't adjust with Ctrl+W,= (have to toggle close/open to fix split at 50% after font zoom change)
          -- When repl_open_cmd is an array table, IronRepl uses first cmd:
          -- repl_open_cmd = {
          --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
          --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
          -- }
        },

        -- no keymaps by default (Amen):
        keymaps = {
          toggle_repl = "<space>ir", -- toggles the repl open and closed.
          -- If repl_open_command is a table, then:
          -- toggle_repl_with_cmd_1 = "<space>rv",
          -- toggle_repl_with_cmd_2 = "<space>rh",
          restart_repl = "<space>iR", -- calls `IronRestart` to restart the repl

          -- send keymaps (<leader>is prefix currently):
          send_motion = "<space>ism", -- motion right after!
          visual_send = "<space>isv", -- send selection
          send_file = "<space>isf", -- *
          send_line = "<space>isl", -- *
          send_paragraph = "<space>isp", -- * think {}
          send_until_cursor = "<space>isu", -- run file [u]ntil cursor
          --
          send_code_block = "<space>isb", -- *** OMG YES, works with block_deviders (above)
          send_code_block_and_move = "<space>isn", -- also moves to next cell
          --
          mark_motion = "<space>imm", -- mark a selection use a motion
          mark_visual = "<space>imv", -- set marks based on visual selection
          remove_mark = "<space>imd", -- remove marks
          send_mark = "<space>imr", -- ([r]e)send marked code (any other send keymap will mark the range so it can be repeated too with this)
          --
          cr = "<space>is<cr>",
          interrupt = "<space>iq",
          exit = "<space>ix",
          --
          -- clear = "<space>icc", -- map to my_clear above to open if not already
          -- FYI fixed clear when using bracketed_paste_python:
          --   https://github.com/g0t4/iron.nvim/blob/3860d7f/lua/iron/core.lua#L167
          --   otherwise formatter replaces FF with CR b/c it seems FF as empty line
        },
        highlight = {
          -- can set hl group to control style too
          italic = true, -- IIUC is for last line run
        },
        -- TODO is this stripping blank lines out of multi line strings, i.e. [[ ]] in lua? or """ in python
        -- TODO I do know that lines that appear to be comments (but aren't) in mutli-line strings are stripped out
        ignore_blank_lines = true, -- when sending visual select lines, IIAC to not sumbmit extra prompt lines before/after/between sent commands
      })
    end,
  },
}
