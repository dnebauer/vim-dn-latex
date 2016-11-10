" settings for ATP/Automatic LaTeX Plugin
" ---------------------------------------

" this script is sourced twice during file load/read
" - sometimes it is important to know which iteration it is
" - variable 'b:atprc_read_once' is set at end of file
" - so, this script must not exit|return before end of file

" atp: completion uses vim regex, not python
let g:atp_bibsearch='vim'

" jump out of current environment to next/previous one
nmap <buffer> <silent> >E <Plug>JumptoNextEnvironmentzz
nmap <buffer> <silent> <E <Plug>JumptoPreviousEnvironmentzz

" show progress information on tex compilation
let g:atp_ProgressBar=g:dn_true
let g:atp_statusNotif=g:dn_true

" switching to lualatex as successor to pdflatex
let b:atp_TexCompiler='lualatex'

" record file details
" - can be used by package 'currfile' to get absolute file path
if exists('b:atp_TexOptions')
    if b:atp_TexOptions !~# '-recorder'
        let b:atp_TexOptions .= ',-recorder'
    endif
else
    let b:atp_TexOptions = ',-recorder'
endif

" remove <C-J> and <C-K> mappings to prevent conflict with UltiSnips
" - because atp mappings are local to buffer these unmappings affect only
"   the atp mappings and leave intact the global UltiSnips mappings
" - check for mapping first because atprc is sourced twice on file opening
"   and a missing map error would otherwise occur on the second sourcing
if hasmapto('<Plug>TexJMotionForward', 'in')
    iunmap <buffer> <C-j>
endif
if hasmapto('<Plug>TexJMotionBackward', 'in')
    iunmap <buffer> <C-k>
endif

" Deactivate <Right> mapping as it interferes with Ctrl-J mapping
" if no existing mapping throw  'E31 = No such mapping'
try
    nunmap <Right>
catch /^Vim\((\a\+)\)\=:E31:/
endtry                             
try
    nunmap <Right>
catch /^Vim\((\a\+)\)\=:E31:/
endtry                             

" atp-vim overwrites CommandT mappings \l and \u
" - let's provide alternate mappings \T and \U
nnoremap <buffer> <silent> <Leader>T :CommandT<CR>
nnoremap <buffer> <silent> <Leader>U :CommandTBuffer<CR>

" use subdirectory for intermediate files
" create symlink in main directory to pdf output file
" - only unix
if has('unix') && !exists('b:atprc_read_once')
    let b:dna_atprc_file = '.dna_atprc'
    let b:dn_error = g:dn_false
    function! DnaRunCommand(cmd)
        let l:feedback = system(a:cmd)
        if v:shell_error
            let b:dn_error = g:dn_true
            echoerr 'Command failed: ' . a:cmd
            echoerr 'Shell feedback: ' . l:feedback
            return g:dn_false
        endif
        return g:dn_true
    endfunction
    function! DnaAtprcFileExists()
        return filereadable(b:dna_atprc_file)
    endfunction
    function! DnaUseWorkingDir()
        if !DnaAtprcFileExists()
            return g:dn_false
        endif
        let l:retval = g:dn_false
        let l:contents = readfile(b:dna_atprc_file)
        for l:line in l:contents
            let l:tokens = split(l:line, ' ')
            let l:tokens = filter(l:tokens, "v:val !~? '^$'")
            " must be ['workingdir',<nonzero>]
            if len(l:tokens) == 2 && l:tokens[0] =~? '^workingdir$'
                        \ && l:tokens[1] != g:dn_false
                let l:retval = g:dn_true
            endif
        endfor
        return l:retval
    endfunction
    function! DnaSetUserPreference(preference)
        let b:dna_atprc_file = '.dna_atprc'
        let l:content = [
                    \   'WorkingDir ' . a:preference
                    \ ]
        call writefile(l:content, b:dna_atprc_file)
    endfunction
    function! DnaGetUserPreference()
        let l:msg = 'Use intermediate subdirectory '
                    \ . 'and symlink to pdf output?'
        let l:wants = confirm(l:msg, "&Yes\n&No", 1, 'Q')
        if l:wants != g:dn_true | let l:wants = g:dn_false | endif
        return l:wants
    endfunction
    function! DnaSubdirExists()
        return isdirectory(b:atp_OutDir)
    endfunction
    function! DnaPdfLinkExists()
        call system('test -L ' . b:dn_outfile)
        if v:shell_error
            return g:dn_false
        else
            return g:dn_true
        endif
    endfunction
    function! DnaSubdirSetUp()
        return DnaSubdirExists() && DnaPdfLinkExists()
    endfunction
    function! DnaRemoveLinkFile()
        call DnaRunCommand('rm -f ' . b:dn_outfile)
        return !DnaSubdirExists()
    endfunction
    function! DnaCreateLink()
        call DnaRunCommand('ln -s ' . b:dn_target . ' ' . b:dn_outfile)
        return DnaPdfLinkExists()
    endfunction
    function! DnaRemoveSubdir()
        call DnaRunCommand('rm -fr ' . b:atp_OutDir)
        return !DnaSubdirExists()
    endfunction
    " set vars
    let b:dn_workdir = 'working'         " subdir to hold intermediate files
    let b:atp_OutDir = b:atp_ProjectDir . '/' . b:dn_workdir
    let b:dn_outfile = expand('%:r') . '.pdf'
    let b:dn_target = b:dn_workdir . '/' . b:dn_outfile
    " decide whether to create subdir and symlink
    let b:make_subdir = g:dn_false
    if DnaAtprcFileExists()    " user has set preference
        let b:make_subdir = DnaUseWorkingDir()
    else    " user has not set preference
        " but working directory and pdf link may already exist
        if DnaSubdirSetUp()    " fully set up - accept as preference
            let b:make_subdir = g:dn_true
        elseif DnaSubdirExists() || DnaPdfLinkExists()
            " partially set up - user must decide
            if DnaSubdirExists()
                echo 'Working directory already exists but pdf link does not'
            else
                echo 'Pdf link exists but working directory does not'
            endif
            let b:make_subdir = DnaGetUserPreference()
        else    " neither exists - user must decide
            let b:make_subdir = DnaGetUserPreference()
        endif
        call DnaSetUserPreference(b:make_subdir)
    endif
    " if user chose not to use subdir, delete any previous setup
    if !b:make_subdir
        if DnaSubdirExists()
            call DnaRemoveSubdir()
        endif
        if DnaPdfLinkExists()
            call DnaRemoveLinkFile()
        endif
    endif
    " if user chose to use subdir, first try to create subdir
    if b:make_subdir
        " create subdirectory
        if !isdirectory(b:atp_OutDir)
            if !mkdir(b:atp_OutDir)
                echoerr 'unable to create latex working directory:'
                echoerr '  ' . b:atp_OutDir
                let b:make_subdir = g:dn_false
            endif
        endif
    endif
    " now create symlink
    if b:make_subdir
        " cannot use 'filereadable(b:dn_outfile)' because it returns true on symlink
        "   only if both link and target are present - it cannot detect case where
        "   link is present but target is not; use 'system(test -L)' instead
        if !DnaPdfLinkExists()
            " remove any existing file (not a symlink) of same name
            if filereadable(b:dn_outfile)
                call DnaRemoveLinkFile()
            endif
            " now create link
            " - works even in absence of target file
            if !DnaCreateLink()
                echoerr 'Unable to create symlink to target pdf file'
            endif
        endif
    endif
    " pause if errors occurred so user can read error messages
    if exists('b:dn_error') && b:dn_error
        call input('Press any key to continue...')
    endif
    " tidy up
    unlet! b:dn_workdir b:msg b:dn_outfile b:dn_target b:dn_error
    delfunction DnaRunCommand    | delfunction DnaAtprcFileExists
    delfunction DnaUseWorkingDir | delfunction DnaSetUserPreference
    delfunction DnaGetUserPreference
endif

" enable use of ':Bibtex' command when there is no 'aux' file
if isdirectory(b:atp_OutDir) && exists('g:atp_keep')
"    let g:atp_keep+=['bib']
endif

" this script is sourced twice during file load/read
" - sometimes it is important to know which iteration it is
" - this if branch should stay the last thing in this file
if !exists('b:atprc_read_once')
    let b:atprc_read_once = g:dn_true
endif

