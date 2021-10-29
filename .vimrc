set nocompatible

set ruler
set number

set cursorline
set hlsearch
set smartcase
set ignorecase

set tabstop=4
set softtabstop=4
set expandtab
set smarttab

set autoread
"set hidden

set pastetoggle=<F3>

set autoindent

set wildmode=list:longest,full
set completeopt=longest,menuone

set enc=utf8
set fileencodings=utf-8

set foldenable
set foldmethod=marker
set foldlevelstart=99

"set timeoutlen=400

set tags+=.tags

set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//
set undofile

set mouse=a

set laststatus=2

set textwidth=0
set wrapmargin=0
set wrap
set scrolloff=8

set showmatch

" clipboard support is only available with installing gvim on Arch
set clipboard=unnamedplus

syntax on
set t_Co=256
colorscheme onehalflight

filetype on
filetype plugin on
filetype indent on

" remove blank lines from end of file
"autocmd BufWritePre        *                :%s#\($\n\)\+\%$##e
" trim whitespace
"autocmd BufWritePre        *                :%s/\s\+$//e

autocmd FileType python                     setl colorcolumn=99
autocmd FileType python                     :iabbrev pdb import pdb; pdb.set_trace()
autocmd FileType javascript,javascriptreact,typescript,typescriptreact      setl tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType html,htmldjango            setl tabstop=2 softtabstop=2 shiftwidth=2

" python indentation
let g:pyindent_open_paren = 'shiftwidth()'
let g:pyindent_continue = 'shiftwidth()'

" NERDTree
"autocmd BufWinEnter * silent NERDTreeMirror
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" ALE
let g:ale_fixers = {
\	'*': ['remove_trailing_lines', 'trim_whitespace'],
\	'python': ['black'],
\	'javascript': ['prettier', 'eslint'],
\       'javascriptreact': ['prettier', 'eslint'],
\       'typescript': ['prettier', 'eslint'],
\       'typescriptreact': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1

" FZF
set rtp+=/usr/bin/fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen, smartcase, glob)
  if (a:glob != '')
      let l:glob_flag = ' --glob="' . a:glob . '"'
  else
      let l:glob_flag = ''
  endif
  let command_fmt = 'rg --column --line-number --no-heading --color=always' . a:smartcase . l:glob_flag .' -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0, ' --smart-case', '')
command! -nargs=* -bang RGC call RipgrepFzf(<q-args>, <bang>0, '', '')

function! RipgrepFzfWithGlob(qargs, fullscreen)
  let l:args = split(a:qargs, ' ')
  let l:glob = args[0]
  let l:query = join(l:args[1:], ' ')
  call RipgrepFzf(l:query, a:fullscreen, '', l:glob)
endfunction
command! -nargs=+ -bang RGG call RipgrepFzfWithGlob(<q-args>, <bang>0)

nnoremap <C-p> :FZF<CR>

" open blame on github
function GitHubBlame()
    let line_number = line(".")
    let file_path = @%
    let remote = substitute(system('git config --get remote.origin.url'), '\n', '', 'g')
    let url = 'https://github.com/' . substitute(remote, 'git@github\.com:', '', 'g')
    let full_url = substitute(url, '\.git', '', 'g') . '/blame/master/' . file_path . '#L' . line_number
    call system('chromium ' . full_url)
    echom 'opening ' . full_url
endfunction
