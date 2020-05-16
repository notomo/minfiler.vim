
if has('nvim')
    let s:set_props = function('minfiler#nvim#set_props')
    let s:open = function('minfiler#nvim#open')
else
    let s:set_props = function('minfiler#vim#set_props')
    let s:open = function('minfiler#vim#open')
endif

function! minfiler#main() abort
    edit minfiler://minfiler
    setlocal filetype=minfiler
    call minfiler#filer('.')
endfunction

"" Open the file or move to the directory
function! minfiler#open() abort
    call s:open()
endfunction

function! minfiler#filer(path) abort
    let path = fnamemodify(a:path, ':p:gs?\?\/?:s?[^:]\zs\/$??')
    let files = map(readdir(path), {_, v -> printf('%s/%s', path, v)})
    call sort(files, { a, b -> isdirectory(b) - isdirectory(a)})

    let dir = {}
    let dir.paths = [fnamemodify(path, ':h:s?^\.$?\/?')] + map(copy(files), {_, v -> fnamemodify(v, ':p:gs?\?\/?')})
    let dir.before = fnamemodify(getcwd(), ':gs?\?\/?') . '/'

    setlocal modifiable
    silent %delete _
    call setline(1, ['..'] + map(copy(files), {_, v -> fnamemodify(v, ':t')}))
    setlocal nomodifiable nomodified buftype=nofile bufhidden=wipe

    call s:set_props(dir)
    execute 'lcd' path
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
