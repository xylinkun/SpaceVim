"=============================================================================
" file.vim --- SpaceVim file API
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8
if exists('s:self')
  finish
endif

""
" @section file, api-file
" @parentsection api
" The `file` api provides basic functions to manage file. The following
" functions can be used:
"
" - `fticon(path)`: get the filetype icon of path
" - `write(msg, fname)`: append msg to fname.
" - `override(msg, fname)`: override fname with msg.
" - `read(fname)`: read the context of fname.
" - `ls(dir, if_file_only)`: list files and directories in dir
" - `updatefiles(files)`: update all files
" - `unify_path(path, ...)`: unify the format of path
" - `path_to_fname(path)`: get unify string of a path.
" - `findfile(pattern, dir)`: find path match pattern in dir.
" - `finddir(pattern, dir)`: find directory match pattern in dir
"
" Example:
" >
"   let s:FILE = SpaceVim#api#import('file')
" <


let s:self = {}
let s:self.__system = SpaceVim#api#import('system')
let s:self.__cmp = SpaceVim#api#import('vim#compatible')

if s:self.__system.isWindows
  let s:self.separator = '\'
  let s:self.pathSeparator = ';'
else
  let s:self.separator = '/'
  let s:self.pathSeparator = ':'
endif

let s:gui_colors = {
      \ 'brown' : '#905532',
      \ 'aqua' : '#3AFFDB',
      \ 'blue' : '#689FB6',
      \ 'darkBlue' : '#44788E',
      \ 'purple' : '#834F79',
      \ 'lightPurple' : '#834F79',
      \ 'red' : '#AE403F',
      \ 'beige' : '#F5C06F',
      \ 'yellow' : '#F09F17',
      \ 'orange' : '#D4843E',
      \ 'darkOrange' : '#F16529',
      \ 'pink' : '#CB6F6F',
      \ 'salmon' : '#EE6E73',
      \ 'green' : '#8FAA54',
      \ 'lightGreen' : '#31B53E',
      \ 'default': '#abb2bf',
      \ }

let s:term_colors = {
      \ 'brown'       : 130,
      \ 'aqua'        : 66,
      \ 'blue'        : 67,
      \ 'darkBlue'    : 57,
      \ 'purple'      : 60,
      \ 'lightPurple' : 103,
      \ 'red'         : 131,
      \ 'beige'       : 137,
      \ 'yellow'      : 229,
      \ 'orange'      : 208,
      \ 'darkOrange'  : 166,
      \ 'pink'        : 205,
      \ 'salmon'      : 209,
      \ 'green'       : 65,
      \ 'lightGreen'  : 108,
      \ 'default'       : 231,
      \ }
let s:icons_color = {
      \ 'jpg' : {'icon': '', 'color': s:gui_colors.aqua, 'term_color': s:term_colors.aqua},
      \ 'json' : {'icon': '', 'color': s:gui_colors.beige, 'term_color': s:term_colors.beige},
      \ 'mjs' : {'icon': '', 'color': s:gui_colors.beige, 'term_color': s:term_colors.beige},
      \ 'hs' : {'icon': '', 'color': s:gui_colors.beige, 'term_color': s:term_colors.beige},
      \ 'go' : {'icon': '', 'color': s:gui_colors.beige, 'term_color': s:term_colors.beige},
      \ 'css' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'jsx' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'c' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'db' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'pl' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'fsscript' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'ts' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'tsx' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'cs' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'hh' : {'icon': '', 'color': s:gui_colors.blue, 'term_color': s:term_colors.blue},
      \ 'coffee' : {'icon': '', 'color': s:gui_colors.brown, 'term_color': s:term_colors.brown},
      \ 'less' : {'icon': '', 'color': s:gui_colors.darkBlue, 'term_color': s:term_colors.darkBlue},
      \ 'sql' : {'icon': '', 'color': s:gui_colors.darkBlue, 'term_color': s:term_colors.darkBlue},
      \ 'psd' : {'icon': '', 'color': s:gui_colors.darkBlue, 'term_color': s:term_colors.darkBlue},
      \ 'fsharp' : {'icon': '', 'color': s:gui_colors.darkBlue, 'term_color': s:term_colors.darkBlue},
      \ 'html' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'xul' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'rss' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'rs' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'rlib' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'ai' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'svelte' : {'icon': '', 'color': s:gui_colors.darkOrange, 'term_color': s:term_colors.darkOrange},
      \ 'sass' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'rmd' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'conf' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'h' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'bash' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'diff' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'dart' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'pp' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'key' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'elm' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'gemspec' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'haml' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'leex' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'rake' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'tex' : {'icon': 'ﭨ', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'webmanifest' : {'icon': '', 'color': s:gui_colors.default, 'term_color': s:term_colors.default},
      \ 'styl' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'twig' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'fish' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'clj' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'cljc' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'cljs' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'edn' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'vim' : {'icon': '', 'color': s:gui_colors.green, 'term_color': s:term_colors.green},
      \ 'sh' : {'icon': '', 'color': s:gui_colors.lightPurple, 'term_color': s:term_colors.lightPurple},
      \ 'erl' : {'icon': '', 'color': s:gui_colors.lightPurple, 'term_color': s:term_colors.lightPurple},
      \ 'ex' : {'icon': '', 'color': s:gui_colors.lightPurple, 'term_color': s:term_colors.lightPurple},
      \ 'slim' : {'icon': '', 'color': s:gui_colors.orange, 'term_color': s:term_colors.orange},
      \ 'mustache' : {'icon': '', 'color': s:gui_colors.orange, 'term_color': s:term_colors.orange},
      \ 'swift' : {'icon': '', 'color': s:gui_colors.orange, 'term_color': s:term_colors.orange},
      \ 'scss' : {'icon': '', 'color': s:gui_colors.pink, 'term_color': s:term_colors.pink},
      \ 'hrl' : {'icon': '', 'color': s:gui_colors.pink, 'term_color': s:term_colors.pink},
      \ 'php' : {'icon': '', 'color': s:gui_colors.purple, 'term_color': s:term_colors.purple},
      \ 'lua' : {'icon': '', 'color': s:gui_colors.purple, 'term_color': s:term_colors.purple},
      \ 'java' : {'icon': '', 'color': s:gui_colors.purple, 'term_color': s:term_colors.purple},
      \ 'sln' : {'icon': '', 'color': s:gui_colors.purple, 'term_color': s:term_colors.purple},
      \ 'jl' : {'icon': '', 'color': s:gui_colors.purple, 'term_color': s:term_colors.purple},
      \ 'rb' : {'icon': '', 'color': s:gui_colors.red, 'term_color': s:term_colors.red},
      \ 'scala' : {'icon': '', 'color': s:gui_colors.red, 'term_color': s:term_colors.red},
      \ 'd' : {'icon': '', 'color': s:gui_colors.red, 'term_color': s:term_colors.red},
      \ 'ejs' : {'icon': '', 'color': s:gui_colors.yellow, 'term_color': s:term_colors.yellow},
      \ 'md' : {'icon': '', 'color': s:gui_colors.yellow, 'term_color': s:term_colors.yellow},
      \ 'py' : {'icon': '', 'color': s:gui_colors.yellow, 'term_color': s:term_colors.yellow},
      \ 'ml' : {'icon': 'λ', 'color': s:gui_colors.yellow, 'term_color': s:term_colors.yellow},
      \}

let s:file_node_extensions = {
      \  'styl'     : '',
      \  'scss'     : '',
      \  'htm'      : '',
      \  'html'     : '',
      \  'erb'      : '',
      \  'slim'     : '',
      \  'ejs'      : '',
      \  'wxml'     : '',
      \  'css'      : '',
      \  'less'     : '',
      \  'wxss'     : '',
      \  'md'       : '',
      \  'doc'      : '',
      \  'help'     : '',
      \  'txt'      : '',
      \  'toml'     : '',
      \  'markdown' : '',
      \  'json'     : '',
      \  'js'       : '',
      \  'jsx'      : '',
      \  'rb'       : '',
      \  'php'      : '',
      \  'py'       : '',
      \  'pyc'      : '',
      \  'pyo'      : '',
      \  'pyd'      : '',
      \  'coffee'   : '',
      \  'mustache' : '',
      \  'hbs'      : '',
      \  'conf'     : '',
      \  'ini'      : '',
      \  'yml'      : '',
      \  'bat'      : '',
      \  'jpg'      : '',
      \  'jpeg'     : '',
      \  'bmp'      : '',
      \  'png'      : '',
      \  'gif'      : '',
      \  'ico'      : '',
      \  'twig'     : '',
      \  'cpp'      : '',
      \  'c++'      : '',
      \  'cxx'      : '',
      \  'cc'       : '',
      \  'cp'       : '',
      \  'c'        : '',
      \  'hs'       : '',
      \  'lhs'      : '',
      \  'lua'      : '',
      \  'java'     : '',
      \  'sh'       : '',
      \  'fish'     : '',
      \  'ml'       : 'λ',
      \  'mli'      : 'λ',
      \  'diff'     : '',
      \  'db'       : '',
      \  'sql'      : '',
      \  'dump'     : '',
      \  'clj'      : '',
      \  'cljc'     : '',
      \  'cljs'     : '',
      \  'edn'      : '',
      \  'scala'    : '',
      \  'go'       : '',
      \  'dart'     : '',
      \  'xul'      : '',
      \  'sln'      : '',
      \  'suo'      : '',
      \  'pl'       : '',
      \  'pm'       : '',
      \  't'        : '',
      \  'rss'      : '',
      \  'f#'       : '',
      \  'fsscript' : '',
      \  'fsx'      : '',
      \  'fs'       : '',
      \  'fsi'      : '',
      \  'rs'       : '',
      \  'rlib'     : '',
      \  'd'        : '',
      \  'erl'      : '',
      \  'hrl'      : '',
      \  'vim'      : '',
      \  'ai'       : '',
      \  'psd'      : '',
      \  'psb'      : '',
      \  'ts'       : '',
      \  'tsx'      : '',
      \  'jl'       : '',
      \  'ex'       : '',
      \  'exs'      : '',
      \  'eex'      : '',
      \  'leex'     : '',
      \}

let s:file_node_exact_matches = {
      \  'exact-match-case-sensitive-1.txt' : 'X1',
      \  'exact-match-case-sensitive-2'     : 'X2',
      \  'gruntfile.coffee'                 : '',
      \  'gruntfile.js'                     : '',
      \  'gruntfile.ls'                     : '',
      \  'gulpfile.coffee'                  : '',
      \  'gulpfile.js'                      : '',
      \  'gulpfile.ls'                      : '',
      \  'dropbox'                          : '',
      \  '.ds_store'                        : '',
      \  '.gitconfig'                       : '',
      \  '.gitignore'                       : '',
      \  'config'                           : '',
      \  'muttrc'                           : '',
      \  'Makefile'                         : '',
      \  '.bashrc'                          : '',
      \  '.bashprofile'                     : '',
      \  'favicon.ico'                      : '',
      \  'license'                          : '',
      \  'node_modules'                     : '',
      \  'react.jsx'                        : '',
      \  'Procfile'                         : '',
      \  '.vimrc'                           : '',
      \  'vimrc'                            : '',
      \  'mix.lock'                         : '',
      \}

let s:file_node_pattern_matches = {
      \ '.*jquery.*\.js$'       : '',
      \ '.*angular.*\.js$'      : '',
      \ '.*backbone.*\.js$'     : '',
      \ '.*require.*\.js$'      : '',
      \ '.*materialize.*\.js$'  : '',
      \ '.*materialize.*\.css$' : '',
      \ '.*mootools.*\.js$'     : ''
      \}


function! s:self.fticon(path) abort
  let file = fnamemodify(a:path, ':t')
  if has_key(s:file_node_exact_matches, file)
    return s:file_node_exact_matches[file]
  endif
  for [k, v]  in items(s:file_node_pattern_matches)
    if match(file, k) != -1
      return v
    endif
  endfor
  let ext = fnamemodify(file, ':e')
  if has_key(get(g:, 'spacevim_filetype_icons', {}), ext)
    return g:spacevim_filetype_icons[ext]
  elseif has_key(s:file_node_extensions, ext)
    return s:file_node_extensions[ext]
  endif
  return ''
endfunction

function! s:self.hi_icons() abort
  for [name, icon] in items(s:icons_color)
    call execute(printf('hi! SpaceVim_API_FILE_%s guifg=%s ctermfg=%s', name, icon.color, icon.term_color))
    call execute(printf('call matchadd("SpaceVim_API_FILE_%s", "%s", 2)', name, icon.icon))
  endfor
endfunction

function! s:self.clear_icons() abort

  call clearmatches()
  
endfunction

function! s:self.write(msg, fname) abort
  let flags = filewritable(a:fname) ? 'a' : ''
  call writefile([a:msg], a:fname, flags)
endfunction

function! s:self.override(msg, fname) abort
  let flags = filewritable(a:fname) ? 'b' : ''
  call writefile([a:msg], a:fname, flags)
endfunction

function! s:self.read(fname) abort       
  if filereadable(a:fname)
    return readfile(a:fname, '')
  else
    return ''
  endif
endfunction

function! s:self.ls(dir, if_file_only) abort
  let items = s:vim_comp.globpath(a:dir, '*')
  if a:if_file_only
    let items = filter(items, '!isdirectory(v:val)')
  endif
  return map(items, "fnamemodify(v:val, ':t')")
endfunction

"
" {
" 'filename' : {
"                 line1 : content,
"                 line2 : content,
"              } 
" }
function! s:self.updatefiles(files) abort
  let failed = []
  for fname in keys(a:files)
    let buffer = readfile(fname)
    for line in keys(a:files[fname])
      let buffer[line - 1] = a:files[fname][line]
    endfor
    try
      call writefile(buffer, fname, 'b')
    catch 
      call add(failed, fname)
    endtry
  endfor
  return failed
endfunction


" this function should return a unify path
" CHANGED: This function will not run resolve
" 1. the sep is /
" 2. if it is a dir, end with /
" 3. if a:path end with /, then return path also end with /
function! s:self.unify_path(path, ...) abort
  if empty(a:path)
    return ''
  endif
  let mod = a:0 > 0 ? a:1 : ':p'
  let path = fnamemodify(a:path, mod . ':gs?[\\/]?/?')
  if isdirectory(path) && path[-1:] !=# '/'
    return path . '/'
  elseif a:path[-1:] ==# '/' && path[-1:] !=# '/'
    return path . '/'
  else
    return path
  endif
endfunction

function! s:self.path_to_fname(path, ...) abort
  let sep = get(a:000, 0, '_')
  return substitute(self.unify_path(a:path), '[\\/:;.]', sep, 'g')
endfunction


" Both findfile() and finddir() do not has same logic between latest
" version of vim and vim7.4.629. I do not know which pathch cause this
" issue. But I have change the logic of these functions.
" Now it should works same as in vim8 and old vim.

function! s:self.findfile(what, where, ...) abort
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let l:count = get(a:000, 0, 0)

  if filereadable(a:where) && !isdirectory(a:where)
    let path = fnamemodify(a:where, ':h')
  else
    let path = a:where
  endif
  if l:count > 0
    let file = findfile(a:what, escape(path, ' ') . ';', l:count)
  elseif a:0 ==# 0
    let file = findfile(a:what, escape(path, ' ') . ';')
  elseif l:count ==# 0
    let file = findfile(a:what, escape(path, ' ') . ';', -1)
  else
    let file = get(findfile(a:what, escape(path, ' ') . ';', -1), l:count, '')
  endif
  let &suffixesadd = old_suffixesadd
  return file
endfunction

function! s:self.finddir(what, where, ...) abort
  let old_suffixesadd = &suffixesadd
  let &suffixesadd = ''
  let l:count = get(a:000, 0, 0)
  if filereadable(a:where) && !isdirectory(a:where)
    let path = fnamemodify(a:where, ':h')
  else
    let path = a:where
  endif
  if l:count > 0
    let file = finddir(a:what, escape(path, ' ') . ';', l:count)
  elseif a:0 ==# 0
    let file = finddir(a:what, escape(path, ' ') . ';')
  elseif l:count ==# 0
    let file = finddir(a:what, escape(path, ' ') . ';', -1)
  else
    let file = get(finddir(a:what, escape(path, ' ') . ';', -1), l:count, '')
  endif
  let &suffixesadd = old_suffixesadd
  return file
endfunction
function! SpaceVim#api#file#get() abort
  return deepcopy(s:self)
endfunction

" vim:set et sw=2:
