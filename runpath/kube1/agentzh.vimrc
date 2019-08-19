" An example for a vimrc file.
"
" Maintainer:	Yichun Zhang <yichun@openresty.com>
" Credit: Bram Moolenaar <Bram@vim.org> and Audrey Tang
" Last change:	2019 Aug 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
" Metadata: {{{
    set nocompatible
    set title
    let g:Header_name="Yichun Zhang"
    let g:Header_email="agentzh@gmail.com"
" }}}
" Encodings: {{{
    set termencoding=utf-8
    set encoding=utf-8
    set fileencodings=utf8,big5-hkscs,utf-8,iso8859-1
    set expandtab
    set grepprg=grep\ -nH\ $*
    " ,gbk,euc-jp,euc-kr,utf-bom,iso8859-1
" }}}
" Terminal: {{{
"noremap Bs Del
"noremap Del Bs
"noremap!Bs Del
"noremap!Del Bs
set bs=2
"noremap! <Del> <BS>
"noremap! <BS> <Del>

    " insert-mode cursors
    "map! OA ka
    "map! OB ja
    "map! OC lli
    "map! OD i

    " Alt now serves as window commands (^W)
    "noremap  
    "norgmap <Tab> p
    noremap gh <C-W>h
    noremap gk <C-W>k
    noremap gl <C-W>l
    noremap gj <C-W>j
    noremap F gf
" }}}
" Utilities: {{{
" }}}
" Utilities: {{{
"   map <C-A> :!svk add '%'
"   map <C-D> :!svk di '%'
"   map <C-U> :!svk pull
"   map <C-I> :!svk ci
    "map W :!chmod +w %
" }}}
" Environment: {{{
    "set shiftround
    set writeany autoread autowrite
    set tabstop=8               " so tabs look right for us 
    set softtabstop=4
    set shiftwidth=4            " so ^T and << are smaller 
    set report=1                " so we our told whenever we affect more than 1 line 
    set nomesg                  " because being talked to during an edit is aggravating
    set autoindent              " so i don't have to tab in 

    set wrap
    set breakat= 
    "set wrapmargin=1            " Wrap slightly in from the margin
    set linebreak
    "set virtualedit=block       " 'Free' editing in visual block mode
    set dictionary+=/usr/share/dict/words " dictionary

    set splitbelow              " horizontally split below
    set splitright              " vertically split to the right

    set smartcase               " be sensible when searching 'ic'
    set incsearch
    set hlsearch
    "set ttyfast
    set timeoutlen=500          " Fastish for slow connections
" }}}
" Shortcuts: {{{
    "       edit previously editted file
    "noremap =   :MBEbn
    "       write out the file
    "map  :w!
    " noremap  
    "       split line
    " map * i
    "       because it's easier to type
    "noremap g G
    "noremap G g
    "       so we return to exact position
    map ' `
    "       so Y is analagous to C and D
    map Y y$
    "       single-key save+quit
    map Q :wq
    "       go to next file in arg list, same position 
    map  :n +/
    "       set textwidth to cursor's column
    "map #tw :set textwidth=<C-R>=col(".")<C-M>
" }}}
" Commands: {{{
    " Sorting, uniquing and shuffling
    command -nargs=* -range=% Sort <line1>,<line2>!sort <args>
    command -nargs=* -range=% Uniq <line1>,<line2>!uniq <args>
    command -nargs=* -range=% Rand <line1>,<line2>!rand <args>

    command Nl :if (&nu) <Bar> set nonu <Bar> else <Bar> set nu <Bar> endif

    command Q :q!
    command W :w!
    command Wq :wq!
    command WQ :wq!
" }}}
" Perl: {{{
    map <C-P> :make
    map <F4> :call MakeTest()
    
    fun! MakeTest()
        set makeprg=make\ test
        make
        set makeprg=perl\ %
    endfun

    let current_compiler = "perl"

    autocmd FileType perl set makeprg=perl\ -w\ %
    autocmd FileType perl6 set makeprg=pugs\ %
    autocmd FileType scheme set makeprg=mzscheme\ -g\ -r\ %
    autocmd FileType scheme set shiftwidth=2
    autocmd FileType mzperl set makeprg=mzperl\ %
    autocmd FileType mzperl set shiftwidth=2
    autocmd FileType imc set makeprg=parrot\ %

    let perl_include_POD=1
    let perl_want_scope_in_variables=1
    let perl_extended_vars=1
    let perl_fold=1
" }}}
" Filetypes: {{{
    filetype indent on
    filetype plugin on

    " Ignore filenames with any of the following suffices
    set suffixes+=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.class.,~
    set suffixes+=.o,.bbl,.log,.blg,.ilg,.ind,.toc,.pdf,.lof

    " Suffices when doing 'gf' stuff.
    set suffixesadd+=.html,.pl,.pm,.tex,.sty,.css,.xml,.xsd,.txt,.ict
    set suffixesadd+=.shtml,.phtml,.ehtml,.epl,.rss,.rdf,.pod,.asp
    if has("wildignore") | set wildignore+=&suffixes | endif

    fun! FTCheck()
        let lines = getline(1)
        if lines =~? "\[<%]\[#&% ]"
            setf mason
        elseif lines =~? "--- #YAML:"
            setf yaml
        elseif lines =~? "[%"
            setf tt2
        elseif lines =~? "==="
            setf diff
        elseif lines =~? "pugs"
            setf perl6
        endif
    endfun
" }}}
" Color: {{{
    syntax on
    set bg=dark
    let html_number_color=1
    "colorscheme darkblue
    "colorscheme ron
    "colorscheme peachpuff
    colorscheme delek
    "colorscheme print_bw
    "colorscheme habiLight
    "colorscheme proton
    "colorscheme blueshift
    "colorscheme desert
" }}}
" Folding: {{{
    set foldmethod=marker
    set foldtext=AutFoldText()
    set nofoldenable

    function ExpandTo(xlen,xstr)
        let hey = a:xstr
        while strlen(hey) < a:xlen
            let hey = hey . ' '
        endwhile
        return hey
    endfunction

    function AutFoldText()
        let line = getline(v:foldstart)
        let tail = (v:foldend - v:foldstart + 1) . ' lines'
        return ExpandTo((winwidth(0) - strlen(tail)), line) . tail
    endfunction

    set fillchars=stlnc:-,vert:\|,fold:\ ,diff:-
    if has("win32")
        hi Folded ctermbg=blue ctermfg=yellow
    else
        hi Folded cterm=underline ctermfg=Gray
    endif
    autocmd FileType human syn region FoldMarker start="^[1234567890]" end="^[1234567890]"me=e-1 fold keepend
" }}}
" Autocommands: {{{
    function! CHANGE_CURR_DIR()
        let _dir = expand("%:p:h")
        if _dir !~ '^/tmp'
        exec 'cd ' . _dir 
        endif
        unlet _dir
    endfunction

    "autocmd BufEnter * call CHANGE_CURR_DIR()

    autocmd BufNewFile,BufRead * set path+=**
    autocmd BufReadPost * if line("'\"")|execute("normal `\"")|endif
    "autocmd BufNewFile,BufRead *.t          setf perl
    autocmd BufNewFile,BufRead *.dasc       setf c
    autocmd BufNewFile,BufRead *.y          setf c
    autocmd BufNewFile,BufRead *.yaml,*.yml setf yaml
    autocmd BufNewFile,BufRead *.ss         setf scheme
    autocmd BufNewFile,BufRead *.c          setf c
    autocmd BufNewFile,BufRead *.sxx        setf stp
    autocmd BufNewFile,BufRead *.stp        setf stp
    autocmd BufNewFile,BufRead *.mzp        setf mzperl
    autocmd BufNewFile,BufRead *.mas        setf mason
    autocmd BufNewFile,BufRead *.hta        setf mason
    autocmd BufNewFile,BufRead *.p6         setf perl6
    autocmd BufNewFile,BufRead *.tdy        setf perl
    autocmd BufNewFile,BufRead *.edge       setf edge
    autocmd BufNewFile,BufRead *.el         setf edge
    autocmd BufNewFile,BufRead *.ops        setf ops
    autocmd BufNewFile,BufRead *.pmc        setf pmc
    autocmd BufNewFile,BufRead *.yy         setf yacc
    autocmd BufNewFile,BufRead *.fan        setf perl6
    autocmd BufNewFile,BufRead *            call FTCheck()
    autocmd BufNewFile,BufRead *.hsc        setf haskell
    autocmd BufNewFile,BufRead *.hs-drift   setf haskell
    autocmd BufNewFile,BufRead *.tt         setf tt2
    autocmd BufNewFile,BufRead *.emt        setf c
    autocmd BufNewFile,BufRead *.pod        hi perlPOD ctermfg=Gray
    autocmd BufNewFile,BufRead *.0          24
    autocmd BufNewFile,BufRead w3m*         set fileencoding=utf-8
    au BufNewFile,BufRead *.pmc set ft=pmc cindent
    au BufNewFile,BufRead *.pasm set ft=pasm ai sw=4
    au BufNewFile,BufRead *.imc,*.imcc,*.pir set ft=pir ai sw=4
    au BufNewFile         *.imc,*.imcc,*.pir 0r ~/.vim/skeleton.pir
    let Tlist_Ctags_Cmd='/usr/local/bin/exctags'
    let Tlist_Inc_Winwidth=0
    highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
    match WhiteSpaceEOL /\s$/
    autocmd WinEnter * match WhiteSpaceEOL /\s$/
    "set sessionoptions=buffers,help,tabpages,winsize,winpos,sesdir
    set path+=**
    set et
    set smarttab
" vim: foldmethod=marker shiftwidth=4 expandtab
set guifont=Consolas\ 11
set pastetoggle=<F9>
set mouse=
imap <F2> <C-R>=strftime("%c")<CR>
set wrapscan

hi Search cterm=NONE ctermfg=black ctermbg=blue
"highlight Search guibg='Purple' guifg='NONE'

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" AnsiHighlight: Allows for marking up a file, using ANSI color escapes when
" the syntax changes colors, for easy, faithful reproduction.
" Author: Matthew Wozniski (mjw@drexel.edu)
" Date: Fri, 01 Aug 2008 05:22:55 -0400
" Version: 1.0 FIXME
" History: FIXME see :help marklines-history
" License: BSD. Completely open source, but I would like to be
" credited if you use some of this code elsewhere.

" Copyright (c) 2008, Matthew J. Wozniski {{{1
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
" * Redistributions of source code must retain the above copyright
" notice, this list of conditions and the following disclaimer.
" * Redistributions in binary form must reproduce the above copyright
" notice, this list of conditions and the following disclaimer in the
" documentation and/or other materials provided with the distribution.
" * The names of the contributors may not be used to endorse or promote
" products derived from this software without specific prior written
" permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" Turn off vi-compatible mode, unless it's already off {{{1
if &cp
  set nocp
endif

let s:type = 'cterm'
if &t_Co == 0
  let s:type = 'term'
endif

" Converts info for a highlight group to a string of ANSI color escapes {{{1
function! s:GroupToAnsi(groupnum)
  if ! exists("s:ansicache")
    let s:ansicache = {}
  endif

  let groupnum = a:groupnum

  if groupnum == 0
    let groupnum = hlID('Normal')
  endif

  if has_key(s:ansicache, groupnum)
    return s:ansicache[groupnum]
  endif

  let fg = synIDattr(groupnum, 'fg', s:type)
  let bg = synIDattr(groupnum, 'bg', s:type)
  let rv = synIDattr(groupnum, 'reverse', s:type)
  let bd = synIDattr(groupnum, 'bold', s:type)

  " FIXME other attributes?

  if rv == "" || rv == -1
    let rv = 0
  endif

  if bd == "" || bd == -1
    let bd = 0
  endif

  if rv
    let temp = bg
    let bg = fg
    let fg = temp
  endif

  if fg == "" || fg == -1
    unlet fg
  endif

  if !exists('fg') && !groupnum == hlID('Normal')
    let fg = synIDattr(hlID('Normal'), 'fg', s:type)
    if fg == "" || fg == -1
      unlet fg
    endif
  endif

  if bg == "" || bg == -1
    unlet bg
  endif

  if !exists('bg')
    let bg = synIDattr(hlID('Normal'), 'bg', s:type)
    if bg == "" || bg == -1
      unlet bg
    endif
  endif

  let retv = "\<Esc>[efg"

  if bd
    let retv .= ";1"
  endif

  if exists('fg') && fg < 8
    let retv .= ";3" . fg
  elseif exists('fg')  && fg < 16    "use aixterm codes
    let retv .= ";9" . (fg - 8)
  elseif exists('fg')                "use xterm256 codes
    let retv .= ";38;5;" . fg
  else
    let retv .= ";39"
  endif

  if exists('bg') && bg < 8
    let retv .= ";4" . bg
  elseif exists('bg') && bg < 16     "use aixterm codes
    let retv .= ";10" . (bg - 8)
  elseif exists('bg')                "use xterm256 codes
    let retv .= ";48;5;" . bg
  else
    let retv .= ";49"
  endif

  let retv .= "m"

  let s:ansicache[groupnum] = retv

  return retv
endfunction

function! AnsiHighlight(output_file)
  let retv = []

  for lnum in range(1, line('$'))
    let last = hlID('Normal')
    let output = s:GroupToAnsi(last) . "\<Esc>[K" " Clear to right

        " Hopefully fix highlighting sync issues
    exe "norm! " . lnum . "G$"

    let line = getline(lnum)

    for cnum in range(1, col('.'))
      if synIDtrans(synID(lnum, cnum, 1)) != last
        let last = synIDtrans(synID(lnum, cnum, 1))
        let output .= s:GroupToAnsi(last)
      endif

      let output .= matchstr(line, '\%(\zs.\)\{'.cnum.'}')
      "let line = substitute(line, '.', '', '')
            "let line = matchstr(line, '^\@<!.*')
    endfor
    let retv += [output]
  endfor
  " Reset the colors to default after displaying the file
  let retv[-1] .= "\<Esc>[0m"

  return writefile(retv, a:output_file)
endfunction

" See copyright in the vims cript above (for the vim script) and in
" vimcat.md for the whole script.
"
" The list of contributors is at the bottom of the vimpager script in this
" project.
"
"set clipboard=unnamed
cmap cs! ConqueTermSplit bash
cmap cv! ConqueTermVSplit bash
cmap ct! ConqueTerm bash
cmap spell! setlocal spell spelllang=en_us

set clipboard=unnamedplus

"au BufNewFile,BufRead *.edge setf edge
au BufRead,BufNewFile *.edge set filetype=edge
au BufRead,BufNewFile *.conf set filetype=nginx

"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
" Metadata: {{{
    set nocompatible
    set title
    let g:Header_name="Yichun Zhang"
    let g:Header_email="agentzh@gmail.com"
" }}}
" Encodings: {{{
    set termencoding=utf-8
    set encoding=utf-8
    set fileencodings=utf8,big5-hkscs,utf-8,iso8859-1
    set expandtab
    set grepprg=grep\ -nH\ $*
    " ,gbk,euc-jp,euc-kr,utf-bom,iso8859-1
" }}}
" Terminal: {{{
"noremap Bs Del
"noremap Del Bs
"noremap!Bs Del
"noremap!Del Bs
set bs=2
"noremap! <Del> <BS>
"noremap! <BS> <Del>

    " insert-mode cursors
    "map! OA ka
    "map! OB ja
    "map! OC lli
    "map! OD i

    " Alt now serves as window commands (^W)
    "noremap 
    "nmap <F8> :TagbarToggle<CR>

"set autoindent
"set cindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

let $BASH_ENV="~/.bash_aliases"

" Show trailing whitepace and spaces before a tab:
"autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEOL /\s$/
autocmd WinEnter * match WhiteSpaceEOL /\s$/

autocmd BufNewFile,BufRead *.fan        set filetype=perl6
set colorcolumn=81

highlight ColorColumn ctermbg=8

