# vim-findroot

Auto change directory to root directory of the file.

## Configuration

If you want to limit to fire event for the files:

```vim
let g:findroot_mask = '*.c'
```

If you modify default root-marker patterns:

```vim
let g:findroot_patterns = [
\  '.git/',
\  '.svn/',
\  '.hg/',
\  '.bzr/',
\  '.gitignore',
\  'Rakefile',
\  'pom.xml',
\  'project.clj',
\  '*.csproj',
\  '*.sln',
\]
```

## License

MIT

## Author

Yasuhiro Matsumoto (a.k.a. mattn)
