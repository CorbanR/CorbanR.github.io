---
layout: post
title: Speeding up neovim when using rbenv
tags: [neovim, vim, rbenv, ruby]
subtitle: Speeding up neovim
---
I've been using [neovim](https://neovim.io/) for the last couple years, and so far LOVE it. I did however initially have an issue
opening ruby files. The issue, is that it would LITERALLY take a few seconds to start up `neovim` whenever I opened `somefile.rb`.

```
nvim --startuptime neobaseline.log somefile.rb
1426.382  1296.813  1296.813: sourcing /../ftplugin/ruby.vim
5149.924  000.013: --- NVIM STARTED ---
```
I did some additional profiling with `vim`, and was getting similar results(albeit `vim` was a bit faster loading ruby files). Seeing slowness with
vim confirmed that it wasn't an issue specifically with `neovim`. After doing some additional profiling and researching online, I was able to get
both `neovim` and `vim` to load significantly faster!

```
049.027  000.004: --- NVIM STARTED ---

037.137  000.002: --- VIM STARTED ---
```
Before I get to far, lets go over my `neovim` setup(if you really don't care, skip to the solution section!).

### Neovim/Vim setup
I hate having a massive `.vimrc` file so I split out the configuration into multiple files.
The config I use, works fully with both `neovim`, and `vim`

```vim
""""""""""Load Vim Config""""""""""""""
source ~/.vim/config/config.vim

""""""""""Load Custom Mappings"""""""""
source ~/.vim/config/mappings.vim

""""""""""Load Custom Scripts""""""""""
source ~/.vim/config/scripts.vim

""""""""""Plugin install"""""""""""""""
source ~/.vim/config/plugins.vim

""""""""""Plugin install"""""""""""""""
source ~/.vim/config/plugin-config.vim
```

The plugin manger I use is [vim-plug](https://github.com/junegunn/vim-plug).
I won't post my whole `plugins.vim` file due to the size.

```vim
" Neovim and vim8 support
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Multiple syntax files
" Takes care of most things like vim-ruby, vim-javascript, vim-typescript etc
Plug 'sheerun/vim-polyglot', { 'for': ['ansible', 'cmake', 'crystal', 'clojure', 'dart', 'dockerfile', 'groovy', 'haproxy', 'javascript', 'jenkins' , 'jinja', 'json', 'llvm', 'lua', 'nginx', 'nim', 'pgsql', 'protobuf', 'ruby', 'eruby', 'haml', 'rust', 'swift', 'systemd', 'terraform', 'tomdoc', 'toml', 'typescript', 'yard', 'yaml', 'tmux', 'reason'] }

" Linting
Plug 'w0rp/ale'
```

### Solution
After a bit of research and some trial and error I found that using `rbenv` was a HUGE part of the problem. A ton of time was being spent by `neovim` and `vim` searching for the ruby binary and gems.
Additionally the `provider/clipboard.vim` was taking a long time to load for `neovim`.

NOTE: I have my vim config split into multiple files, but you just have a `.vimrc`.

1. Adding `Plug 'tpope/vim-rbenv'` to the top of my `.vimrc`, before most things were loaded, cut the startup time for `vim` by about half (**interestingly** enough, it didn't do a whole lot for `neovim`)
  ```vim
  " Install plug manager early
  call plug#begin('~/.local/share/nvim/plugged')
  " Load rbenv plugin early on to speed up scripts that
  " look for ruby paths/gems etc
  Plug 'tpope/vim-rbenv'
  ```
2. Updating my `plugins.vim` to use more "On-demand loading", helped a bit
  ```vim
  Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  ```
3. Specifying the ruby host prog in my `config.vim`(specifically for `neovim`)
  ```vim
  if has('nvim')
  " Tell neovim which ruby to use(ends up being rbenv)
  " The below should be handled by the tpope/vim-rbenv
  "
  " let g:ruby_path = system('echo $HOME/.rbenv/shims')
  let g:ruby_host_prog = '~/.rbenv/shims/neovim-ruby-host'
  let ruby_spellcheck_strings = 1
  endif
  ```
4. Specifying the clipboard settings
  ```vim
  if has('macunix')
  let g:clipboard = {'copy': {'+': 'pbcopy', '*': 'pbcopy'}, 'paste': {'+': 'pbpaste', '*': 'pbpaste'}, 'name': 'pbcopy', 'cache_enabled': 1}
  set clipboard+=unnamedplus
  endif
  ```

Both `vim` and `neovim` will now start almost instantaneously!!

```
049.027  000.004: --- NVIM STARTED ---

037.137  000.002: --- VIM STARTED ---
```
