" http://510x.se/notes/posts/My_Vim_usage/#keycodes

set showcmd        " display incomplete commands
set incsearch      " do incremental searching
set number         " row numbering
set ignorecase     " ignore case when searching
set smartcase      " case sensitive when using capitals in search phrase

set cursorline     " highlight current line

""set completeopt=menuone    " show completion menu also for single hits

"colorscheme zenburn
"let g:zenburn_old_Visual = 1   " marked lines are lightened

"" This makes the F2 button call a tag list, provided by the Tag list plugin
"nnoremap <silent> <F2> :TlistToggle<CR>
" mapping to make movements operate on 1 screen line in wrap mode
"" <http://stackoverflow.com/questions/4946421/vim-moving-with-hjkl-in-long-lines-screen-lines>
"function! ScreenMovement(movement)
"    if &wrap
"        return "g" . a:movement
"    else
"        return a:movement
"    endif
"endfunction

"map <silent> <expr> <C-Down> ScreenMovement("j")
"map <silent> <expr> <C-Up> ScreenMovement("k")
"map <silent> <expr> <C-Home> ScreenMovement("0")
"map <silent> <expr> <C-End> ScreenMovement("$")

"" Save with sudo. :w!! command
cmap w!! %!sudo tee > /dev/null %

"" Persistent undo - new function in Vim 7.3.
"" Create the directory manually.
"set undodir=~/.vim/undodir
"set undofile



set exrc
set secure

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set colorcolumn=110
highlight ColorColumn ctermbg=darkgray

"augroup project
"    autocmd!
"    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
"augroup END
