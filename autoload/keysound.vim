"======================================================================
"
" keysound.vim - 
"
" Created by skywind on 2018/05/01
" Updated by lflys on 2020/11/17
"
" This script is updated with new sound feature bought by vim 8.2
"
"======================================================================


"----------------------------------------------------------------------
" global settings
"----------------------------------------------------------------------
if !exists('g:keysound_py_version')
	let g:keysound_py_version = 0
endif

if !exists('g:keysound_theme')
	let g:keysound_theme = 'default'
endif

if !exists('g:keysound_replace')
	let g:keysound_replace = 1
endif

if !exists('g:keysound_volume')
	let g:keysound_volume = 450
endif


"----------------------------------------------------------------------
" tools
"----------------------------------------------------------------------
function! keysound#errmsg(msg)
	redraw | echo '' | redraw
	echohl ErrorMsg
	echom a:msg
	echohl NONE
endfunc

let s:themes = {}


"----------------------------------------------------------------------
" choose_theme 
"----------------------------------------------------------------------
function! s:choose_theme(theme)
	for rtp in split(&rtp, ',')
        let s:path = fnamemodify(rtp, ':p') .. '/sounds/' .. a:theme .. '/'
		if isdirectory(s:path)
			return s:path
		endif
	endfor
endfunc


"----------------------------------------------------------------------
" play a sound in given theme
"----------------------------------------------------------------------
function! s:play(filename, ...)
	let theme = g:keysound_theme
	if has_key(s:themes, theme)
		let path = s:themes[theme]
	else
		let path = s:choose_theme(theme)
		let s:themes[theme] = path
	endif
	if path == ''
		call keysound#errmsg('ERROR: can not find theme "sounds/'.. theme.. '" folder in runtimepaths')
		return 
	endif
	let fn = path .. '/' .. a:filename
	if !filereadable(fn)
		call keysound#errmsg('ERROR: not find "'.. a:filename..'" in "'..path..'"')
		return
	endif
	call sound_playfile(fn)
endfunc


"----------------------------------------------------------------------
" choose volume 
"----------------------------------------------------------------------
function! s:random(range)
	let s:range = a:range
    return rand(srand()) % s:range
endfunc

function! keysound#init() abort
    if has('sound')
        return 1
    else
        errmsg('This vim is not compiled with the +sound feature')
        return 0
endfunc

function! keysound#play(key)
	if a:key == "\n"
		if g:keysound_replace == 0
			call s:play('keyenter.wav')
		else
			call s:play('keyenter.wav')
		endif
	else
		if g:keysound_replace == 0
			call s:play('keyany.wav')
		else
			call s:play('keyany.wav')
		endif
	endif
endfunc


