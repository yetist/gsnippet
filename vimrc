set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"
" 来源于GitHub仓库
Plugin 'Lokaltog/vim-powerline'
Plugin 'fatih/vim-go'
Plugin 'godlygeek/tabular'
Plugin 'msanders/snipmate.vim'
Plugin 'phongvcao/vim-stardict'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/taglist.vim'
Plugin 'yetist/gnome-code.vim'
Plugin 'yetist/gtk-vim-syntax'
Plugin 'yetist/newfile.vim'

" 来源于网站 http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
Plugin 'a.vim'
Plugin 'vimplate'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""" 插件设置 """
"" vim-powerline
let g:Powerline_symbols = 'unicode'
" for a.vim, add objc support.
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "c,cpp,cxx,cc,CC,m"

" for vimplate
let Vimplate = "~/.vim/bundle/vimplate/vimplate"
                                

""" 通用全局设置 """ 
set mouse=					"关闭鼠标支持
set laststatus=2                                "总是显示状态栏
filetype indent plugin on    " 依文件类型设置自动缩进
" To ignore plugin indent changes, instead use:
filetype plugin on

"" 设置颜色
if &t_Co > 2 || has("gui_running")
    set t_Co=256
    syntax on                                   "开启语法高亮/结构强调
    set hlsearch                                "高亮显示搜索关键字
    if has("gui_running")
        set background=light
    else
        set background=dark
    endif
endif


""" 设定中文编码类型 """
scriptencoding utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,taiwan,latin1
set fileencoding=utf-8
let &termencoding = &encoding

""" 功能键定义
""<F2> 高亮显示搜索结果
""<F3> 显示/隐藏行号
""<F4> 清除高亮表达式
""<F5> 切换粘贴状态
""<F6> 行尾增加注释
""<F8> Taglist函数列表
nno <F2> :set hlsearch!<bar>set hlsearch?<CR>
nno <F3> :set nu!<bar>set nu?<CR>
"nnoremap <F3> :set nonumber!<CR>:set foldcolumn=0<CR>
nno <F4> :syn clear<CR>
set pt=<F5> tm=750 nomore modelines=5
map <F6>   <Esc><S-$>a<TAB>/*  */<Esc>3ha
nnoremap <F8> :Tlist <CR>
map <S-F6> :exe GnomeDoc()<CR>                   "Shift-F6, 运行GnomeDoc

""加载常用插件
"source $VIMRUNTIME/ftplugin/man.vim             "在vim中看man
"
"filetype plugin indent on
"
""set columns=80                                  "设置屏幕的列数
"set history=80                                  "历史
"set ruler                                       "在右下角显示行列数
"set incsearch                                   "匹配搜索关键字
"set clipboard+=unnamed
"set nolbr					"关闭整词折行,否则中文很难看
"set nobackup					"关闭备份
""set nowritebackup				"关闭备份

" 自动跳到上次打开的位置。
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \| exe "normal g'\"" | endif
    augroup python
        autocmd BufReadPre,FileReadPre *.py set tabstop=4
        autocmd BufReadPre,FileReadPre *.py set shiftwidth=4
        autocmd BufReadPre,FileReadPre *.py set expandtab
        autocmd filetype python set tabstop=4
        autocmd filetype python set shiftwidth=4
        autocmd filetype python set expandtab
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
    augroup END
    augroup vala
	autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
	autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
	autocmd BufRead,BufNewFile *.vala            setfiletype vala
	autocmd BufRead,BufNewFile *.vapi            setfiletype vala
    augroup END
    augroup objc
	autocmd BufNewFile,BufRead,BufEnter,WinEnter,FileType *.m,*.h setfiletype objc
    augroup END
    augroup html
        autocmd BufReadPre,FileReadPre *.js set tabstop=4
        autocmd BufReadPre,FileReadPre *.js set shiftwidth=4
        autocmd BufReadPre,FileReadPre *.js set expandtab
        autocmd BufReadPre,FileReadPre *.tmpl set filetype=html
        autocmd filetype html set tabstop=2
        autocmd filetype html set shiftwidth=2
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
        "autocmd filetype html set expandtab
    augroup END
    augroup yaml
        autocmd filetype yaml,lilypond set tabstop=4
        autocmd filetype yaml,lilypond set shiftwidth=4
        autocmd filetype yaml,lilypond set expandtab
    augroup END
    augroup omni
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
    autocmd FileType go set omnifunc=gocomplete#Complete
    augroup END
    augroup golang
	    au FileType go nmap <leader>r <Plug>(go-run)
	    au FileType go nmap <leader>b <Plug>(go-build)
	    au FileType go nmap <leader>t <Plug>(go-test)
	    au FileType go nmap <leader>c <Plug>(go-coverage)
    augroup END
endif
""filetype off
""set runtimepath+=/usr/share/lilypond/2.14.2/vim/
""filetype on
"
""设置自动对齐
"set cindent
"set backspace=indent,eol,start
"
""辅助显示
"set showcmd 
"set showmatch
"set showmode
"set wrap                                    "自动折行
""set list
"set cmdheight=1
""set scrollbind
""set scrolloff=0
"set sidescroll=0 wrap linebreak
""set whichwrap=b,s
""set whichwrap=<,>,[,]
"set noautowrite
"
"
""其它设置
"set path+=/usr/include,/usr/include/sys,/usr/include/gtk-2.0/gtk,/usr/include/gtk-2.0/gdk,$HOME/include
"set tags=./tags,./../tags,./**/tags,/usr/include/tags
"
"


""功能键定义
""map <home> <Esc>:call Mytitle()<CR><Esc>:$<Esc>o        
"                                                "<home>键插入C语言文件声明信息 
""map <end> <Esc>:call Myend()<CR><Esc>:$<Esc>o           
"                                                "<end>键插入C语言文件格式化信息 
"
"nno <C-w>t :tabnew<CR>
"                                                "<Ctrl>+w,t 键打开新tab
"nmap K :Man <cword><CR>
"set keywordprg=man\ -s
""set keywordprg=man
"
"nmap <C-k> :!sdcv <C-R>=expand("<cword>")<CR><CR>	"<Ctrl>+k
"
""ino <Down> <C-O>gj
""ino <Up> <C-O>gk
""nno <Down> gj
""nno <Up> gk
""
"
"let g:fencview_autodetect = 1
"
""" for vim plugins: ['scm-changelog', 'newfile']
"let g:author_name="yetist"
"let g:author_email="xiaotian.wu@i-soft.com.cn"
"let g:author_url="http://yetist.osprg.org"
"let g:author_blog="http://blog.osprg.org"
"
""" for vim plugins: ['newfile']
"let g:license="gpl3"
"
"let g:packager="yetist <yetist@gmail.com>"
"
"let g:po_translator = "yetist <xiaotian.wu@i-soft.com.cn>"
"let g:po_lang_team = "Chinese (simplified) <translation-team-zh-cn@lists.sourceforge.net>" 
"
"""vimim
"""
""let g:vimim_enable_smart_space=1
""let g:vimim_enable_dynamic_menu=1
""let g:vimim_enable_fuzzy_search=1
""let g:vimim_enable_fuzzy_pinyin=1
""let g:vimim_enable_menu_label=1
""let g:vimim_data_file="vimim.wubi.txt"
"
""
"" vala language setup
"" Disable valadoc syntax highlight
""let vala_ignore_valadoc = 1
"
"" Enable comment strings
"let vala_comment_strings = 1
"
"" Highlight space errors
"let vala_space_errors = 1
"" Disable trailing space errors
""let vala_no_trail_space_error = 1
"" Disable space-tab-space errors
"let vala_no_tab_space_error = 1
"
"" Minimum lines used for comment syncing (default 50)
""let vala_minlines = 120
""
"
"
"fun SetupVAM()
"  set runtimepath+=~/.vim/addons/vim-addon-manager
"  " commenting try .. endtry because trace is lost if you use it.
"  " There should be no exception anyway
"  " try
"  call vam#ActivateAddons([
"			  \ 'a.vim_-_Alternate_Files_quickly_.c',
"			  \ 'calendar52',
"			  \ 'Conque_Shell',
"			  \ 'devhelp',
"			  \ 'fencview',
"			  \ 'gnome-code',
"			  \ 'gnome-doc',
"			  \ 'gobgen',
"			  \ 'newfile',
"			  \ 'RST_Tables',
"			  \ 'scm-changelog',
"			  \ 'sketch',
"			  \ 'taglist',
"			  \ 'Powerline',
"			  \ 'pythoncomplete',
"			  \ ])
"  " catch /.*/
"  " echoe v:exception
"  " endtry
"endf
"call SetupVAM()
"" experimental: run after gui has been started [3]
"" option1: au VimEnter * call SetupVAM()
"" option2: au GUIEnter * call SetupVAM()
"" See BUGS sections below [*]
"
"" setup vim plugins:['vim-addon-manager'] for my own plugins.
"let g:vim_addon_manager['plugin_sources']['newfile'] = {"type":"svn", "url":"http://gsnippet.googlecode.com/svn/trunk/vim-addons/newfile"}
"let g:vim_addon_manager['plugin_sources']['scm-changelog'] = {"type":"svn", "url":"http://gsnippet.googlecode.com/svn/trunk/vim-addons/scm-changelog"}
"let g:vim_addon_manager['plugin_sources']['gnome-code'] = {"type":"svn", "url":"http://gsnippet.googlecode.com/svn/trunk/vim-addons/gnome-code"}
"let g:vim_addon_manager['plugin_sources']['devhelp'] = {"type":"svn", "url":"http://gsnippet.googlecode.com/svn/trunk/vim-addons/devhelp"}
"let g:vim_addon_manager['plugin_sources']['rpmgroups'] = {"type":"svn", "url":"http://gsnippet.googlecode.com/svn/trunk/vim-addons/rpmgroups"}
"let g:vim_addon_manager['plugin_sources']['vimim'] = {"type":"svn", "url":"http://vimim.googlecode.com/svn/trunk"}
""let g:vim_addon_manager['plugin_sources']['vim-powerline'] = {"type":"git", "url":"https://github.com/Lokaltog/vim-powerline.git"}
"set nocp
"set backspace=2                                 "影响退格键的工作
"let s:tlist_def_go_settings = 'go;c:constant;f:function;p:package;t:typedef;v:variable'
"
"
""set verbose=20
