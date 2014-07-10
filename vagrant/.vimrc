set ambiwidth=double

syntax on

colorscheme heiz_color


if has('vim_starting')
    set nocompatible               " be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

set number
set expandtab
set softtabstop=4
set shiftwidth=2
set modelines=0
set autoindent
set smartindent
set cindent
set title
set ruler
set list
set listchars=tab:>\ ,extends:<
set nobackup
set noswapfile
set nocompatible
set showmatch
set pastetoggle=<C-E>

vnoremap <silent> > >gv
vnoremap <silent> < <gv
" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=red guibg=darkgray
match ZenkakuSpace /　/
set ttyfast " 高速ターミナル接続を行う


autocmd FileType php        setlocal ts=2 sts=2 sw=2 "et
autocmd FileType c          setlocal ts=4 sw=4 noexpandtab cindent
autocmd FileType java       setlocal ts=4 sts=4 sw=4 et
autocmd FileType html,xhtml,css,scss,javascript,coffee,sh,sql,yaml      setlocal ts=2 sts=2 sw=2 et

" for rails
autocmd BufNewFile,BufRead app/*/*.erb    setlocal ft=eruby fenc=utf-8
autocmd BufNewFile,BufRead app/**/*.rb    setlocal ft=ruby  fenc=utf-8
autocmd BufNewFile,BufRead app/**/*.yml   setlocal ft=ruby  fenc=utf-8
autocmd BufNewFile,BufRead *.cap          setlocal ft=ruby  fenc=utf-8
autocmd FileType ruby,haml,eruby,sass,mason setlocal ts=2 sts=2 sw=2 et nowrap

autocmd FileType * setlocal formatoptions-=ro

set wildmenu " コマンド補完を強化
set wildchar=<tab> " コマンド補完開始キー
set wildmode=list:longest " リスト表示
set history=1000 " コマンド・検索パターン履歴数
set laststatus=2

" マウス操作の有効とyankのクリップボードの共有
 set mouse=a
 set guioptions+=a

if has('clipboard')
  set clipboard=unnamed,autoselect
endif


NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'scrooloose/syntastic'
""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

NeoBundle 'alpaca-tc/alpaca_tags'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'bbatsov/rubocop'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'

let g:neocomplcache_enable_at_startup = 1

filetype plugin indent on     " required!
autocmd Filetype * set formatoptions-=ro

" augroup init (from tyru's vimrc)
augroup vimrc
  autocmd!
augroup END

command!
    \ -bang -nargs=*
    \ MyAutocmd
    \ autocmd<bang> vimrc <args>

" 編集中の行に下線を引く
MyAutocmd InsertLeave * setlocal nocursorline
MyAutocmd InsertEnter * setlocal cursorline
MyAutocmd InsertLeave * highlight StatusLine ctermfg=145 guifg=#c2bfa5 guibg=#000000
MyAutocmd InsertEnter * highlight StatusLine ctermfg=12 guifg=#1E90FF

"------------------------------------
" neosnippet
"------------------------------------
" neosnippet "{{{
 
" snippetを保存するディレクトリを設定してください
" example
" let s:default_snippet = neobundle#get_neobundle_dir() .
" '/neosnippet/autoload/neosnippet/snippets' " 本体に入っているsnippet
" let s:my_snippet = '~/snippet' " 自分のsnippet
" let g:neosnippet#snippets_directory = s:my_snippet
" let g:neosnippet#snippets_directory = s:default_snippet . ',' . s:my_snippet
let s:my_snippet = '~/snipet/ruby_snip' " 自分のsnippet
imap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
inoremap <silent><C-U>            <ESC>:<C-U>Unite snippet<CR>
nnoremap <silent><Space>e         :<C-U>NeoSnippetEdit -split<CR>
smap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
" xmap <silent>o
" <Plug>(neosnippet_register_oneshot_snippet)
"}}}


let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" lightline.vim
let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [
        \     ['mode', 'paste'],
        \     ['fugitive', 'gitgutter', 'filename'],
        \   ],
        \   'right': [
        \     ['lineinfo', 'syntastic'],
        \     ['percent'],
        \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'charcode': 'MyCharCode',
        \   'gitgutter': 'MyGitGutter',
        \ },
        \ 'separator': {'left': '⮀', 'right': '⮂'},
        \ 'subseparator': {'left': '⮁', 'right': '⮃'}
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
         \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
         \  &ft == 'unite' ? unite#get_status_string() :
         \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
         \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
         \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction


function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
       \ || ! get(g:, 'gitgutter_enabled', 0)
       \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
                 \ g:gitgutter_sign_added . ' ',
                 \ g:gitgutter_sign_modified . ' ',
                 \ g:gitgutter_sign_removed . ' '
                 \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

" https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
function! MyCharCode()
  if winwidth('.') <= 70
    return ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    return 'NUL'
  endif

  " Zero pad hex values
  let nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in
    " unicode files
    let nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from
  " the return value of :ascii This matches the two
  " first pieces of the return value, e.g. "<F>  70" => char: 'F', nr: '70'
  let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let nr = printf(nrformat, nr)

  return "'". char ."' ". nr
endfunction

