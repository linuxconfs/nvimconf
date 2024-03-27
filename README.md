# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## useful cmds

1. replace links in markdown `%s/https\?.*/[&](&)/g`
2. insert current date or time : `:r!date` or `:'<,'>!date`
3. paste register info: `<C-r>`, with compute: `<C-r>=`, file absolute path: `<C-r>%`
4. compute line number: `<C-g> or g<C-g>`
5. copy to iterm2: `<>w !it2copy`
6. compute a column of numbers: `'<,'>w !paste -s -d '+' - | bc` or `'<,'>w !awk '{ sum+=$1 } END { print sum }' -`
7. compute a column of numbers and append: `'<,'>w !paste -s -d '+' - | bc | >>%`
