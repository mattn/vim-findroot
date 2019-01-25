# vim-findroot

Auto change directory to project root directory of the file.

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

It must be set of below's patterns.

### Directory

Example: `.git/`. It must have `/` suffixes.

### File

Example: `Rakefile`. It must NOT have `/` suffixes.

### Wildcard

Example: `*.c`. This does not handle `/` suffixes as directory or not.

If you allow changing directory that goes up from sub-directory:

```vim
let g:findroot_not_for_subdir = 0
```

## License

MIT

## Author

Yasuhiro Matsumoto (a.k.a. mattn)
