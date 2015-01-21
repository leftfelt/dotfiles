"----------------------------------------
" Setup
"----------------------------------------
" $ mkdir -p ~/.vim/.bundle
" $ mkdir -p ~/.vim/tags
" $ vim
" 	:NeoBundleInstall
" 	:q
" $ cd ~/.vim/.bundle/vimproc
" $ make -f make_unix.mak

"----------------------------------------
" Usage
"----------------------------------------
" Ctrl+U+T カーソル下の単語の定義箇所を検索
" Ctrl+U+G カーソル下の単語を検索
" Ctrl+U+F ファイラーを開く
" Ctrl+U+O ファイル内クラス・関数一覧
" Ctrl+U+R 最近開いたファイル一覧
" Ctrl+U+B 現在開いているファイル一覧
" 
" :Createtags tagsファイルを作成する
" :PhpcsEnabled phpcsによるチェックを有効化します
" :PhpcsDisabled phpcsによるチェックを無効化します

"----------------------------------------
" plugin - NeoBundle
"----------------------------------------
if has('vim_starting')
  set runtimepath+=~/.vim/.bundle/neobundle.vim
  filetype off
  call neobundle#begin(expand('~/.vim/.bundle'))
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
NeoBundle 'vim-scripts/jshint.vim' "JSHint
NeoBundle "tsukkee/unite-tag.git" "関数定義箇所ジャンプ
call neobundle#end()
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
set ignorecase "大文字・小文字を区別しない
set wrapscan

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
""phpcs
"------------------------------------
"保存時にphpcsを実行するか
let g:phpcs_enabled = 1
" Phpcs有効化
command! -nargs=0 PhpcsEnabled :let g:phpcs_enabled = 1
" Phpcs無効化
command! -nargs=0 PhpcsDisabled :let g:phpcs_enabled = 0

"------------------------------------
"" vimfiler
"------------------------------------
"ファイルを新規タブで開くようにする
let g:vimfiler_edit_action = 'tabopen'

"------------------------------------
" unite-tag
"------------------------------------
let g:tagsdir='~/.vim/tags'
" :CreateTagsで現在開いているファイル形式のtagsファイルを作る
command! -nargs=0 CreateTags :call CreateTags()

" 現在のディレクトリ以下のtagsファイルを作成する
function! CreateTags()
	echo 'start create tags file ...'
	let ret = system(printf("ctags -R --append=yes --languages=%s -f %s/%s.tags `pwd`", &filetype, g:tagsdir, &filetype))
	echo 'complete!'
	call SetTagsFile()
endfunction

" 現在開いているファイル形式のtagsファイルを設定する
function! SetTagsFile()
	exe printf(":set tags+=%s/%s.tags",g:tagsdir, &filetype)
endfunction

"------------------------------------
"" unite.vim
"------------------------------------
"" 1なら入力モードで開始する
let g:unite_enable_start_insert=0
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

noremap <C-U><C-T> :Unite tag:<C-R><C-W><CR>

"部分一致
call unite#custom#substitute('file', '[^~.]\zs/', '*/*', 50)
call unite#custom#substitute('file', '/\ze[^*]', '/*', 30)

"uniteを開いている間のキーマッピング
function! s:unite_my_settings()"{{{
	"入力モードのときESCでノーマルモードに移動
	imap <buffer> <ESC> <Plug>(unite_insert_leave)
	"ESCでuniteを終了
	nmap <buffer> <ESC> <Plug>(unite_exit)
	"改行で別タブを開く
	inoremap <silent> <buffer> <expr> <CR> unite#do_action('tabopen')
	nnoremap <silent> <buffer> <expr> <CR> unite#do_action('tabopen')
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

"tabで補完候補の選択を行う
imap <expr><TAB>
	\ pumvisible() ? "\<Down>" :
	\ neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

"------------------------------------
"" neosnippet.vim
"------------------------------------
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"------------------------------------
"" EditCSV
"------------------------------------
function! s:edit_csv(path)
	call writefile(map(rabbit_ui#gridview(
		\ map(readfile(expand(a:path)),'split(v:val,",",1)')),
		\ "join(v:val, ',')"), expand(a:path))
endfunction

command! -nargs=1 -complete=file EditCSV  :call <sid>edit_csv(<q-args>)

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
			echo ret
		endif
	endfunction
	function! s:phpcs()
		let ret = system(printf("phpcs --standard=PSR2  %s", expand('%')))
		echo ret
	endfunction
	function! s:phpmd()
		let ret = system(printf("phpmd %s text design,unusedcode", expand('%')))
		echo ret
	endfunction
	" JSHint(保存時失敗したら警告）
	function! s:jshint()
		exe ":JSHint"
	endfunction
	"保存時に自動実行される
	function! s:save()
		if &filetype == "php"
			call s:phplint()
			call s:phpmd()
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
		call SetTagsFile()
	endfunction

	"保存した時に save()を自動実行
	au BufWritePost * call s:save()
	"開いた時に read()を自動実行
	au BufReadPost * call s:read()

augroup END
