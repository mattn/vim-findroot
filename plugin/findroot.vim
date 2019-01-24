function! s:findroot()
  let l:bufname = expand('%:p') |
  if &buftype != '' || empty(l:bufname) || stridx(l:bufname, '://') !=# -1
    return
  endif
  let l:dir = fnamemodify(l:bufname, ':p:h')

  exe 'cd' l:dir
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
      exe 'lcd' fnamemodify(l:match, ':h')
      return
    endif
  endfor
endfunction

command! FindRoot call s:findroot()

augroup FindRoot
  au!
  exe 'autocmd BufEnter ' . get(g:, 'findroot_mask', '*') . ' :call s:findroot()'
augroup END
