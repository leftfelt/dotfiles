"----------------------------------------
" plugin - NeoBundle
"----------------------------------------
if has('vim_starting')
  set runtimepath+=~/.vim/.bundle/neobundle.vim
filetype off
  call neobundle#rc(expand('~/.vim/.bundle'))
  filetype plugin on
  filetype indent on
endif

NeoBundleFetch 'Shougo/neobundle.vim.git'
NeoBundle 'Shougo/neocomplcache.git' "自動補完
NeoBundle 'Shougo/vimproc.git' "cd ~/.vim/.bundle/vimprocしてmake -f make_unix.mak
NeoBundle 'Shougo/neosnippet.git' "補完
NeoBundle 'honza/vim-snippets.git' "補完
NeoBundle 'Shougo/unite.vim.git' "ファイラ・ランチャ等
NeoBundle 'Shougo/vimfiler.git' "ファイラ・ランチャ等
NeoBundle 'Sixeight/unite-grep.git' "uniteにgrep結果表示
NeoBundle 'h1mesuke/unite-outline.git' "クラス・関数一覧表示、ジャンプ
NeoBundle 'kana/vim-smartchr' "自動置換
NeoBundle 'vim-scripts/jshint.vim' "JSHint

if has('win32') + has('win64')
	let ostype = "Win"
elseif has('mac')
	let ostype = "Mac"
else
	let ostype = system("uname")
endif

syntax on
set autoread
set number
set showmode
set showmatch
set autoindent
set incsearch
set wildmenu wildmode=list:full
set modifiable

set backspace=start,eol,indent "バックスペースでなんでも消せるように
set whichwrap=b,s,[,],<,>,~ "左右キーで次行頭・前行末にいけるように
set laststatus=2
set statusline=%f%r%h%=
set tabstop=4
set hlsearch
set fileformat=unix
if ostype == "Win"
	set term=xterm
endif

" tagsファイル読み込み
set tags=~/.tags

"タブ・行末スペース・改行・省略を表示
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" 全角スペースのハイライト
highlight ZenkakuSpace ctermbg=cyan guibg=cyan
match ZenkakuSpace /　/
"ポップアップメニューの色
highlight Pmenu ctermbg=gray ctermfg=black
highlight PmenuSel ctermbg=red ctermfg=white
highlight PmenuSbar ctermbg=gray ctermfg=black

"------------------------------------
""php
"------------------------------------
"保存時にphpcsを実行するか
let g:phpcs_enabled=1

"------------------------------------
"" vim-smartchr
"------------------------------------
"自動でスペースを付ける
"inoremap <expr> = smartchr#one_of(' = ', ' == ', ' === ', '=')
"inoremap <expr> + smartchr#one_of(' + ', '++', '+')
"inoremap <expr> - smartchr#one_of(' - ', '--', '-')
"inoremap <expr> * smartchr#one_of(' * ', '*')
"inoremap <expr> / smartchr#one_of(' / ', '// ', '/')
"inoremap <expr> & smartchr#one_of(' & ', ' && ', '&')
"inoremap <expr> % smartchr#one_of(' % ', '%')
"inoremap <expr> . smartchr#one_of('.', '->')

"------------------------------------
"" vimfiler
"------------------------------------
"ファイルを新規タブで開くようにする
let g:vimfiler_edit_action = 'tabopen'

"------------------------------------
"" unite.vim
"------------------------------------
"" 入力モードで開始する
let g:unite_enable_start_insert=1
"file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''
" バッファ一覧（今開いているファイル一覧）
noremap <C-U><C-B> :Unite buffer<CR>
" ファイル一覧
noremap <C-U><C-F> :VimFiler -split -simple -winwidth=35 -quit<CR>
" 最近使ったファイルの一覧
noremap <C-U><C-R> :Unite file_mru<CR>
" クラス・関数一覧
noremap <C-U><C-O> :Unite outline<CR>
" カーソル下の単語でgrepした結果をuniteに表示 「<C-R><C-W>」でカーソル下の単語を入力しておく
noremap <C-U><C-G> :Unite grep<CR><CR><C-R><C-W><CR>

"部分一致
call unite#custom#substitute('file', '[^~.]\zs/', '*/*', 50)
call unite#custom#substitute('file', '/\ze[^*]', '/*', 30)

"uniteを開いている間のキーマッピング
function! s:unite_my_settings()"{{{
	"入力モードのときESCでノーマルモードに移動
	imap <buffer> <ESC> <Plug>(unite_insert_leave)
	"ESCでuniteを終了
	nmap <buffer> <ESC> <Plug>(unite_exit)
	"改行で横に分割して開く
	inoremap <silent> <buffer> <expr> <CR> unite#do_action('vsplit')
	nnoremap <silent> <buffer> <expr> <CR> unite#do_action('vsplit')
	"TABで移動
	inoremap <buffer> <TAB> <Down>
endfunction"}}}
autocmd FileType unite call s:unite_my_settings()
"------------------------------------
"" neocomplcache.vim
"------------------------------------
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化
"ポップアップメニューで表示される候補の数。初期値は100
let g:neocomplcache_max_list = 20
"m_sと入力するとm*_sと解釈され、mb_substr等にマッチする。
let g:neocomplcache_enable_underbar_completion = 0
"大文字小文字を区切りとしたあいまい検索を行うかどうか。
""DTと入力するとD*T*と解釈され、DateTime等にマッチする。
let g:neocomplcache_enable_camel_case_completion = 0
"補完を開始する最小文字数
let g:neocomplcache_min_syntax_length = 2
"BSで補完ウィンドウを閉じる
inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<BS>"
"改行で補完候補の確定
inoremap <expr><CR> neocomplcache#close_popup() ? "" : "\<CR>"

"------------------------------------
"" neosnippet.vim
"------------------------------------
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"------------------------------------
"" SuperTab
"------------------------------------
"tabで補完候補の選択を行う
imap <expr><TAB>
	\ pumvisible() ? "\<Down>" :
	\ neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

"------------------------------------
"" auto command
"------------------------------------
augroup Autocmd
	au!
	"辞書ファイルを設定し直す
	function! s:setSnippetsDirectory()
		" 辞書ファイルの場所
		let g:neosnippet#snippets_directory='~/.vim/.bundle/vim-snippets/snippets/'
	endfunction
	" PHPLint(保存時失敗したら警告）
	function! s:phplint()
		let ret = system(printf("php -l %s", expand('%')))
		if ret !~ '^No.*'
			echomsg ret
		endif
	endfunction
	function! s:phpcs()
		let ret = system(printf("phpcs --standard=PSR2  %s", expand('%')))
		ret =  substitute(ret,' ','\n','g')
		echomsg ret
	endfunction
	" JSHint(保存時失敗したら警告）
	function! s:jshint()
		exe ":JSHint"
	endfunction
	"保存時に自動実行される
	function! s:save()
		if &filetype == "php"
			call s:phplint()
			if g:phpcs_enabled == 1
				call s:phpcs()
			endif
		elseif &filetype == "javascript"
			call s:jshint()
		endif
	endfunction
	"読み込み時に自動実行される
	function! s:read()
		call s:setSnippetsDirectory()
	endfunction

	"保存した時に save()を自動実行
	au BufWritePost * call s:save()
	"開いた時に read()を自動実行
	au BufReadPost * call s:read()
augroup END
