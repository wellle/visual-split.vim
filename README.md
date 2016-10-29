# visual-split.vim

Vim plugin to control splits with visual selections or text objects

## Motivation

Ever found yourself scrolling back up to the same overview comment while reading
some complicated function? Or while referring to a similar implementation while
writing a new function?

This is a good use for Vim splits: You have one split for reference and another
one where you jump around and get work done.

But setting up the splits in the first place can be tiresome, especially if you
want to make the reference split as small as possible to not waste any precious
space.

## Features

This plugin adds some convenient commands and mappings to resize an existing
split or create a new split showing exactly what you need to see.

### Commands

#### Resize

If you already have multiple splits open and want to resize one of them to only
show a certain range of lines, follow these steps:

1. Visually select the lines you want to see
2. Type `:VSResize` to execute the `VSResize` ex command on the selected range
3. The split will now only show those lines

![][resize]

[resize]: https://raw.githubusercontent.com/wellle/images/master/visual-split-resize.png

#### Split

If you want to create a new split to show a certain range you could create a
split and then resize it as described above. But there is a quicker way:

1. Visually select the lines you want to split out
2. Type `:VSSplit`, `:VSSplitAbove` or `:VSSplitBelow` to create the split
3. A new split will be created showing the selected lines

Notes on the different commands:

- `:VSSplit` will respect your `'splitbelow'` setting
- `:VSSplitAbove` will always create a new split above the current window
- `:VSSplitBelow` will always create a new split below the current window

![][split]

As with all commands that work on ranges, invoking them on a visual selection
is only one way of many:

- Resize split to show everything between marks `a` and `b` with
  `:'a,'bVSResize`
- Split out range between line above cursor containing `foo` and line below
  cursor containing `bar` with `:?foo?,/bar/VSSplit`

[split]:  https://raw.githubusercontent.com/wellle/images/master/visual-split-split.png

### Mappings

Mappings will not overwrite your existing mappings.

For the most common use case of working on visual selections there are some
visual mode mappings provided:

- <kbd>\<C-W>gr</kbd> - resize split to visual selection
  (similar to `:VSResize`)
- <kbd>\<C-W>gss</kbd> - split out visual selection
  (similar to `:VSSplit`)
- <kbd>\<C-W>gsa</kbd> - split out visual selection above
  (similar to `:VSSplitAbove`)
- <kbd>\<C-W>gsb</kbd> - split out visual selection below
  (similar to `:VSSplitBelow`)

Note: `<C-W>` means press and hold the `Control` key while pressing `W`
(similar to other window related commands)

For example, to split out to the paragraph around the cursor, just type:

```
vip<C-W>gss
```

To work on text objects directly, the same mappings are provided in operator
pending mode. So this also works:

```
<C-W>gssip
```

### Remapping
For easier remapping, `<Plug>` mappings are provided. Change the key sequences
below and put them into your vimrc:

Visual-mode:
```vim
xmap <C-W>gr  <Plug>(Visual-Split-VSResize)
xmap <C-W>gss <Plug>(Visual-Split-VSSplit)
xmap <C-W>gsa <Plug>(Visual-Split-VSSplitAbove)
xmap <C-W>gsb <Plug>(Visual-Split-VSSplitBelow)
```

Operator-pending mode:
```vim
nmap <C-W>gr  <Plug>(Visual-Split-Resize)
nmap <C-W>gss <Plug>(Visual-Split-Split)
nmap <C-W>gsa <Plug>(Visual-Split-SplitAbove)
nmap <C-W>gsb <Plug>(Visual-Split-SplitBelow)
```

## Installation
Use your favorite plugin manager.

- [NeoBundle][neobundle]

    ```vim
    NeoBundle 'wellle/visual-split.vim'
    ```

- [Vundle][vundle]

    ```vim
    Bundle 'wellle/visual-split.vim'
    ```

- [Vim-plug][vim-plug]

    ```vim
    Plug 'wellle/visual-split.vim'
    ```

- [Pathogen][pathogen]

    ```sh
    git clone git://github.com/wellle/visual-split.vim.git ~/.vim/bundle/visual-split.vim
    ```

[neobundle]: https://github.com/Shougo/neobundle.vim
[vundle]: https://github.com/gmarik/vundle
[vim-plug]: https://github.com/junegunn/vim-plug
[pathogen]: https://github.com/tpope/vim-pathogen

## What's next?

This plugin was written in an afternoon to fill a personal need. I might add
related functionality in the future that I consider useful and related
additions. If you like this plugin and want more of it, please open an issue
and let me know what you would like to see.

Especially suggestions for better command names or more concise mappings would
be very appreciated.
