
let s:helper = MinfilerTestHelper()
let s:suite = s:helper.suite('plugin.minfiler')
let s:assert = s:helper.assert

function! s:open_child() abort
    execute 'normal l'
endfunction

function! s:open_parent() abort
    execute 'normal h'
endfunction

function! s:suite.filer_open()
    let cwd = getcwd()

    Minfiler
    call s:helper.buffer_log()

    call s:assert.current_line('..')
    call s:assert.working_dir(cwd)
    call s:assert.filetype('minfiler')

    let test_dir_line = s:helper.search('test')
    let makefile_line = s:helper.search('Makefile')
    call s:assert.true(test_dir_line < makefile_line, 'dir should be above than file')
    call s:open_child()

    call s:assert.file_name('Makefile')
endfunction

function! s:suite.go_child_and_parent()
    let cwd = getcwd()

    Minfiler
    call s:helper.buffer_log()

    call s:helper.search('autoload')
    call s:open_child()
    call s:helper.buffer_log()
    call s:assert.working_dir(cwd . '/autoload')

    call s:open_parent()
    call s:helper.buffer_log()
    call s:assert.working_dir(cwd)

    call s:open_child()
    call s:helper.buffer_log()
    call s:assert.working_dir(cwd . '/autoload')

    call s:helper.search('minfiler')
    call s:open_child()
    call s:helper.buffer_log()
    call s:assert.working_dir(cwd . '/autoload/minfiler')

    call s:helper.search('nvim\.vim')
    call s:open_child()

    call s:assert.file_name('nvim.vim')
endfunction
