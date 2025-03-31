" this is shared in common-home/cfg-neovim.nix and common-nixos/cfg-neovim.nix

" i forgot what this is even for?
let mapleader = ';'
set nocompatible
set ruler
set showcmd
set mouse=a
set backspace=indent,eol,start
set nofoldenable " stop markdown files from folding
" filetype off

set number relativenumber
set scrolloff=6

" https://vi.stackexchange.com/questions/44887/neovim-0-10-syntax-highlight-is-completely-broken
colorscheme vim
set notermguicolors

" allow Ctrl-K to add a newline but without entering insert mode
nmap <C-K> o<Esc>
" what is this for?
" imap <C-K> <C-X><C-O>

command! W :w
command! Wq :wq
command! Q :q

" i don't remember what this is for
" autocmd filetype python nnoremap ;r :term python3 %<cr>
autocmd FileType python set expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType php set noexpandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType json set expandtab tabstop=2 shiftwidth=2 autoindent
autocmd FileType nix set expandtab tabstop=2 shiftwidth=2 autoindent
autocmd FileType lua set expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType c set expandtab tabstop=4 shiftwidth=4 autoindent
autocmd FileType h set expandtab tabstop=4 shiftwidth=4 autoindent

nnoremap ;t :term<cr> i
autocmd BufNewFile,BufRead *.plist set filetype=xml
autocmd BufNewFile,BufRead *.service set filetype=dosini
autocmd BufNewFile,BufRead *.ini.example set filetype=dosini
autocmd BufNewFile,BufRead *.spec set filetype=python
autocmd BufNewFile,BufRead *.gm9 set filetype=sh
autocmd BufNewFile,BufRead Dockerfile* set filetype=dockerfile
autocmd BufNewFile,BufRead *.dockerfile set filetype=dockerfile
autocmd BufNewFile,BufRead *.nix set filetype=nix

" don't need the "How-to disable mouse"
aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.-1-

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-auto-save
let g:auto_save = 1

" this is placed after all the autocmds due to a bug
" https://github.com/neovim/neovim/issues/31589
syntax on
