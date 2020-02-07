
let s:buf_props = {}
let s:dir_type_name = 'minfiler_dir'
let s:file_type_name = 'minfiler_file'

if empty(prop_type_get(s:dir_type_name))
    call prop_type_add(s:dir_type_name, {'highlight': 'MinfilerDir'})
endif
if empty(prop_type_get(s:file_type_name))
    call prop_type_add(s:file_type_name, {})
endif

function! minfiler#vim#filer(path) abort
    let bufnr = bufnr('%')
    let path = fnamemodify(a:path, ':p:gs?\?\/?:s?[^:]\zs\/$??')
    let files = glob(path . '/*', v:true, v:true)
    call sort(files, { a, b -> isdirectory(b) - isdirectory(a)})

    setlocal modifiable
    silent %delete _
    call setline(1, ['..'] + map(copy(files), {_, v -> fnamemodify(v, ':t')}))
    setlocal nomodifiable nomodified buftype=nofile bufhidden=wipe

    let props = {}
    let line = 1
    let paths = [fnamemodify(path, ':h:s?^\.$?\/?')] + map(copy(files), {_, v -> fnamemodify(v, ':p:gs?\?\/?')})
    for p in paths
        let id = line
        let is_dir = isdirectory(p)
        call prop_add(line, 1, {'length': len(getline(line)), 'type': is_dir ? s:dir_type_name : s:file_type_name, 'id': id})
        let prop = {'path': p, 'is_dir': is_dir}
        let props[id] = prop
        let line += 1
    endfor
    let s:buf_props[bufnr] = props
    execute 'lcd' path
endfunction

function! minfiler#vim#open() abort
    let bufnr = bufnr('%')
    if !has_key(s:buf_props, bufnr)
        return
    endif

    let props = prop_list(line('.'))
    if empty(props)
        return
    endif

    let prop = s:buf_props[bufnr][props[0].id]
    if prop.is_dir
        return minfiler#vim#filer(prop.path)
    endif
    execute 'edit' prop.path
endfunction
