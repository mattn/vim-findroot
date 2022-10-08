
command! -bang -bar FindRoot call findroot#cd(empty('<bang>') ? 1 : 0)

augroup FindRoot
  au!
  exe 'autocmd BufEnter ' . get(g:, 'findroot_mask', '*') . ' :call findroot#cd(0)'
augroup END
