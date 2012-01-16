" Filename:      movelines.vim
" Description:   Use arrow keys to move/indent lines
" Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
" Last Modified: Mon 2012-01-16 00:06:08 (-0500)

" All credit goes to: https://github.com/Lokaltog
" I'm just making it into a plugin

if exists('g:movelines_loaded') || &cp
    finish
endif

let g:movelines_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:MoveLineUp()
    call <SID>MoveLineOrVisualUp(".", "")
endfunction

function! s:MoveLineDown()
    call <SID>MoveLineOrVisualDown(".", "")
endfunction

function! s:MoveVisualUp()
    call <SID>MoveLineOrVisualUp("'<", "'<,'>")
    normal gv
endfunction

function! s:MoveVisualDown()
    call <SID>MoveLineOrVisualDown("'>", "'<,'>")
    normal gv
endfunction

function! s:MoveLineOrVisualUp(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num - v:count1 - 1 < 0
        let move_arg = "0"
    else
        let move_arg = a:line_getter." -".(v:count1 + 1)
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! s:MoveLineOrVisualDown(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num + v:count1 > line("$")
        let move_arg = "$"
    else
        let move_arg = a:line_getter." +".v:count1
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! s:MoveLineOrVisualUpOrDown(move_arg)
    let col_num = virtcol(".")
    execute "silent! ".a:move_arg
    execute "normal! ".col_num."|"
endfunction

" Normal mode
nnoremap <silent> <Left>   <<
nnoremap <silent> <Right>  >>
nnoremap <silent> <Up>     <Esc>:call <SID>MoveLineUp()<CR>
nnoremap <silent> <Down>   <Esc>:call <SID>MoveLineDown()<CR>

" Visual mode
vnoremap <silent> <Left>   <gv
vnoremap <silent> <Right>  >gv
vnoremap <silent> <Up>     <Esc>:call <SID>MoveVisualUp()<CR>
vnoremap <silent> <Down>   <Esc>:call <SID>MoveVisualDown()<CR>

" Insert mode
inoremap <silent> <Left>   <C-D>
inoremap <silent> <Right>  <C-T>
inoremap <silent> <Up>     <C-O>:call <SID>MoveLineUp()<CR>
inoremap <silent> <Down>   <C-O>:call <SID>MoveLineDown()<CR>

let &cpo = s:save_cpo
