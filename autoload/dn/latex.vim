" Vim ftplugin for latex
" Last change: 2018 Aug 6
" Maintainer: David Nebauer
" License: GPL3

" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

" Documentation    {{{1

""
" @section Introduction, intro
" @order mappings vars
" An auxiliary latex (tex) filetype plugin providing some useful features.  It
" is assumed the primary LaTeX plugin being used is Automatic LaTeX Plugin for
" Vim. In fact, this plugin provides an atprc file that can be used as the
" primary user atp configuration file, or can be called from it. Not all
" features of this plugin require ATP, but some do.
" 
" This plugin also assumes the availability of the |dn-utils| plugin. It
" relies on variables and functions provided by it. It contributes to the
" dn-utils help system that is triggered by <Leader>help, usually \help.
"
" @subsection Templates
"
" Templates are provided for article, report, book and beamer presentation
" documents. Function @function(dn#latex#insertTemplate) provides for the user
" to select document type and enter document author, title and description
" (and institute for Beamer presentations). An appropriate template is
" inserted and the values replace tokens in the templates. Function
" @function(#dn#latex#insertTemplate) is designed to be called from the
" |vimrc| file or the |BufNewFile| event.
"
" @subsection Beamer
"
" The plugin includes files for beamer themes Air, Amsterdam, Bunsen,
" Frederiksberg, Lleida, McGill, Oxygen, Stockton, Sybila, Torino and UNL.
" These files are located in the plugin's "vim-dn-latex-resources/beamer"
" plugin subdirectory. To install the themes in tex they need to copied into a
" latex directory. Assuming "vim-dn-latex-resources/beamer" is on the
" runtimepath, the beamer files can be copied to the TEXMFHOME directory
" (usually "~/texmf" on unix) by running the @function(dn#latex#syncBeamer)
" function. This function determines the target directory using "kpsewhich",
" copies (synchronises) the beamer files into it using "rsync", and the tex
" ls-R database is updated by "mktexlsr" (on some systems "mktexlsr" is called
" "texhash").
"
" @subsection Git integration
"
" "Git provides hooks which trigger custom scripts when certain actions
" occur. The "vim-dn-latex-resources/git" plugin directory contains a bash
" script called "post-merge" which is designed to be run after a git merge.
" The script uses "kpsewhich", "rsync" and "mktexlsr"
" to synchronise beamer files. It assumes the beamer files are located at
" "$HOME/.vim/bundle/vim-dn-latex/vim-dn-latex-resources/beamer/". If the
" beamer files are installed in a different location the script needs to be
" edited accordingly.
" 
" The script cannot be distributed with the repository in such a way as to
" automatically install on the client side. It must be installed by the
" user. There are several methods by which the script can be called during
" plugin updates (that include a "git merge/pull"). Some package managers,
" such as vundle, perform a git pull on every plugin update. The easiest
" method on a unix system to automate running the script after every "git
" pull" is to create a git template directory with a hooks subdirectory:
" >
"   mkdir -p ~/.git-templates/hooks
" <
" then configure this directory as a git templates directory:
" >
"   git config --global init.templatedir '~/.git-templates'
" <
" then install the post-merge script:
" >
"   cp ~/.vim/bundle/vim-dn-latex/vim-dn-latex-resources/git/post-merge \
"           ~/.git-templates/hooks/
" <
" This means the script is copied into every subsequent repository that is
" created. To install it into an existing repository, such as @plugin(name),
" change to the repository root directory and:
" >
"   git init
" <
" Although the post-merge hook to synchronise beamer files is copied into
" every new repository, the script checks the name of the repository that
" calls it and only synchronises beamer files if the repository is named
" "vim-dn-latex".
"
" @subsection UltiSnips integration
"
" The following custom ultisnips snippets are provided:
" * begin:     generic environment wrapper
" * tab:       table environment
" * fig:       figure environment
" * subfig:    figure with two subfigures
" * sfigadd:   additional subfigure
" * eqn:       equation
" * eqa:       equation array
" * eqd:       math environment ("$ ${1} $")
" * enum:      enumerate environment
" * itemize:   itemize environment
" * quote:     quote environment
" * desc:      description environment
" * chap:      chapter environment
" * sec:       section environment
" * sub:       subsection environment
" * subs:      subsubsection environment
" * par:       paragraph environment
" * subp:      subparagraph environment
" * itd:       item with description
" * refchar:   chaper reference
" * reffig:    figure reference
" * reftab:    table reference
" * refsec:    section reference
" * refpag:    page reference
" * citen:     name citation
" * cite:      citation
" * verbatim:  verbatim environment
" * verb:      verb
" * lrp:       left and right parentheses
" * lrb:       left and right braces
" * lra:       left and right angle brackets
" * frame:     empty beamer frame
" * frlist:    beamer frame with itemised list
" * frfig:     beamer frame with figure
" * frsubfig:  beamer frame with multiple subfigures
" * frfullfig: beamer frame with full size image
" * beamerbox: framed/boxed text
"
" @ subsection ATP integration
"
" The Automatic LaTeX Plugin is a latex plugin for latex (project page:
" http://atp-vim.sourceforge.net/, repo: https://github.com/coot/atp_vim).
" 
" This ftplugin provides a configuration file for ATP. The file can be used
" as the base configuration file for ATP or can be sourced by it. The
" configuration file is located in the "vim-dn-latex-resources/atp" directory
" of the plugin.
" 
" The configuration file has the following features:
"
" * Sets ATP to use vim regular expression syntax rather than python
"   completion (by setting g:atp_bibsearch to "vim").
"
" * Provides shortcuts for moving between environments. Moving to the next
"   environment is mapped to ">E" in Normal mode. Moving to the previous
"   environment is mapped to "<E" in Normal mode.
"
" * Sets progress bar to display on tex compilation by setting
"   |g:atp_ProgressBar| to true and |g:atp_statusNotif| to true.
"
" * Switches to the lualatex engine by setting |b:atp_TexCompiler| to
"   "lualatex").
" 
" * Sets the compilation switch '-recorder' by adding it to
"   |b:atp_TexOptions|.
" 
" * Plays nice with the Command-T plugin. The Command-T plugin provides
"   mappings for <Leader>l and <Leader>u (defaults to \l and \u) which call
"   commands "CommandT" and "CommandTBuffer". ATP also maps to <Leader> and
"   <Leader>u. Command-T, however, is well behaved and does not overwrite the
"   ATP mappings. 
" 
" * To make the Command-T mappings available while editing a tex file this
"   configuration file creates alternate mappings <Leader>T and <Leader>U,
"   usually \T and \U, for |:CommandT| and |:CommandTBuffer|, respectively.
"   These mappings are defined only for the buffer.
" 
" * Play nice with the UltiSnips plugin. Both UltiSnips and ATP provide
"   mappings for <C-j> and <C-k>. The ATP mappings are local to the buffer
"   while the UltiSnips mappings are global. Removing the local ATP mappings
"   leaves the UltiSnips amppings intact.
" 
" * Also deactivates the |<Right>| mapping as it interferes with the <C-j>
"   mapping.
" 
" * Optionally configures vim project (ATP considers every directory to be
"   a "project") to use a subdirectory for compilation. The subdirectory is
"   named "working". For each project the user chooses whether or not to use a
"   working directory. If so, the working directory is created and in the
"   project directory a symlink is created to the output pdf file in the
"   working directory. The user's choice is recorded in a hidden file
"   (".dna_atprc") at file creation time so the user is not asked when the
"   file is subsequently opened. If the user later changes their mind about
"   use of a working subdirectory they simply have to delete the ".dna_atprc"
"   file and reopen the project file. The user will be asked again for their
"   preference.

" TODO: replace template dir "@pkgdatatemplates_dir@/" with
"       bundle directory

" Script variables

" s:doc_types             - used for new document creation    {{{1

""
" Latex document types. |Dictionary| keys are a human readable description
" while the value is a token used in s:doc_type_info.
let s:doc_types = {
            \ 'Standard LaTeX 2e article class': 'article',
            \ 'Standard LaTeX 2e report class' : 'report',
            \ 'Standard LaTeX 2e book class'   : 'book',
            \ 'Beamer class for presentations' : 'beamer',
            \ }

" s:doc_type_info         - information about doc types    {{{1

""
" Stores information about document types including the name of the template
" file and the data items to be supplied by the user. The document type name
" used as the primary key corresponds to the values in s:doc_types.
let s:doc_type_info = {
            \ 'article': {
            \       'template': 'article.tex',
            \       'items': ['description', 'author', 'title'],
            \   },
            \ 'report': {
            \       'template': 'report.tex',
            \       'items': ['description', 'author', 'title'],
            \   },
            \ 'book': {
            \       'template': 'book.tex',
            \       'items': ['description', 'author', 'title'],
            \   },
            \ 'beamer': {
            \       'template': 'beamer.tex',
            \       'items': ['description', 'author', 'title', 'institute'],
            \   },
            \ }

" s:data_item_definitions - attributes for data items    {{{1

""
" Attributes of the data items to be provided by the user. The primary key is
" the data item name as used in the "items" lists in s:doc_type_info. The
" attributes are:
" *    name : data item name
" * explain : explanation for user
" *  prompt : console interface prompt to enter data
" * default : default value
" *   token : token in template text to be replaced
let s:data_item_definitions = {
            \ 'author': {
            \       'name'   : 'author',
            \       'explain': 'The document can have one or more authors',
            \       'prompt' : 'Enter author(s): ',
            \       'default': 'David Nebauer',
            \       'token'  : '<AUTHOR>',
            \   },
            \ 'description': {
            \       'name'   : 'description',
            \       'explain': 'The document description should be no more '
            \                  . 'than 60 characters',
            \       'prompt' : 'Enter a brief description: ',
            \       'token'  : '<DESCRIPTION>',
            \   },
            \ 'institute': {
            \       'name'   : 'institute',
            \       'explain': 'The document is produced under the auspices '
            \                  . 'of an institute or body',
            \       'prompt' : 'Enter institute: ',
            \       'default': 'NT Government Department of Health',
            \       'token'  : '<INSTITUTE>',
            \   },
            \ 'title': {
            \       'name'   : 'title',
            \       'explain': 'The document title appears at the head of '
            \                  . 'the document',
            \       'prompt' : 'Enter document title: ',
            \       'token'  : '<TITLE>',
            \   },
            \ }

" s:chars                 - special characters    {{{1

""
" Special characters to be inserted into text. They are grouped into the
" following categories: special, reserved, math/scientific, currency, arrows,
" greek upper, and greek lower.
let s:chars = {}

" Special    {{{2
let s:chars['section (§)']       = '\S{}'
let s:chars['dagger (†)']        = '\dag{}'
let s:chars['double dagger (‡)'] = '\ddag{}'
let s:chars['copyright (©)']     = '\copyright{}'
let s:chars['trademark (™)']     = '\texttrademark{}'
let s:chars['registered (®)']    = '\textregistered{}'
let s:chars['ellipsis (…)']      = '\dots{}'
let s:chars['checkmark (✓)']     = '\checkmark{}'
let s:chars['ballot x (✗)']      = '\XSolidBrush{}'

" Reserved    {{{2
let s:chars['latex reserved']  = {
            \ 'backslash (\)'   : '\textbackslash{}',
            \ 'underscore (_)'  : '\_',
            \ 'percent (%)'     : '\%',
            \ 'open brace ({)'  : '\{',
            \ 'close brace (})' : '\}',
            \ 'ampersand (&)'   : '\&',
            \ 'hash (#)'        : '\#'
            \ }

" Math/scientific    {{{2
let s:chars['math/scientific'] = {
            \ 'math asterisk (∗)'   : '\textasteriskcentered{}',
            \ 'math multiply (×)'   : '$\times$',
            \ 'micro (µ)'           : '\micro{}',
            \ 'degrees (°)'         : '\degree{}',
            \ 'degrees celsius (℃)' : '\textcelsius'
            \ }

" Currency    {{{2
let s:chars['currency']        = {
            \ 'dollar ($)' : '\$',
            \ 'pound (£)'  : '\pounds{}',
            \ 'euro (€)'   : '\texteuro{}',
            \ 'cent (¢)'   : '\textcent{}'
            \ }

" Arrows    {{{2
let s:chars['arrows']          = {
            \ 'left (←)'       : '$\leftarrow$',
            \ 'long left (⟵)'  : '$\longleftarrow$',
            \ 'right (→)'      : '$\rightarrow$',
            \ 'long right (⟶)' : '$\longrightarrow$'
            \ }

" Greek upper    {{{2
let s:chars['greek upper']     = {
            \ 'Alpha (Α)'   : 'A',
            \ 'Beta (Β)'    : 'B',
            \ 'Gamma (Γ)'   : '$\Gamma$',
            \ 'Delta (Δ)'   : '$\Delta',
            \ 'Epsilon (Ε)' : 'E',
            \ 'Zeta (Ζ)'    : 'Z',
            \ 'Eta (Η)'     : 'H',
            \ 'Theta (Θ)'   : '$\Theta$',
            \ 'Iota (Ι)'    : 'I',
            \ 'Kappa (Κ)'   : 'K',
            \ 'Lambda (Λ)'  : '$\Lambda$',
            \ 'Mu (Μ)'      : 'M',
            \ 'Nu (Ν)'      : 'N',
            \ 'Xi (Ξ)'      : '$\Xi$',
            \ 'Omicron (Ο)' : 'O',
            \ 'Pi (Π)'      : '$\Pi$',
            \ 'Rho (Ρ)'     : 'P',
            \ 'Sigma (Σ)'   : '$\Sigma$',
            \ 'Tau (Τ)'     : 'T',
            \ 'Upsilon (Υ)' : '$\Upsilon$',
            \ 'Phi (Φ)'     : '$\Phi$',
            \ 'Chi (Χ)'     : 'X',
            \ 'Psi (Ψ)'     : '$\Psi$',
            \ 'Omega (Ω)'   : '$\Omega$'
            \ }

" Greek lower    {{{2
let s:chars['greek lower']     = {
            \ 'alpha (α)'      : '$\alpha$',
            \ 'beta (β)'       : '$\beta$',
            \ 'gamma (γ)'      : '$\gamma$',
            \ 'delta (δ)'      : '$\delta$',
            \ 'epsilon (ϵ)'    : '$\epsilon$',
            \ 'varepsilon (ε)' : '$\varepsilon$',
            \ 'zeta (ζ)'       : '$\zeta$',
            \ 'eta (η)'        : '$\eta$',
            \ 'theta (θ)'      : '$\theta$',
            \ 'vartheta (ϑ)'   : '$\vartheta$',
            \ 'iota (ι)'       : '$\iota$',
            \ 'kappa (κ)'      : '$\kappa$',
            \ 'varkappa (ϰ)'   : '$\varkappa$',
            \ 'lambda (λ)'     : '$\lambda$',
            \ 'mu (μ)'         : '$\mu$',
            \ 'nu (ν)'         : '$\nu$',
            \ 'xi (ξ)'         : '$\xi$',
            \ 'omicron (ο)'    : 'o',
            \ 'pi (π)'         : '$\pi$',
            \ 'varpi (ϖ)'      : '$\varpi$',
            \ 'rho (ρ)'        : '$\rho$',
            \ 'varrho (ϱ)'     : '$\varrho$',
            \ 'sigma (σ)'      : '$\sigma$',
            \ 'varsigma (ς)'   : '$\varsigma$',
            \ 'tau (τ)'        : '$\tau$',
            \ 'upsilon (υ)'    : '$\upsilon$',
            \ 'phi (ϕ)'        : '$\phi$',
            \ 'varphi (φ)'     : '$\varphi$',
            \ 'chi (χ)'        : '$\chi$',
            \ 'psi (ψ)'        : '$\psi$',
            \ 'omega (ω)'      : '$\omega$'
            \ }

" s:plugin_resources_dir  - plugin resources directory    {{{1

""
" Plugin resources directory.
let s:plugin_resources_dir = ''
" }}}1

" Script functions

" s:deactivateRightMapping()    {{{1

""
" @private
" Deactivate <Right> mapping as it interferes with the Ctrl-J mapping.
function! s:deactivateRightMapping()
    " throws 'E31: No such mapping' error if no mapping for <Right>, so
    " intercept it
    try
        nunmap <Right>
    catch /^Vim\((\a\+)\)\=:E31:/
    endtry
    try
        nunmap <Right>
    catch /^Vim\((\a\+)\)\=:E31:/
    endtry
endfunction

" s:getDir(type)    {{{1

""
" @private
" Return directory path |String| to desired directory (without a terminal
" slash), or a boolean false |v:false| if failure. The directory type is one
" of:
" * atp
" * beamer
" * templates
" * texmfhome
function! s:getDir(type)
    " check argument
    let l:valid_types = {
                \ 'atp'       : '',
                \ 'beamer'    : '',
                \ 'templates' : '',
                \ 'texmfhome' : '',
                \ }
    if !has_key(l:valid_types, a:type)
        call dn#util#error("Invalid directory type requested '"
                    \      . a:type . "'")
        return 0
    endif
	" require resources directory
    if !s:resourcesDirIsSet()
        call dn#util#error('Unable to return ' . a:type . ' directory')
        return v:false
    endif
    " return requested directory
    let l:dir = ''
    if     a:type =~# 'atp'
        let l:dir = s:plugin_resources_dir . '/atp'
    elseif a:type =~# 'beamer'
        let l:dir = s:plugin_resources_dir . '/beamer'
    elseif a:type =~# 'templates'
        let l:dir = s:plugin_resources_dir . '/templates'
    elseif a:type =~# 'texmfhome'
        let l:dir = s:getTexmfhomeDir()
    endif
    if l:dir =~# '^$'
        call dn#util#error("Unknown directory type '" . a:type . "'")
        return v:false
    endif
    if isdirectory(l:dir)
        return l:dir
    else
        let l:msg = "Invalid directory '" . l:dir
                    \ . " for directory type '" . a:type . "'"
        call dn#util#error(l:msg)
        return v:false
    endif
endfunction

" s:getDocData(type)    {{{1

""
" @private
" Get user data from user. The document {type} is one of those provided by
" s:doc_types. Returns a complex |List|.
function! s:getDocData(type)
    " sanity checks and variables
    " - need type
    if a:type ==# '' | return [] | endif
    " - need a matching doc type with defined items
    if !exists("s:doc_type_info[a:type]['items']")
        call dn#util#error("No data items defined for doc type '"
                    \      . a:type . "'")
        return []
    endif
    " assemble data items
    let l:items = []
    for l:item in s:doc_type_info[a:type]['items']
        if exists('s:data_item_definitions[l:item]')
            call add(l:items, deepcopy(s:data_item_definitions[l:item]))
        else
            let l:msg = "Doc type '" . a:type . "' user data item '"
            let l:msg .= l:item . "' is not defined"
            call dn#util#warn(l:msg)
        endif
    endfor
    unlet! l:item
    " check validity of assembled doc type data items
    if !s:validVar(l:items, 'dt-items') | return [] | endif
    " user supplies some data
    for l:item in l:items
        let l:default = exists("l:item['default']") ? l:item.default : ''
        echo l:item.explain
        let l:value = input(l:item.prompt, l:default) | echo ' '
        if l:value !=# ''
            let l:item['value'] = l:value
        else
            call dn#util#warn('No value entered for ' . l:item.name)
        endif
        " - remove unneeded keys
        unlet l:item.name l:item.explain l:item.prompt
        if exists('l:item.default') | unlet l:item.default | endif
    endfor
    unlet l:item
    " system supplies some data
    call add(l:items, {'token': '<CREATED-DATE>',
                \        'value': strftime('%Y-%m-%d')})
    call add(l:items, {'token': '<FILENAME>', 'value': expand('%')})
    " return data
    return l:items
endfunction

" s:getDocType()    {{{1

""
" @private
" Get document type. User selects document type but can abort operation.
" Returns selected type |String|, and empty string if user aborts.
function! s:getDocType()
    let l:pick = dn#util#menuSelect(keys(s:doc_types),
                \                   'Select document type:')
    if l:pick ==# '' | return '' | endif
    return s:doc_types[l:pick]
endfunction

" s:getTemplate(type)    {{{1

""
" @private
" Get content of template file for the specified document {type} (as defined
" in s:doc_types). Returns a |List|.
function! s:getTemplate(type)
    " sanity checks
    " - need type
    if a:type ==# '' | return [] | endif
    " - need doc type with defined template
    if !exists("s:doc_type_info[a:type]['template']")
        let l:msg = "No template filename defined for doc type '"
                    \ . a:type . "'"
        call dn#util#error(l:msg)
        return []
    endif
    " variables
    let l:template_content = []
    let l:template_dir = s:getDir('templates')
    if !isdirectory(l:template_dir) | return | endif
    let l:template_file = l:template_dir . '/'
                \ . s:doc_type_info[a:type]['template']
    if !filereadable(l:template_file)
        call dn#util#error("Unable to read template '"
                    \      . l:template_file . "'")
        return []
    endif
    " read in template content
    let l:template_content = readfile(l:template_file)
    " check for success
    if len(l:template_content) == 0
        call dn#util#error('No content read from template '
                    \ . l:template_file . "'")
        return []
    endif
    return l:template_content
endfunction

" s:getTexmfhomeDir()    {{{1

""
" @private
" Return TEXMFHOME directory path |String| (without terminal slash), or
" boolean false |v:false| if failure.
function! s:getTexmfhomeDir()
    " need kpsewhich
    if !executable('kpsewhich')
        call dn#util#error('Need ''kpsewhich'' to locate TEXMFHOME')
        return v:false
    endif
    " locate TEXMFHOME
    " - cannot use shellescape because it results in  shell interpreting
    "   entire string as single word and failing
    let l:cmd = 'kpsewhich --var-value TEXMFHOME'
    let l:dir = split(system(l:cmd), '\n')[0] . '/'
    if v:shell_error
        call dn#util#error('Error occurred while locating TEXMFHOME:')
        call dn#util#error('----------------------------------------')
        call dn#util#error(v:shell_error)
        call dn#util#error('----------------------------------------')
        return v:false
    endif
    if l:dir =~# '^$'
        call dn#util#error('Failed to locate TEXMFHOME')
        return v:false
    endif
    " create directory if it does not exist
    if isdirectory(l:dir)    " success
        return l:dir
    else    " have to create it
        let l:cmd = 'mkdir -p ' . l:dir
        call system(l:cmd)
        if v:shell_error
            call dn#util#error('Error occurred while creating TEXMFHOME:')
            call dn#util#error('----------------------------------------')
            call dn#util#error(v:shell_error)
            call dn#util#error('----------------------------------------')
            return v:false
        endif
        if isdirectory(l:dir)
            return l:dir
        else    " something bad happened
            call dn#util#error('Failed to create TEXMFHOME directory')
            return v:false
        endif
    endif
endfunction

" s:insertData(data, template)    {{{1

""
" @private
" Insert {data} items into {template} content and returns the altered
" {template}. Parameters are not checked for validity and this function
" assumes token key and value are always present, so consider using
" @function(s:validVar) before calling this function.
function! s:insertData(data, template)
    " variables
    let l:new_template = [] | let l:first_iteration = 1
    " replace tokens in template with supplied data
    for l:line in a:template
        for l:item in a:data
            if exists("l:item['value']")
                let l:line = substitute(l:line, l:item['token'],
                            \            l:item['value'], 'g')
            else  " no l:item.value
                if l:first_iteration
                    let l:msg = "Cannot replace token '" . l:item['token']
                    let l:msg .= "' -- no value supplied"
                    call dn#util#warn(l:msg)
                endif
            endif  " exists(l:item['value'])
        endfor  " l:item in a:data
        let l:first_iteration = 0
        call add(l:new_template, l:line)
    endfor  " l:line in a:template
    " return altered template
    return l:new_template
endfunction

" s:resourcesDirIsSet()    {{{1

""
" @private
" Sets script variable for plugin resources directory
" (s:plugin_resources_dir). Returns bool indicating success of operation.
function! s:resourcesDirIsSet()
	" only do this once
    if exists('s:plugin_resources_dir')
        if strlen('s:plugin_resources_dir') > 0
            if isdirectory(s:plugin_resources_dir)
                return v:true
            else    " bad directory (how the hell did that happen?
                let s:plugin_resources_dir = ''
            endif
        endif
    endif
    let l:var = dn#util#getRtpDir('vim-dn-latex-resources')
    if strlen(l:var) > 0
        if isdirectory(l:var)
            let s:plugin_resources_dir = l:var
            return v:true
        else
            let l:msg = 'Could not find valid plugin resources directory'
            call dn#util#error(l:msg)
            call dn#util#error('Plugin resources directory was not set')
            return v:false
        endif
    else    " empty string returned
        call dn#util#error('Could not detect plugin resources directory')
        call dn#util#error('Plugin resources directory was not set')
        return v:false
    endif
endfunction

" s:utilsMissing()    {{{1

""
" @private
" Determines whether dn-utils plugin is loaded.
function! s:utilsMissing() abort
    silent! call dn#util#rev()  " load function if available
    if exists('*dn#util#rev') && dn#util#rev() =~? '\v^\d{8,}$'
        return v:false
    else
        echohl ErrorMsg
        echomsg 'dn-latex ftplugin cannot find the dn-utils plugin'
        echomsg 'dn-latex ftplugin requires the dn-utils plugin'
        echohl NONE
        return v:true
    endif
endfunction

" s:validVar(variable, kind)    {{{1

""
" @private
" Check validity of {variable} derived from script variables. The {kind} of
" variable can be:
" * template
" * dt-items
" * dt-items-trimmed
"
" Displays an error message if {variable} is invalid. Returns a bool
" indicating validity of {variable}.
function! s:validVar(var, kind)
    " check 'template'
    if a:kind ==# 'template'
        " must be a list
        if type(a:var) != type([])
            call dn#util#error('Template variable is not a List')
            return 0
        endif
        " must have content
        if len(a:var) == 0
            call dn#util#error('Template variable is empty')
            return 0
        endif
        return 1  " success if passed all tests
    " check 'dt-items'
    " - this is the list of doc type Dictionary data items
    " - data items require keys:
    "   'name', 'explain', 'prompt', 'token'
    " - data items can have optional keys:
    "   'default', 'value'
    " check 'dt-items-trimmed'
    " - this is the list of doc type Dictionary data items
    "   after removal of key-value pairs not required for
    "   changing template
    " - data items require key: 'token'
    " - data items can have optional key: 'value'
    elseif a:kind ==# 'dt-items' || a:kind ==# 'dt-items-trimmed'
        " set the required and optional keys, and human-readable var name
        if     a:kind ==# 'dt-items'
            let l:required = ['name', 'explain', 'prompt', 'token']
            let l:optional = ['default', 'value']
            let l:name = 'Doc type data items'
        elseif a:kind ==# 'dt-items-trimmed'
            let l:required = ['token']
            let l:optional = ['value']
            let l:name = 'Trimmed doc type data items'
        endif
        let l:allowed = l:required + l:optional
        " must be a list
        if type(a:var) != type([])
            call dn#util#error(l:name . ' is not a List')
            return 0
        endif
        " must have content
        if len(a:var) == 0
            call dn#util#error(l:name . ' is empty')
            return 0
        endif
        " elements must be dictionaries
        let l:item_count = 0
        for l:item in a:var
            if type(l:item) != type({})
                let l:msg = l:name . ' element ' . l:item_count
                let l:msg .= ' is a ' . dn#util#varType(l:item)
                let l:msg .= ", not a Dictionary:\n" . string(l:item)
                call dn#util#error(l:msg)
                return 0
            endif
            unlet l:item
            let l:item_count += 1
        endfor
        " element dictionaries must be well-formed
        let l:item_count = 0
        for l:item in a:var
            " - check that all keys are allowed keys
            for l:key in keys(l:item)
                if count(l:allowed, l:key) == 0
                    let l:msg = l:name . ' element ' . l:item_count
                    let l:msg .= " has invalid key '" . l:key . "':\n"
                    let l:msg .= string(l:item)
                    call dn#util#error(l:msg)
                    return 0
                endif
            endfor
            " - check that all required keys are present
            for l:key in l:required
                if count(keys(l:item), l:key) == 0
                    let l:msg = l:name . ' element ' . l:item_count
                    let l:msg .= " is missing required key '" . l:key . "':\n"
                    let l:msg .= string(l:item)
                    call dn#util#error(l:msg)
                    return 0
                endif
            endfor
            " - check all keys have values with content
            for l:key in keys(l:item)
                if l:item[l:key] ==# ''
                    let l:msg = l:name . ' element ' . l:item_count
                    let l:msg .= " has a key ('" . l:key
                                \ . "') with no value:\n"
                    let l:msg .= string(l:item)
                    call dn#util#error(l:msg)
                    return 0
                endif
            endfor
        endfor  " l:item in a:var
        " check for duplicate elements
        for l:item in deepcopy(a:var)
            let l:count = 0
            for l:comp in a:var
                if l:item == l:comp | let l:count += 1 | endif
            endfor
            if l:count > 1
                let l:msg = l:name . " has multiple copies of this element:\n"
                let l:msg .= string(l:item)
                call dn#util#error(l:msg)
                return 0
            endif
        endfor
        " check for multiple elements with the same 'name' value
        " - obviously can only be done before key-value pairs are trimmed
        if a:kind ==# 'dt-items'
            " - extract a list of element names
            let l:element_names = []
            for l:item in a:var
                call add(l:element_names, l:item.name)
            endfor
            " - now check for duplicates
            for l:element_name in l:element_names
                if count(l:element_names, l:element_name) > 1
                    let l:msg = l:name . ' has multiple elements with '
                    let l:msg .= "identical name '" . l:element_name . "':"
                    for l:item in a:var
                        if l:item.name == l:element_name
                            let l:msg .= "\n" . string(l:item)
                        endif
                    endfor
                    call dn#util#error(l:msg)
                    return 0
                endif
            endfor
        endif
        " check for multiple elements with the same 'token' value
        " - tokens must be unique
        let l:tokens = []
        for l:item in a:var | call add(l:tokens, l:item.token) | endfor
        for l:token in l:tokens
            if count(l:tokens, l:token) > 1
                let l:msg = l:name . ' has multiple elements with '
                let l:msg .= "identical token '" . l:token . "':"
                    for l:item in a:var
                        if l:item.token == l:token
                            let l:msg .= "\n" . string(l:item)
                        endif
                    endfor
                call dn#util#error(l:msg)
                return 0
            endif
        endfor
        return 1  " success if passed all tests
    else  " invalid a:kind
        call dn#util#warn("Invalid kind parameter '" . a:kind . "'")
        return 0
    endif
endfunction
" }}}1

" Private functions

" Public functions

" dn#latex#alignTable([insert])    {{{1

""
" @public
" Arrange columns in table source. Assumes table source has a structure like:
" >
"   \begin{tabular}{xxx}
"   \toprule
"   Header 1 & Header 2 & Header 3 \\
"   \midrule
"   Content 1 & Content 2 & Content 3 \\
"   ...
"   \bottomrule
"   \end{tabular}
" <
" The begin and end tabular environment commands are used to find the start
" and end of the table. The function uses column separators ("&") to locate
" columns. It ignores escaped ampersands but unescaped ampersands in comments
" will cause unpredictable behaviour. The function must be called from within
" the table.
function! dn#latex#alignTable(...)
	echo ''   | " clear command line
    if s:utilsMissing() | return | endif  " requires dn-utils plugin
    " variables
    let l:insert = (a:0 > 0 && a:1) ? v:true : v:false
    let l:start = 0 | let l:end = 0    " table beginning and end
    let l:start_token = '\\begin{tabular}'
    let l:end_token = '\\end{tabular}'
    let l:col_sep = ' &'    " column separator token
    let l:replace_cs = ' \&'    " if no backslash '&' becomes concat token
    let l:left_padded_cs = '\s\{2,}&'    " left-padded column separator token
    let l:right_padded_cs = ' &\s\{2,}'    " right-padded column sep token
    let l:sep_count = 0     " number of column separators in table
    let l:data = {}    " holds table rows
    " remember where we started
    let l:save_cursor = getpos('.')
    " analyse table to get start and end lines
    let l:start = searchpair(l:start_token, '', l:end_token, 'bW')
    if l:start < 1    " not inside table or error occurred
        call dn#util#error('Cursor must be inside a table')
        return
    endif
    let l:start += 1
    let l:end = searchpair(l:start_token, '', l:end_token, 'W')
    if l:end < 1
        call dn#util#error('Unable to find end of table')
        return
    endif
    let l:end -= 1
    " build Dict of lines containing table data
    " - format is line_num => line_content
    let l:line_num = l:start
    while l:line_num <= l:end
        let l:line = getline(l:line_num)
        let l:match = strridx(l:line, l:col_sep)
        if l:match > -1 | let l:data[l:line_num] = l:line | endif
        let l:line_num += 1
    endwhile
    " delete excess space around colseps
    for l:line_num in keys(l:data)
        while match(l:data[l:line_num], l:left_padded_cs) > -1
            let l:data[l:line_num] = substitute(
                        \ l:data[l:line_num], l:left_padded_cs,
                        \ l:replace_cs, ''
                        \ )
        endwhile
        while match(l:data[l:line_num], l:right_padded_cs) > -1
            let l:data[l:line_num] = substitute(
                        \ l:data[l:line_num], l:right_padded_cs,
                        \ l:replace_cs . ' ', ''
                        \ )
        endwhile
        unlet l:line_num
    endfor
    " get max number of colseps per line
    for l:line_num in keys(l:data)
        let l:matches = dn#util#matchCount(l:data[l:line_num], l:col_sep)
        if l:matches > l:sep_count | let l:sep_count = l:matches | endif
    endfor
    echo l:sep_count
    " loop through each column separator
    let l:loop = 1
    while l:loop <= l:sep_count
        " find right-most position of this column separator
        let l:max_pos = 0
        for l:line_num in keys(l:data)
            let l:pos = match(l:data[l:line_num], l:col_sep, 0, l:loop)
            if l:pos > l:max_pos | let l:max_pos = l:pos | endif
        endfor
        " in each line pad this column separator to right-most position
        for l:line_num in keys(l:data)
            let l:pos = match(l:data[l:line_num], l:col_sep, 0, l:loop)
            if l:pos > -1    " if line wrapped may not have col-sep match
                let l:data[l:line_num] = dn#util#padInternal(
                            \ l:data[l:line_num], l:pos, l:max_pos
                            \ )
            endif
        endfor
        " prepare for next column separator
        let l:loop += 1
    endwhile
    " write back altered lines
    for l:line_num in keys(l:data)
        call setline(str2nr(l:line_num), l:data[l:line_num])
    endfor
    " return to where we started
    call setpos('.', l:save_cursor)
    " return to calling mode
    if l:insert | call dn#util#insertMode() | endif
endfunction

" dn#latex#insertSpecialChar([insert])    {{{1

""
" @public
" Insert a special character in the text. The optional [insert] argument
" indicates whether the function was called from |Insert-mode|.
" @default insert=false
"
" Requires a vim environment in which unicode characters can be displayed.
" There is no meaningful return value.
function! dn#latex#insertSpecialChar(...)
	echo ''   | " clear command line
    if s:utilsMissing() | return | endif  " requires dn-utils plugin
    " variables
    let l:insert = (a:0 && a:1)
    " select special character
    let l:char = dn#util#menuSelect(s:chars, 'Select character to insert:')
    " insert character
    if l:char !=? '' | call dn#util#insertString(l:char) | endif
    if l:insert | call dn#util#insertMode() | endif
endfunction

" dn#latex#insertTemplate()    {{{1

""
" @public
" Insert template into text and ready it for use.
function! dn#latex#insertTemplate()
    if s:utilsMissing() | return | endif  " requires dn-utils plugin
    " get document type
    let l:doc_type = s:getDocType()
    " get template for that doc type
    let l:template = s:getTemplate(l:doc_type)
    if len(l:template) == 0 | return | endif
    " get data to be inserted into template
    let l:data_items = s:getDocData(l:doc_type)
    if !s:validVar(l:data_items, 'dt-items-trimmed') | return | endif
    " replace tokens in template with supplied data
    let l:new_template = s:insertData(l:data_items, l:template)
    if !s:validVar(l:new_template, 'template') | return | endif
    " insert altered template into buffer
    call append(0, l:new_template)
    " move cursor to start token (and delete start token)
    if search('<START>')
        execute 'normal df>'
    else
        call dn#util#warn("No start token '<START>' found")
    endif
    " save file
    execute ':write!'
endfunction

" dn#latex#syncBeamer()    {{{1

""
" @public
" Installs beamer files in local texmf tree. Requires executables "kpsewhich"
" and "rsync". Returns bool indicating success of operation.
function! dn#latex#syncBeamer()
    if s:utilsMissing() | return | endif  " requires dn-utils plugin
    " only implemented for unix
    if !has('unix')
        call dn#util#error('Beamer installation not yet '
                    \      . 'implemented on this OS')
        return v:false
    endif
    " need rsync
    if !executable('rsync')
        call dn#util#error("Need 'rsync' to synchronise beamer files")
        return v:false
    endif
    " set source directory
    let l:source = s:getDir('beamer')
    if !isdirectory(l:source) | return v:false | endif
    " set target directory
    let l:target = s:getDir('texmfhome')
    if !isdirectory(l:target) | return v:false | endif
    " time to sync
    " - capture change summary with '-i'
    " - add terminal slashes as they are supposed to be important for rsync
    let l:cmd = 'rsync -i -a --delete' . ' '
                \ . shellescape(l:source . '/') . ' '
                \ . shellescape(l:target . '/') . ' '
                \ . '| grep -v "^\."'
    let l:changes = system(l:cmd)
    if v:shell_error
        call dn#util#error('Error occurred while syncing beamer files:')
        call dn#util#error('------------------------------------------')
        call dn#util#error(v:shell_error)
        call dn#util#error('------------------------------------------')
        return v:false
    endif
    if !isdirectory(l:target)
        call dn#util#error('Failed to create TEXMFHOME directory')
        return v:false
    endif
    " update local tex ls-R database if changes made to beamer files
    if strlen(l:changes) > 0
        let l:cmd = 'mktexlsr ' . strpart(l:target, 0, strlen(l:target)-1)
        call system(l:cmd)
        if v:shell_error
            call dn#util#error('Error occurred while updating '
                        \      . 'local tex ls-R db:')
            call dn#util#error('--------------------------'
                        \      . '----------------------')
            call dn#util#error(v:shell_error)
            call dn#util#error('--------------------------'
                        \      . '----------------------')
            return v:false
        endif
    endif
    " guess we made it!
    echo 'Beamer files synchronised'
    return v:true
endfunction

" }}}1

" vim: set foldmethod=marker :
