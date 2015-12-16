" normal mode mappings set operator functions
nnoremap <C-W>gr  :<C-u>set operatorfunc=<SID>opgr<CR>g@
nnoremap <C-W>gss :<C-u>set operatorfunc=<SID>opgss<CR>g@
nnoremap <C-W>gsa :<C-u>set operatorfunc=<SID>opgsa<CR>g@
nnoremap <C-W>gsb :<C-u>set operatorfunc=<SID>opgsb<CR>g@

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
xnoremap <C-W>gr  :VSResize<CR>
xnoremap <C-W>gss :VSSplit<CR>
xnoremap <C-W>gsa :VSSplitAbove<CR>
xnoremap <C-W>gsb :VSSplitBelow<CR>

" commands call functions
command! -range VSResize     call <SID>resize(<line1>, <line2>)
command! -range VSSplit      call <SID>split("",      <line1>, <line2>)
command! -range VSSplitAbove call <SID>split("above", <line1>, <line2>)
command! -range VSSplitBelow call <SID>split("below", <line1>, <line2>)

" functions execute wincmds
function! s:resize(line1, line2)
    execute (a:line2 - a:line1 + 1) . "wincmd _"
    call s:scroll(a:line1)
endfunction

function! s:split(position, line1, line2)
    execute a:position . (a:line2 - a:line1 + 1) . "wincmd s"
    call s:scroll(a:line1)
endfunction

function! s:scroll(line)
    let scrolloff = &scrolloff
    let &scrolloff = 0
    call cursor(a:line, 0)
    normal! ztM
    let &scrolloff=scrolloff
endfunction
