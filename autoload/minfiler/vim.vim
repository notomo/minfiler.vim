
let s:buf_props = {}
let s:dir_type_name = 'minfiler_dir'
let s:file_type_name = 'minfiler_file'

if empty(prop_type_get(s:dir_type_name))
    call prop_type_add(s:dir_type_name, {'highlight': 'MinfilerDir'})
endif
if empty(prop_type_get(s:file_type_name))
    call prop_type_add(s:file_type_name, {})
endif

function! minfiler#vim#set_props(dir) abort
    let props = {}
    let line = 1
    for p in a:dir.paths
        let id = line
        let is_dir = isdirectory(p)
        call prop_add(line, 1, {'length': len(getline(line)), 'type': is_dir ? s:dir_type_name : s:file_type_name, 'id': id})
        let prop = {'path': p, 'is_dir': is_dir}
        let props[id] = prop

        if prop.path ==? a:dir.before
            call setpos('.', [0, line, 0, 0])
        endif

        let line += 1
    endfor
    let s:buf_props[bufnr('%')] = props
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
        return minfiler#filer(prop.path)
    endif
    execute 'edit' prop.path
endfunction
