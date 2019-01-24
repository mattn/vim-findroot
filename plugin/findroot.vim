function! s:findroot(echo)
  let l:bufname = expand('%:p') |
  if &buftype != '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
    return
  endif
  let l:dir = fnamemodify(l:bufname, ':p:h')

  exe 'lcd' l:dir
  let l:dir = escape(fnamemodify(getcwd(), ':p:h:gs!\!/!'), ' ')
  let l:patterns = get(g:, 'findroot_patterns', ['.git/', '.gitignore', '.svn/', '.hg/', '.bzr/', 'pom.xml'])
  for l:pattern in l:patterns 
    if l:pattern =~# '/$'
      let l:match = finddir(l:pattern, l:dir . ';')
    else
      let l:match = findfile(l:pattern, l:dir . ';')
    endif
    if !empty(l:match)
      let l:match = fnamemodify(l:match, ':p')
      if l:match =~# '[\/]$'
        let l:match = l:match[:-2]
      endif
      let l:dir = fnamemodify(l:match, ':h')
      exe 'lcd' l:dir
      if a:echo
        echo l:dir
      endif
      return
    endif
  endfor
endfunction

command! FindRoot call s:findroot(1)

augroup FindRoot
  au!
  exe 'autocmd BufEnter ' . get(g:, 'findroot_mask', '*') . ' :call s:findroot(0)'
augroup END
