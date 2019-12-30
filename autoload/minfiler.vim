
if has('nvim')
    let s:filer = function('minfiler#nvim#filer')
    let s:open = function('minfiler#nvim#open')
else
    let s:filer = function('minfiler#vim#filer')
    let s:open = function('minfiler#vim#open')
endif

function! minfiler#main() abort
    edit minfiler://minfiler
    setlocal filetype=minfiler
    call s:filer('.')
endfunction

"" Open the file or move to the directory
function! minfiler#open() abort
    call s:open()
endfunction

augroup minfiler
    autocmd!
    autocmd FileType minfiler call s:mappings()
augroup END

function! s:mappings() abort
    nnoremap <buffer> l :<C-u>call minfiler#open()<CR>
    nnoremap <buffer> h gg:<C-u>call minfiler#open()<CR>
    nnoremap <silent> <buffer> <expr> j line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent> <buffer> <expr> k line('.') == 1 ? 'G' : 'k'
endfunction
