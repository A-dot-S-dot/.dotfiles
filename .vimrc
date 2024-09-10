"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob('~/.vim/plugged/wiki.vim'))
  execute '!git clone git@github.com:A-dot-S-dot/wiki.vim.git ~/.vim/plugged/wiki.vim'
        \.. ' && git -C ~/.vim/plugged/wiki.vim remote add upstream https://github.com/lervag/wiki.vim.git'
        \.. ' && git -C ~/.vim/plugged/wiki.vim remote -v'
  helptags ~/.vim/plugged/wiki.vim/doc
endif

call plug#begin('~/.vim/plugged')
"{{ Appearance }}
  Plug 'itchyny/lightline.vim'                        " Lightline statusbar
  Plug 'arcticicestudio/nord-vim'
  Plug 'ericbn/vim-solarized'
"{{ Tim Pope Plugins }}
  Plug 'tpope/vim-fugitive'                           " Git support
  Plug 'tpope/vim-surround'                           " Change surrounding marks
  Plug 'tpope/vim-unimpaired'                         " Pairs of handy bracket mappings
  Plug 'tpope/vim-commentary'                         " Comment stuff out
"{{ Coding }}
  Plug 'airblade/vim-gitgutter'                       " Git diff markers
  Plug 'lervag/vimtex'                                " Latex plugin
  Plug 'sirver/ultisnips'                             " snippets for faster coding
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'
"{{ Miscellaneous }}
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
  Plug '~/.vim/plugged/wiki.vim'
  Plug 'dyng/ctrlsf.vim'
call plug#end()

filetype plugin indent on    " required
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set path+=**                                " Searches current directory recursively
set cursorline                              " Highlight the text line of the cursor.
set wildmenu			                          " Display all matches when tab complete.
set incsearch                               " Incremental search
set shortmess-=S                            " Show search match count
set ignorecase                              " No case sensitivity (needed for smart case)
set smartcase                               " Smart case sensitivity
set hidden                                  " Needed to keep multiple buffers open
set nobackup                                " No auto backups
set nocompatible
set noswapfile                              " No swap
set t_Co=256                                " Set if term supports 256 colors.
set number relativenumber                   " Display line numbers
set mouse=nicr                              " Set mouse scrolling
set complete+=k                             " Add dictionary completion
set shell=/bin/fish
set splitright
syntax enable
set termguicolors
let g:rehash256 = 1
set spelllang=en,de

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=2                " One tab == two spaces.
set tabstop=2                   " One tab == two spaces.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Format on save
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FormatBuffer()
  let cursor_position = getpos(".")
  %s/\s\+$//e            " Trim trailing whitespaces
  %s/\v($\n\s*)+%$//e    " Trim blank lines at the end
  call setpos(".", cursor_position)
endfunction

autocmd BufWritePre * :call FormatBuffer()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoreabbrev H vert h

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set leader keys
nnoremap <space> <Nop>
let mapleader = " "
let maplocalleader = " m"

" .vimrc
nmap <leader>vm :edit $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>

" editing
nnoremap Y y$

" Spelling
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <leader>ts :set spell!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Choose color scheme
set background=light
colorscheme nord

" Lighline
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ }

set laststatus=2
set noshowmode

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => netrw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nmap <buffer> h -^
  nmap <buffer> l <CR>
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=100

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimtex
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmgs'
let g:vimtex_format_enabled=1
set fillchars=fold:\              " Use space as fill character

" Setup delimiters
let g:vimtex_delim_toggle_mod_list = [
  \ ['\bigl', '\bigr'],
  \ ['\Bigl', '\Bigr'],
  \ ['\biggl', '\biggr'],
  \ ['\Biggl', '\Biggr'],
  \]

" Setup textidote
let g:vimtex_grammar_textidote = {
  \ 'jar': '/usr/share/java/textidote.jar',
  \ 'args':'',
  \}

augroup VimTeX
  autocmd!
  autocmd QuickFixCmdPost lmake lwindow
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Snippets Manager
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pandoc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pandoc#biblio#bibs = ['/home/alexey/Nextcloud/Library/bibliography.bib']
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#modules#disabled = ["folding"]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlSF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>ff :CtrlSF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Wiki.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:wiki_root = '~/Nextcloud/Notes/Wiki'
let g:wiki_completion_enabled = 0

let g:wiki_viewer = {
  \ 'md' : ':edit',
  \ 'jpg' : 'feh',
  \ 'jpeg' : 'feh'
  \}

let g:wiki_templates = [
  \ { 'match_re':  '^0x',
  \   'source_filename': '/home/alexey/.vim/.template.md'},
  \ { 'match_func': {x -> v:true},
  \   'source_filename': '/home/alexey/.vim/.index_template.md'},
  \]

let g:wiki_link_creation = {
  \ 'md': {
  \   'link_type': 'md',
  \   'url_extension': '.md',
  \   'url_transform': { x ->
  \     custom#GetRandomPageName()},
  \ },
  \}

let g:wiki_select_method = {
  \ 'pages': function('custom#OpenWikiPage'),
  \ 'tags': function('wiki#fzf#tags'),
  \ 'toc': function('wiki#fzf#toc'),
  \ 'links': function('custom#AddWikiLink'),
  \}

let g:wiki_fzf_opts = '--preview "bat --language=LaTeX --style=numbers --color=always {1}" --exact'
let g:wiki_fzf_pages_opts = g:wiki_fzf_opts
let g:wiki_fzf_links_opts = g:wiki_fzf_opts

nmap <leader>ww :call custom#OpenWikiPage() <CR>
