function! s:goup(path, patterns) abort
  let l:path = a:path
  while 1
    for l:pattern in a:patterns
      if l:pattern =~# '/$'
        if isdirectory(l:path . l:pattern)
          return l:path
        endif
      elseif filereadable(l:path . '/' . l:pattern)
        return l:path
      endif
    endfor
    let l:next = fnamemodify(l:path, ':h')
    if l:next == l:path
      break
    endif
    let l:path = l:next
  endwhile
  return ''
endfunction

function! s:findroot(echo) abort
  let l:bufname = expand('%:p')
  if &buftype != '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
    return
  endif
  let l:dir = escape(fnamemodify(l:bufname, ':p:h:gs!\!/!'), ' ')
  let l:patterns = get(g:, 'findroot_patterns', ['.git/', '.gitignore', '.svn/', '.hg/', '.bzr/', 'pom.xml'])
  let l:dir = s:goup(l:dir, l:patterns)
  if empty(l:dir)
    return
  endif
  exe 'lcd' l:dir
  if a:echo
    echo l:dir
  endif
endfunction

command! FindRoot call s:findroot(1)

augroup FindRoot
  au!
  exe 'autocmd BufEnter ' . get(g:, 'findroot_mask', '*') . ' :call s:findroot(0)'
augroup END
