# vim-tag-peek

A neovim plugin for peeking at tag definitions using the `nvim_open_win` "floating window" feature.

## Usage

Assuming you have installed this plugin and have ctags properly setup, map a command to peek at the tag under the cursor

```
nnoremap <leader>q :call tag_peek#ShowTag()<CR>
```

You can also invoke the function directly to view a specific tag definition. e.g. to view the tag `delete` you could do `:call tag_peek#ShowTag("delete")`

## Preview Mappings

Unless you opt-out of mappings (via `let g:tag_peek_mappings=0`), the following normal-mode key mappings will be setup for the preview window:

| key     | behavior                                     |
|---------|----------------------------------------------|
| `q`     | Close the preview window                     |
| `<c-n>` | Jump to the next definition of the tag       |
| `<c-p>` | Jump to the previous definition of the tag   |
| `<c-e>` | Edit the currently previewed file in a split |

### Configuration

This plugin aims to have reasonable defaults but a few configuration variables are provided for power-users.

| variable                   | usage                                                                                                                                                                               |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `g:tag_peek_mappings`      | set to `0` to opt-out of the default preview mappings                                                                                                                               |
| `g:tag_peek_split_command` | control how a split is opened from the preview window (this is `vsplit` by default but you might prefer `split` or `tabnew`)                                                        |
| `g:tag_peek_float_config`  | set this to a custom function name to control the `config` passed to control the display of the preview window. See below for an example and `:help nvim_open_win` for more info. |

Example `g:tag_peek_float_config` usage:

```vim
function! MyFloatConfig()
  return {
        \ 'relative': 'editor',
        \ 'row': 10,
        \ 'col': 10,
        \ 'width': 80,
        \ 'height': 20
        \ }
endfunction

let g:tag_peek_float_config="MyFloatConfig"
```

## TODO

- screenshot(s)
- blog post
