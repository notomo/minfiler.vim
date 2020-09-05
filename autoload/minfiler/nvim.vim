
let s:ns = nvim_create_namespace('minfiler')
let s:buf_props = {}

function! minfiler#nvim#set_props(dir) abort
    let bufnr = bufnr('%')
    call nvim_buf_clear_namespace(bufnr, s:ns, 0, -1)

    let props = {}
    let line = 0
    for p in a:dir.paths
        let opts = {}
        let is_dir = isdirectory(p)
        if is_dir
            let opts['hl_group'] = 'MinfilerDir'
            let opts['end_col'] = len(getline(line + 1))
        endif
        let id = nvim_buf_set_extmark(bufnr, s:ns, line, 0, opts)
        let prop = {'path': p, 'is_dir': is_dir}
        let props[id] = prop

        let line += 1

        if prop.path ==? a:dir.before
            call setpos('.', [0, line, 0, 0])
        endif
    endfor
    let s:buf_props[bufnr] = props
endfunction

function! minfiler#nvim#open() abort
    let bufnr = bufnr('%')
    if !has_key(s:buf_props, bufnr)
        return
    endif

    let index = line('.') - 1
    let marks = nvim_buf_get_extmarks(bufnr, s:ns, [index, 0], [index, -1], {})
    if empty(marks)
        return
    endif

    let prop = s:buf_props[bufnr][marks[0][0]]
    if prop.is_dir
        return minfiler#filer(prop.path)
    endif
    execute 'edit' prop.path
endfunction
