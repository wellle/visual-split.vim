" provide <Plug> mappings for easy remapping
nnoremap <silent> <Plug>(Visual-Split-Resize)     :<C-u>set operatorfunc=<SID>opgr<CR>g@
nnoremap <silent> <Plug>(Visual-Split-Split)      :<C-u>set operatorfunc=<SID>opgss<CR>g@
nnoremap <silent> <Plug>(Visual-Split-SplitAbove) :<C-u>set operatorfunc=<SID>opgsa<CR>g@
nnoremap <silent> <Plug>(Visual-Split-SplitBelow) :<C-u>set operatorfunc=<SID>opgsb<CR>g@

" normal mode mappings set operator functions
" TODO: make these silent?
silent! nmap <unique> <C-W>gr  <Plug>(Visual-Split-Resize)
silent! nmap <unique> <C-W>gss <Plug>(Visual-Split-Split)
silent! nmap <unique> <C-W>gsa <Plug>(Visual-Split-SplitAbove)
silent! nmap <unique> <C-W>gsb <Plug>(Visual-Split-SplitBelow)

" operator functions trigger visual mappings
function! s:opgr(type, ...)
    call s:op("gr")
endfunction

function! s:opgss(type, ...)
    call s:op("gss")
endfunction

function! s:opgsa(type, ...)
    call s:op("gsa")
endfunction

function! s:opgsb(type, ...)
    call s:op("gsb")
endfunction

function! s:op(trigger)
    silent execute "normal! '[V']"
    silent execute "normal \<C-W>" . a:trigger
endfunction

" provide <Plug> mappings for easy remapping
xnoremap <silent> <Plug>(Visual-Split-VSResize)     :VSResize<CR>
xnoremap <silent> <Plug>(Visual-Split-VSSplit)      :VSSplit<CR>
xnoremap <silent> <Plug>(Visual-Split-VSSplitAbove) :VSSplitAbove<CR>
xnoremap <silent> <Plug>(Visual-Split-VSSplitBelow) :VSSplitBelow<CR>

" visual mappings execute commands
silent! xmap <unique> <C-W>gr  <Plug>(Visual-Split-VSResize)
silent! xmap <unique> <C-W>gss <Plug>(Visual-Split-VSSplit)
silent! xmap <unique> <C-W>gsa <Plug>(Visual-Split-VSSplitAbove)
silent! xmap <unique> <C-W>gsb <Plug>(Visual-Split-VSSplitBelow)

" commands call functions
command! -range VSResize     call <SID>resize(<line1>, <line2>)
command! -range VSSplit      call <SID>split("",      <line1>, <line2>)
command! -range VSSplitAbove call <SID>split("above", <line1>, <line2>)
command! -range VSSplitBelow call <SID>split("below", <line1>, <line2>)

" functions execute wincmds
function! s:resize(line1, line2)
    if s:single()
        return
    endif

    execute s:lines_between(a:line1, a:line2) . "wincmd _"
    call s:scroll(a:line1)
endfunction

function! s:split(position, line1, line2)
    execute a:position . s:lines_between(a:line1, a:line2) . "wincmd s"
    call s:scroll(a:line1)
    wincmd p
endfunction

function! s:lines_between(line1, line2)
    if &wrap
        " Calculate the number of visibly selected lines, which may be more
        " than the number of actual selected lines.
        return s:visual_lines_between(a:line1, a:line2)
    else
        " The number of selected lines is a simple calculation.
        return a:line2 - a:line1 + 1
    endif
endfunction

function! s:visual_lines_between(line1, line2)
    call cursor(a:line1, 0)

    let l:visual_lines = 0
    let l:previous_line = line('.')
    let l:previous_col = col('.')

    " Count lines until reach a:line2, or have counted up to lines that can be
    " displayed in this Vim instance (no point counting beyond this as can't
    " resize window larger than this, and can seriously harm performance).
    while line('.') <= a:line2 && l:visual_lines < &lines
        normal! gj
        let l:visual_lines += 1

        if line('.') == l:previous_line && col('.') == l:previous_col
            " We haven't moved from our previous position, so must be on the
            " last visual line. We need to break out now since we're never
            " going to reach a:line2 and would loop indefinitely.
            break
        endif

        let l:previous_line = line('.')
        let l:previous_col = col('.')
    endwhile

    " Move to back to first row and column of selection.
    call cursor(a:line1, 1)

    return l:visual_lines
endfunction

function! s:scroll(line)
    let scrolloff = &scrolloff
    let &scrolloff = 0
    call cursor(a:line, 0)
    normal! ztM
    let &scrolloff=scrolloff
endfunction

function! s:single()
    " Remember current previous window, as will be overwritten by process of
    " determining if this is a singular window and we will need to reset it.
    wincmd p
    let previous_winnr = winnr()
    wincmd p

    " remember original window
    let winnr = winnr()

    wincmd k " try to move up
    if winnr() != winnr " found window above
        wincmd p " Move back to original window.
        call s:reset_previous_window(previous_winnr)
        return 0
    endif

    wincmd j " try to move down
    if winnr() != winnr " found window below
        wincmd p " Move back to original window.
        call s:reset_previous_window(previous_winnr)
        return 0
    endif

    return 1
endfunction

function! s:reset_previous_window(previous_winnr)
    " Switch to remembered window and back again to reset previous window to
    " what it was before we overwrote it.
    execute a:previous_winnr.'wincmd w'
    wincmd p
endfunction
