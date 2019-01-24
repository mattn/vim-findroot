function! s:findroot(echo) abort
  let l:bufname = expand('%:p')
  if &buftype != '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
    return
  endif
  let l:dir = escape(fnamemodify(l:bufname, ':p:h:gs!\!/!'), ' ')
  let l:patterns = get(g:, 'findroot_patterns', ['.git/', '.gitignore', '.svn/', '.hg/', '.bzr/', 'pom.xml'])
  for l:pattern in l:patterns 
    if l:pattern =~# '/$'
      let l:match = fnamemodify(finddir(l:pattern, l:dir . ';'), ':p')
      let l:match = substitute(l:match, '[\/]$', '', '')
    else
      let l:match = fnamemodify(findfile(l:pattern, l:dir . ';'), ':p')
    endif
    if !empty(l:match)
      let l:dir = fnamemodify(l:match, ':h')
      break
    endif
  endfor
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
