if !exists('g:tag_peek_mappings')
    let g:tag_peek_mappings=1
endif

if !exists('g:tag_peek_split_command')
    let g:tag_peek_split_command='vs'
endif

function! s:Warn(msg)
    echohl WarningMsg | echo a:msg | echohl None
endfunction

" this borrows from http://liuchengxu.org/posts/vista.vim/ and
" https://github.com/junegunn/fzf.vim/issues/664
function! s:DefaultFloatConfig()
    let height = &lines - 3
    let width = float2nr(&columns - (&columns / 5))
    let col = float2nr((&columns - width) / 2)
    return {
                \ 'relative': 'editor',
                \ 'row': height * 0.333,
                \ 'col': width * 0.333,
                \ 'width': width * 2 / 3,
                \ 'height': height / 2
                \ }
endfunction

function! s:FloatPeek()
    let current_buffer = bufnr('%')
    let current_line = line('.')

    " swap to preview
    wincmd P
    let save_pos = getpos('.')
    " get the buffer number
    let num = bufnr('%')
    " close the preview
    pclose

    if save_pos[1] == current_line && current_buffer == num
      echo "You're on the definition."
      return
    end

    " float the peek
    if exists('g:tag_peek_float_config')
        let config = call(g:tag_peek_float_config, [])
    else
        let config = call('<SID>DefaultFloatConfig', [])
    endif

    let g:floating_peek = nvim_open_win(l:num, 1, config)
    setlocal number

    " jump to the match
    call setpos('.', save_pos)

    call s:MapPeekKeys()

    augroup ClosePeekOnExitAU
        au!
        au BufLeave,WinLeave <buffer> call tag_peek#ClosePeek()
    augroup END
endfunction

function! tag_peek#FloatByCommand(cmd)
    try
        execute a:cmd
        call s:FloatPeek()
    catch
        call s:Warn(v:exception)
        pclose
    endtry
endfunction

function! s:MapPeekKeys()
    if g:tag_peek_mappings == 1
        nnoremap <buffer> q :call tag_peek#ClosePeek()<CR>

        " jump to the next and previous usages of the tag
        nnoremap <buffer> <c-n> :call tag_peek#FloatByCommand('ptnext')<CR>
        nnoremap <buffer> <c-p> :call tag_peek#FloatByCommand('ptprevious')<CR>

        " edit the currently peeked file
        nnoremap <buffer> <c-e> :call tag_peek#PromotePeek()<CR>
    endif
endfunction

function! tag_peek#ClosePeek()
    silent! augroup! ClosePeekOnExitAU
    silent! call nvim_win_close(g:floating_peek, 1)
    mapclear <buffer>
endfunction

function! tag_peek#PromotePeek()
    let save_pos = getpos('.')
    let file = expand('%')

    :q
    execute ':' . g:tag_peek_split_command

    execute ':e ' . file
    call setpos('.', save_pos)
endfunction

function! tag_peek#ShowTag(...)
    let tag = a:0 >= 1 ? a:1 : expand('<cword>')

    try
        exec 'ptag ' . tag
        call s:FloatPeek()
    catch /E426/
        call s:Warn('tag not found: ' . l:tag)
    endtry
endfunction
