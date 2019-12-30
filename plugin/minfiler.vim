if exists('g:loaded_minfiler')
    finish
endif
let g:loaded_minfiler = 1

"" Open a filer
command! Minfiler call minfiler#main()
