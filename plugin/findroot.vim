
command! -bang -bar FindRoot call findroot#find(empty('<bang>') ? 1 : 0)

augroup FindRoot
  au!
  exe 'autocmd BufEnter ' . get(g:, 'findroot_mask', '*') . ' :call findroot#find(0)'
augroup END
