" Vim Plug automatic installation
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fsLo ~/.vim/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com\
        /junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plug ins, managed by vim-plug
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !/usr/bin/python install.py --all
  endif
endfunction

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jszakmeister/vim-togglecursor'
Plug 'w0rp/ale'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'severin-lemaignan/vim-minimap'
Plug 'godlygeek/csapprox'
Plug 'leafgarland/typescript-vim'
Plug 'rking/ag.vim'
Plug 'powerline/powerline-fonts'
Plug 'kevinw/pyflakes-vim'
call plug#end()

" Turn off line wrapping
set nowrap

" Set noshowmode to hide --INSERT-- from status line
set noshowmode

" For pyflakes
filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins

" Colorz
set t_Co=256
set background=dark
colorscheme afterglow

" Make Vim more useful
set nocompatible

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Enhance command-line completion
set wildmenu

" Allow cursor keys in insert mode
set esckeys

" Allow backspace in insert mode
set backspace=indent,eol,start

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
set gdefault

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Increase command line history.
set history=5000

" Change mapleader
let mapleader=","

" Fuck .swps
set nobackup
set noswapfile
if exists("&undodir")
    set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Folding
set foldmethod=indent
set nofoldenable

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Highlight current line
set cursorline

" Highlight a certain column
set colorcolumn=100

" Indents, Tabs/Spaces
set autoindent    " If you're indented, new lines will also be indented
" set smartindent   " Automatically indents l`ines after opening a bracket in programming languages
set expandtab     " Inserts spaces when tab is hit
set tabstop=4     " How much space Vim gives to a tab
set smarttab      " Improves tabbing
set shiftwidth=4  " Number of spaces when indenting
set softtabstop=4 " Don't think I need this in combo with the other options

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,nbsp:_
set list

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Highlight dynamically as pattern is typed
set incsearch

" Clear previous search highlighting by hitting ESC ESC
nnoremap <ESC><ESC> :noh<CR><CR>

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=a

" Enable extended regexp.
set magic

" Hide mouse pointer while typing.
set mousehide

" Disable error bells
set noerrorbells

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Report the number of lines changed.
set report=0

" Show the cursor position
set ruler

" Don’t show the intro message when starting Vim
set shortmess=atI

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Show the (partial) command as it’s being typed
set showcmd

" Use relative line numbers
" if exists("&relativenumber")
"     set relativenumber
"     au BufReadPost * set relativenumber
" endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Set the spellchecking language.
set spelllang=en_us

" Override `ignorecase` option  if the search pattern contains
" uppercase characters.
set smartcase

" Allow cursor to be anywhere.
" set virtualedit=all

" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Strip whitespace on write for certain files
autocmd BufWritePre *.php,*.js,*.scss,*.css,*.tpl,*.html :%s/\s\+$//e

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype plugin indent on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" Autoreload files changed outside of buffer
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
autocmd FileChangedShellPost *
   \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl Nonei


" Better comment color
" highlight Comment ctermfg=Gray

" Better search and selection highlighting
hi Search cterm=NONE ctermfg=black ctermbg=yellow
hi Visual cterm=NONE ctermfg=black ctermbg=yellow

" provide hjkl movements in Insert mode via the <Alt> modifier key
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

map <C-L> 20zl " Scroll 20 characters to the right
map <C-H> 20zh " Scroll 20 characters to the left

" Map ctrl-movement keys to window switching
map <C-w> <C-w><C-w>

" Switch to alternate buffer
noremap <C-j> :bnext<cr>
noremap <C-k> :bprevious<cr>

" ----------------------------------------------------------------------
" | Use The Silver Searcher                                            |
" ----------------------------------------------------------------------
" command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag -C <SPACE>
let g:ackprg = 'ag --nogroup --nocolor --column'

" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! GetGitBranchName()

    let branchName = ""

    if exists("g:loaded_fugitive")
        let branchName = "[" . fugitive#head() . "]"
    endif

    return branchName

endfunction

" ----------------------------------------------------------------------
" | Status Line                                                        |
" ----------------------------------------------------------------------

" Terminal types:
"
"   1) term  (normal terminals, e.g.: vt100, xterm)
"   2) cterm (color terminals, e.g.: MS-DOS console, color-xterm)
"   3) gui   (GUIs)

highlight ColorColumn
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLine
    \ term=NONE
    \ cterm=NONE  ctermbg=235  ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLineNr
    \ term=bold
    \ cterm=bold  ctermbg=NONE   ctermfg=178
    \ gui=bold    guibg=#073642  guifg=Orange

highlight LineNr
    \ term=NONE
    \ cterm=NONE  ctermfg=241    ctermbg=NONE
    \ gui=NONE    guifg=#839497  guibg=#073642

highlight User1
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=Grey
    \ gui=NONE    guibg=#073642  guifg=#839496


" ----------------------------------------------------------------------
" | Plugins                                                             |
" ----------------------------------------------------------------------

"
" NERDTree
"
" autocmd VimEnter * wincmd p    " Have cursor start in file window
nmap <C-n> :NERDTreeToggle<CR>  " Map toggle to crtl-n
nmap <C-m> :NERDTreeFind<CR>   " Map show current file to ctrl-m
let NERDTreeShowHidden=1       " Show hidden files
" Better color for directories
autocmd VimEnter,ColorScheme * :hi Directory guifg=#FF0000 ctermfg=red
" Close vim if nerdtree is the only window open
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"
" Ale - linting
"
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
highlight ALEErrorSign cterm=NONE ctermfg=black ctermbg=yellow
highlight clear ALEWarningSign
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
nmap <silent> <C-S-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-S-l> <Plug>(ale_next_wrap)
let g:ale_linters = {
\   'python': ['pep8'],
\}

"
" Syntastic
"
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_loc_list_height = 5
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 1
" let g:syntastic_javascript_checkers = ['eslint']
"
" let g:syntastic_error_symbol = '❌'
" let g:syntastic_style_error_symbol = '⁉️'
" let g:syntastic_warning_symbol = '⚠️'
" let g:syntastic_style_warning_symbol = '💩'
"
" highlight link SyntasticErrorSign SignColumn
" highlight link SyntasticWarningSign SignColumn
" highlight link SyntasticStyleErrorSign SignColumn
" highlight link SyntasticStyleWarningSign SignColumn
"
" hi SpellBad ctermfg=black ctermbg=yellow
" hi SpellCap ctermfg=black ctermbg=yellow

"
" Airline
"
let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1
" Show buffer numbers next to buffer names
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline_theme='afterglow'

"
" VIM-Minimap
"
let g:minimap_highlight='Statement'


"
" NERDCommenter
"
" Add spaces after comment delimiters
let g:NERDSpaceDelims = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

"
" Indent Guides
"
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=233 " #121212
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=233

"
" Rainbow
"
let g:rainbow_active = 1

"
" CtrlP
"
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)|node_modules$'
noremap <C-b> :CtrlPBuffer<cr>

"
" vimgo
"
let g:go_auto_sameids = 1 " Auto higlight all references to symbol under the cursor
set updatetime=100 " Update status line info every 100ms
let g:go_auto_type_info = 1 " Automatically show type info in status line for type under cursor
let g:go_fmt_command = "goimports"
let g:go_decls_includes = "func,type" " Show funcs and types in declaration list
nmap <leader>gi :GoInfo<CR>  " Show method signature for a Go method in status line
nmap <leader>gd :GoDoc<CR>  " Show info for a Go method in scratch area

"
" YouCompleteMe
"
let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_min_num_of_chars_for_completion = 1
