
let s:namespace = nvim_create_namespace('minfiler')
let s:buf_props = {}

function! minfiler#nvim#filer(path) abort
    let bufnr = bufnr('%')
    let path = fnamemodify(a:path, ':p:gs?\?\/?:s?[^:]\zs\/$??')
    let files = glob(path . '/*', v:true, v:true)
    call sort(files, { a, b -> isdirectory(b) - isdirectory(a)})

    setlocal modifiable
    silent %delete _
    call setline(1, ['..'] + map(copy(files), {_, v -> fnamemodify(v, ':t')}))
    setlocal nomodifiable nomodified buftype=nofile bufhidden=wipe

    call nvim_buf_clear_namespace(bufnr, s:namespace, 0, -1)

    let props = {}
    let line = 0
    let paths = [fnamemodify(path, ':h:s?^\.$?\/?')] + map(copy(files), {_, v -> fnamemodify(v, ':p:gs?\?\/?')})
    let before_path = fnamemodify(getcwd(), ':gs?\?\/?') . '/'
    for p in paths
        let id = nvim_buf_set_extmark(bufnr, s:namespace, 0, line, 0, {})
        let is_dir = isdirectory(p)
        if is_dir
            call nvim_buf_add_highlight(bufnr, s:namespace, 'MinfilerDir', line, 0, -1)
        endif
        let prop = {'path': p, 'is_dir': is_dir}
        let props[id] = prop

        let line += 1

        if prop.path ==? before_path
            call setpos('.', [0, line, 0, 0])
        endif
    endfor
    let s:buf_props[bufnr] = props
    execute 'lcd' path
endfunction

function! minfiler#nvim#open() abort
    let bufnr = bufnr('%')
    if !has_key(s:buf_props, bufnr)
        return
    endif

    let index = line('.') - 1
    let marks = nvim_buf_get_extmarks(bufnr, s:namespace, [index , 0], [index, -1], {})
    if empty(marks)
        return
    endif

    let prop = s:buf_props[bufnr][marks[0][0]]
    if prop.is_dir
        return minfiler#nvim#filer(prop.path)
    endif
    execute 'edit' prop.path
endfunction
