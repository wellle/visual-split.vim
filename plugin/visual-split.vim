" normal mode mappings set operator functions
" TODO: make these silent?
nnoremap <silent> <C-W>gr  :<C-u>set operatorfunc=<SID>opgr<CR>g@
nnoremap <silent> <C-W>gss :<C-u>set operatorfunc=<SID>opgss<CR>g@
nnoremap <silent> <C-W>gsa :<C-u>set operatorfunc=<SID>opgsa<CR>g@
nnoremap <silent> <C-W>gsb :<C-u>set operatorfunc=<SID>opgsb<CR>g@

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

" visual mappings execute commands
xnoremap <silent> <C-W>gr  :VSResize<CR>
xnoremap <silent> <C-W>gss :VSSplit<CR>
xnoremap <silent> <C-W>gsa :VSSplitAbove<CR>
xnoremap <silent> <C-W>gsb :VSSplitBelow<CR>

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

    execute (a:line2 - a:line1 + 1) . "wincmd _"
    call s:scroll(a:line1)
endfunction

function! s:split(position, line1, line2)
    execute a:position . (a:line2 - a:line1 + 1) . "wincmd s"
    call s:scroll(a:line1)
    wincmd p
endfunction

function! s:scroll(line)
    let scrolloff = &scrolloff
    let &scrolloff = 0
    call cursor(a:line, 0)
    normal! ztM
    let &scrolloff=scrolloff
endfunction

function! s:single()
    " remember original window
    let winnr = winnr()

    wincmd k " try to move up
    if winnr() != winnr " found window above
        wincmd p " move back
        return 0
    endif

    wincmd j " try to move down
    if winnr() != winnr " found window below
        wincmd p " move back
        return 0
    endif

    return 1
endfunction
