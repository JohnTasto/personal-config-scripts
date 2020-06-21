" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Jun 13
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200      " keep 200 lines of command line history
set showcmd          " display incomplete commands
set wildmenu         " display completion matches in a status line

set ttimeout         " time out for key codes
set ttimeoutlen=100  " wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif


" http://learnvimscriptthehardway.stevelosh.com/
" https://devhints.io/vimscript
" http://www.viemu.com/vi-vim-cheat-sheet.gif


" tabs
" 8 is required for help to look right, might want to change automatically
set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" add <> to brace matching
set matchpairs+=<:>

set splitright

set encoding=utf-8


set background=dark

" bg is always turns gray when reversed?
"  0 - Black
"  1 - DarkRed
"  2 - DarkGreen
"  3 - Brown, DarkYellow
"  4 - DarkBlue
"  5 - DarkMagenta
"  6 - DarkCyan
"  7 - LightGray, Gray
"  8 - DarkGray
"  9 - Red
" 10 - Green
" 11 - Yellow
" 12 - Blue
" 13 - Magenta
" 14 - Cyan
" 15 - LightGray, Gray (fg white if reversed)

let s:status_in_fg=7
let s:status_in_bg=8
let s:status_mid_fg=0
let s:status_mid_bg=3
let s:status_out_fg=0
let s:status_out_bg=11

let s:status_normal_fg=0
let s:status_normal_bg=4
let s:status_insert_fg=0
let s:status_insert_bg=2
let s:status_replace_fg=0
let s:status_replace_bg=1
let s:status_visual_fg=0
let s:status_visual_bg=7
let s:status_select_fg=15
let s:status_select_bg=7
let s:status_terminal_fg=2
let s:status_terminal_bg=0
let s:status_other_fg=9
let s:status_other_bg=1

execute 'highlight User1 cterm=NONE ctermfg='.s:status_out_fg.' ctermbg='.s:status_out_bg
execute 'highlight User2 cterm=NONE ctermfg='.s:status_mid_bg.' ctermbg='.s:status_out_bg

execute 'highlight User3 cterm=NONE ctermfg='.s:status_mid_fg.' ctermbg='.s:status_mid_bg
execute 'highlight User4 cterm=NONE ctermfg='.s:status_out_bg.' ctermbg='.s:status_mid_bg
execute 'highlight User7 cterm=NONE ctermfg='.s:status_in_bg.' ctermbg='.s:status_mid_bg

execute 'highlight User5 cterm=NONE ctermfg='.s:status_in_fg.' ctermbg='.s:status_in_bg
execute 'highlight User6 cterm=NONE ctermfg='.s:status_mid_bg.' ctermbg='.s:status_in_bg
execute 'highlight User8 cterm=NONE ctermfg='.s:status_out_bg.' ctermbg='.s:status_in_bg
execute 'highlight User9 cterm=NONE ctermfg='.s:status_mid_fg.' ctermbg='.s:status_in_bg

highlight clear StatusLine
highlight clear StatusLineNC
highlight clear StatusLineTerm
highlight clear StatusLineTermNC

" NC can only change bg_color if UserN == !NC
execute 'highlight StatusLine cterm=NONE ctermfg=8 ctermbg=8'
execute 'highlight StatusLineNC cterm=NONE ctermfg=0 ctermbg=8'
execute 'highlight StatusLineTerm cterm=NONE ctermfg=8 ctermbg=8'
execute 'highlight StatusLineTermNC cterm=NONE ctermfg=0 ctermbg=8'
" execute 'highlight StatusLine term=bold,reverse cterm=bold,reverse gui=bold,reverse'
" execute 'highlight StatusLineNC term=reverse cterm=reverse gui=reverse'
" execute 'highlight StatusLineTerm term=bold,reverse cterm=bold ctermfg=0 ctermbg=121 gui=bold guifg=bg guibg=LightGreen'
" execute 'highlight StatusLineTermNC term=reverse ctermfg=0 ctermbg=121 guifg=bg guibg=LightGreen'

execute 'highlight VertSplit cterm=NONE ctermfg='.s:status_in_bg.' ctermbg='.s:status_in_bg

highlight Comment ctermfg=8


function! SetStatusModeColor(mode)
  let l:fg = s:status_{a:mode}_fg
  let l:bg = s:status_{a:mode}_bg
  execute 'highlight StatusMode cterm=NONE ctermfg='.l:fg.' ctermbg='.l:bg
  execute 'highlight StatusModeBlend cterm=NONE ctermfg='.l:bg.' ctermbg='.s:status_out_bg
endfunction

function! CurrentMode()
  let l:mode = mode()
  if l:mode ==# 'n'
    call SetStatusModeColor('normal')
    return 'Normal'
  elseif l:mode ==# 'i'
    call SetStatusModeColor('insert')
    return 'Insert'
  elseif l:mode ==# 'R' || l:mode ==# 'Rv'
    call SetStatusModeColor('replace')
    if l:mode ==# 'R'  | return 'Replace' | endif
    if l:mode ==# 'Rv' | return 'Veplace' | endif
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
    call SetStatusModeColor('visual')
    if l:mode ==#  'v' | return 'V-Char'  | endif
    if l:mode ==#  'V' | return 'V-Line'  | endif
    if l:mode ==# '^V' | return 'V-Block' | endif
  elseif l:mode ==# 's' || l:mode ==# 'S' || l:mode ==# '^S'
    call SetStatusModeColor('select')
    if l:mode ==#  's' | return 'S-Char'  | endif
    if l:mode ==#  'S' | return 'S-Line'  | endif
    if l:mode ==# '^S' | return 'S-Block' | endif
  elseif l:mode ==# 't'
    call SetStatusModeColor('terminal')
    return 'Terminal'
  else
    call SetStatusModeColor('other')
    if false return
    elseif l:mode ==# 'no' | return 'Operator'
    elseif l:mode ==# 'c'  | return 'Command'
    elseif l:mode ==# 'cv' | return 'Vim Ex'
    elseif l:mode ==# 'ce' | return 'Ex'
    elseif l:mode ==# 'r'  | return 'Prompt'
    elseif l:mode ==# 'rm' | return 'More'
    elseif l:mode ==# 'r?' | return 'Confirm'
    elseif l:mode ==# '!'  | return 'Shell'
    else return l:mode | endif
endfunction

function! LineEndings()
  if &fileformat ==# 'dos'  | return 'CRLF' | endif
  if &fileformat ==# 'unix' | return 'LF'   | endif
  if &fileformat ==# 'mac'  | return 'CR'   | endif
endfunction

function! IndentStyle()
  return &expandtab ? 'Spaces' : 'Tabs'
endfunction

function! IndentAmount()
  if ! &expandtab | return &tabstop
  elseif &shiftwidth == &softtabstop | return &shiftwidth
  else | return &softtabstop . '-' . &shiftwidth
  endif
endfunction

set laststatus=2

function! ActiveStatus()
  let statusline=""
  let statusline.="%#StatusMode# "
  let statusline.="%{CurrentMode()}"
  let statusline.=" %#StatusModeBlend#%1* "
  let statusline.="Ξ%{bufnr('%')}"
  let statusline.=" %4*%3* "
  let statusline.="%{&readonly ? '\ ' : ''}"
  let statusline.="%{&previewwindow? 'Preview\ ' : ''}"
  let statusline.="%{&modified ? '∗\ ' : ''}"
  let statusline.="%6*%5* "
  let statusline.="%F"
  let statusline.="%="
  let statusline.="☰ %8*%l%5*/%L %8*%v%5*-%c"
  let statusline.=" %6*%3* "
  let statusline.="%{IndentStyle()}: %{IndentAmount()}"
  let statusline.=" %7*%3* "
  let statusline.="%{&fileencoding}"
  let statusline.=" %7*%3* "
  let statusline.="%{LineEndings()}"
  let statusline.=" %4*%1* "
  let statusline.="%{&filetype}"
  let statusline.=" %*"
  return statusline
endfunction

function! InactiveStatus()
  let statusline=""
  let statusline.="%5* "
  let statusline.="%{CurrentMode()}"
  let statusline.=" %9*%5* "
  let statusline.="Ξ%{bufnr('%')}"
  let statusline.=" %9*%5* "
  let statusline.="%{&readonly ? '\ ' : ''}"
  let statusline.="%{&previewwindow? 'Preview\ ' : ''}"
  let statusline.="%{&modified ? '∗\ ' : ''}"
  let statusline.="%9*%5* "
  let statusline.="%F"
  let statusline.="%="
  let statusline.="☰ %l/%L %v-%c"
  let statusline.=" %9*%5* "
  let statusline.="%{IndentStyle()}: %{IndentAmount()}"
  let statusline.=" %9*%5* "
  let statusline.="%{&fileencoding}"
  let statusline.=" %9*%5* "
  let statusline.="%{LineEndings()}"
  let statusline.=" %9*%5* "
  let statusline.="%{&filetype}"
  let statusline.=" %*"
  return statusline
endfunction

"  branch     lock     LN     CN     <<     <     >     >>

set statusline=%!ActiveStatus()

augroup status
  autocmd!
  autocmd WinEnter * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave * setlocal statusline=%!InactiveStatus()
augroup END

" https://gist.github.com/ericbn/f2956cd9ec7d6bff8940c2087247b132
" https://www.reddit.com/r/vim/comments/6b7b08/my_custom_statusline/?st=jc4oipo5&sh=d41a21b1


" whitespace
set list
set listchars=tab:·\ ,trail:∙,precedes:«,extends:»,conceal:•,nbsp:·

" search
set hlsearch
set ignorecase
set smartcase
set wildmode=longest,list

" for <leader> and <localleader> in mappings
" local is specific to file type
let mapleader = "-"
let maplocalleader = "\\"

" quickly open/reload .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" enter Normal mode with jkl - it is easier than stretching to <ESC>
inoremap jk <esc>
inoremap <esc> <nop>

" enter Terminal-Normal mode with same key combo
" tnoremap jk <C-W>N

" wrte as sudo
command SWrite execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
command SW SWrite

" set comment shortcut when FileType set
" :help autocmd-events
" augroup commentgroup
"   autocmd!
"   autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
"   autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>
" augroup END

" i( = inside parentheses
" onoremap p i(

" :<c-u>normal! ...<cr> = execute in normal mode
" f(vi( = find next (, then visually select inside parentheses
" onoremap in( :<c-u>normal! f(vi(<cr>
" onoremap il( :<c-u>normal! F)vi(<cr>

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
" nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
" nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
