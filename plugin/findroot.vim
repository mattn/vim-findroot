function! s:findroot()
  let l:bufname = bufname('.') |
  if &buftype != '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
    return
  endif
  let l:dir = escape(fnamemodify(l:bufname, ':p:h'), ' ')

  exe 'lcd' l:dir
  let l:patterns = get(g:, 'findroot_patterns', ['.git/', '.gitignore', '.svn/', '.hg/', '.bzr/', 'pom.xml'])
  for l:pattern in l:patterns 
    if l:pattern[-1] == '/'
      let l:match = finddir(l:pattern, l:dir . ';')
    else
      let l:match = findfile(l:pattern, l:dir . ';')
    endif
    if !empty(l:match)
      exe 'lcd' fnamemodify(l:match, ':h')
      return
    endif
  endfor
endfunction

augroup FindRoot
  au!
  exe 'autocmd BufEnter ' . get(g:, 'findroot_mask', '*') . ' :call s:findroot()'
augroup END
