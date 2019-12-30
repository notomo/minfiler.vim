
let s:suite = themis#suite('plugin.minfiler')
let s:assert = MinfilerTestAssert()

function! s:suite.before_each()
    call MinfilerTestBeforeEach()
endfunction

function! s:suite.after_each()
    call MinfilerTestAfterEach()
endfunction

function! s:suite.filer_open()
    let cwd = getcwd()

    Minfiler
    call s:buffer_log()

    call s:assert.current_line('..')
    call s:assert.working_dir(cwd)
    call s:assert.filetype('minfiler')

    call search('Makefile')
    call s:child()

    call s:assert.file_name('Makefile')
endfunction

function! s:suite.go_child_and_parent()
    let cwd = getcwd()

    Minfiler
    call s:buffer_log()

    call search('autoload')
    call s:child()
    call s:buffer_log()
    call s:assert.working_dir(cwd . '/autoload')

    call search('minfiler')
    call s:child()
    call s:buffer_log()
    call s:assert.working_dir(cwd . '/autoload/minfiler')

    call search('nvim\.vim')
    call s:child()

    call s:assert.file_name('nvim.vim')
endfunction

function! s:child() abort
    execute 'normal l'
endfunction

function! s:buffer_log() abort
    call themis#log('')
    let lines = getbufline('%', 1, '$')
    for line in lines
        call themis#log('[buffer] ' . line)
    endfor
endfunction
