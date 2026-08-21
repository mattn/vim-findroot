function! s:escape_glob_path(path) abort
  let l:path = escape(a:path, ',*?')
  if stridx(&isfname, '[') < 0
    return l:path
  endif
  if has('win32')
    return substitute(l:path, '\[', '[[]', 'g')
  endif
  return escape(l:path, '[')
endfunction

function! s:goup(path, patterns) abort
  let l:path = a:path
  while 1
    for l:pattern in a:patterns
      let l:current = l:path . '/' . l:pattern
      if stridx(l:pattern, '*') !=# -1
            \ && !empty(glob(s:escape_glob_path(l:path) . '/' . l:pattern, 1))
        return l:path
      elseif l:pattern =~# '/$'
        if isdirectory(l:current)
          return l:path
        endif
      elseif filereadable(l:current)
        return l:path
      endif
    endfor
    let l:next = fnamemodify(l:path, ':h')
    if l:next ==# l:path || (has('win32') && l:next =~# '^//[^/]\+$')
      break
    endif
    let l:path = l:next
  endwhile
  return ''
endfunction

function! findroot#find(...) abort
  if a:0 !=# 0
    let l:bufname = fnamemodify(expand(a:1), ':p')
  else
    let l:bufname = expand('%:p')
  endif
  if &buftype !=# '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
    return ''
  endif
  let l:dir = fnamemodify(l:bufname, ':p:h:gs!\!/!:gs!//!/!')

  let l:patterns = get(g:, 'findroot_patterns', [
  \  '.git/',
  \  '.svn/',
  \  '.hg/',
  \  '.bzr/',
  \  '.gitignore',
  \  'Rakefile',
  \  'pom.xml',
  \  'project.clj',
  \  'package.json',
  \  'manifest.json',
  \  '*.csproj',
  \  '*.sln',
  \])
  let l:patterns = a:0 ==# 2 && type(a:2) ==# v:t_list ? a:2 + l:patterns : l:patterns
  return s:goup(l:dir, l:patterns)
endfunction

function! findroot#cd(echo) abort
  let l:dir = findroot#find()
  if empty(l:dir)
    return
  endif
  if get(g:, 'findroot_not_for_subdir', 1) && stridx(tolower(fnamemodify(getcwd(), ':gs!\!/!')), tolower(l:dir)) == 0
    return
  endif
  exe 'lcd' l:dir
  if a:echo
    echo l:dir
  endif
endfunction
