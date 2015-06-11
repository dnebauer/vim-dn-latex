" Vim ftplugin for latex (provided by the vim-dn-latex package)
" Maintainer: David Nebauer <david@nebauer.org>
" License:    This file is placed in the public domain

" TODO: replace template dir "@pkgdatatemplates_dir@/" with
"       bundle directory

" CONTROL STATEMENTS:                                            {{{1
" load plugin once only                                          {{{2
if exists('b:do_not_load_vim_dn_latex') | finish | endif
let b:do_not_load_vim_dn_latex = 1                             " }}}2
" relies upon dn-utils                                           {{{2
if !exists('b:do_not_load_dn_utils')
	if mode() == 'i' | execute "normal \<Esc>" | endif
	echohl ErrorMsg
	echo 'Cannot load dn-latex plugin'
	echo 'because dn-utils plugin is missing'
	echohl nil 
    finish
endif                                                          " }}}2
" prevent errors from line continuation                          {{{2
let s:save_cpo = &cpo
set cpo&vim                                                    " }}}2

" VARIABLES:                                                     {{{1
" relies upon dn-utils booleans                                  {{{2
" uses variables 'b:dn_true' and 'b:dn_false'                    }}}2
" contribute to dn-utils help                                    {{{2
" - add to plugins list (b:dn_help_plugins)                      {{{3
if !exists('b:dn_help_plugins')
    let b:dn_help_plugins = {}
endif
if index(b:dn_help_plugins, 'tex', b:dn_true) == -1
    call add(b:dn_help_plugins, 'tex')
endif                                                          " }}}3
" - add help topics (b:dn_help_topics)                           {{{3
if !exists('b:dn_help_topics')
    let b:dn_help_topics = {}
endif
let b:dn_help_topics['tex'] = { 
            \ 'spacing'          : 'tex_spacing', 
            \ 'compiler commands': 'tex_compiler_commands', 
            \ 'viewing pdf'      : 'tex_view_pdf',
            \ 'snippets'         : 'tex_snippets',
            \ }                                                " }}}3
" - add help data for help topics (b:dn_help_data)               {{{3
if !exists('b:dn_help_data')
    let b:dn_help_data = {}
endif
let b:dn_help_data['tex_spacing'] = [ 
            \ 'Spacing:', 
            \ '', 
            \ ' ', '', 
            \ 'English (American) spacing: uses double-spacing ',
            \ 'between sentences. It is considered somewhat ',
            \ 'outdated but remains the TeX default. The different ', 
            \ 'interword and inter-sentence space widths results ',
            \ 'in problems determining whether periods end ',
            \ 'sentences or abbreviations. Ambiguity can be ',
            \ 'removed by using the ''\@'' token: ''\@.'' ends a ',
            \ 'sentence while ''.\@'' is within the sentence. ',
            \ 'Example: ''Mr.\@ Rogers watched Richard III\@.'' An ',
            \ 'interword space after a period can be forced with an ',
            \ 'escaped space (''\ ''). Example: ''Mr.\ Rogers ',
            \ 'watched Richard III\@.'' A tie, or non-breaking ',
            \ 'space is used to ensure words stay together on the ',
            \ 'same line. A tie following a period has the side ',
            \ 'effect of forcing an interword space, hence: ',
            \ '''Mr.~Rogers watched Richard III\@.''',
            \ '', 
            \ ' ', '', 
            \ 'French spacing: uses single-spacing between ',
            \ 'sentences. This is modern usage and is the default ',
            \ 'for documents created ',
            \ 'by dn-latex -- the preamble contains a ',
            \ '\frenchspacing command and there is no need to use ',
            \ '''\ '', ''~'' or ''\@.'' tokens for spacing.',
            \ '', 
            \ ' ', '', 
            \ 'Thin spaces: some text elements should not be ',
            \ 'adjacent but neither should they have a full ',
            \ 'interword space. In such cases use a thin space ',
            \ '''\,''. Example: ''Mr D.\,E.~Knuth uses 40\,TB ',
            \ 'drives''. Other sized spaces are ''\:'' (medium), ',
            \ '''\;'' (large), ''\quad'' (v. large), ''\qquad'' ',
            \ '(huge), and ''\!'' (negative space).',
            \ '',
            \ ' ', '',
            \ 'Italics: there can be problematic spacing when ', 
            \ 'italicised text ends and normal text resumes. The ',
            \ '''textit'' environment performs an automatic italic ',
            \ 'correction to adjust the spacing.',
            \ ]
let b:dn_help_data['tex_compiler_commands'] = [ 
            \ 'Compiler commands:', 
            \ '', 
            \ ' ', '', 
            \ '\l -- invokes tex compiler once (appears to be same as',
            \ '',
            \ '      automatic background compiler command.', 
            \ '',
            \ ' ', '', 
            \ ':MakeLatex -- makes whole document with cross-refs, etc.', 
            \ '',
            \ ' ', '', 
            \ 'NOTE: bibtex-related commands only work reliably with an',
            \ '', 
            \ '      absolute filepath for the bib database.', 
            \ '', 
            \ ' ', '', 
            \ '\b -- invokes bibtex compiler (and tex compiler if need to',
            \ '', 
            \ '      first generate aux file)',
            \ '', 
            \ '   -- equivalent to '':Bibtex!'' command',
            \ ]
let b:dn_help_data['tex_view_pdf'] = [ 
            \ 'Viewing pdf output:', 
            \ '', 
            \ ' ', '', 
            \ '\v -- invokes pdf viewer', 
            \ '', 
            \ '   -- equivalent to ''F3'' mapping', 
            \ '', 
            \ '   -- equivalent to '':View'' command', 
            \ '', 
            \ ' ', '', 
            \ '\f -- forward search (synchronise vim and pdf viewer)', 
            \ '', 
            \ '   -- equivalent to '':SyncTex'' command', 
            \ ]
let b:dn_help_data['tex_snippets'] = [ 
            \ 'Defined UltiSnips snippets:', 
            \ '', 
            \ ' ', '', 
            \ 'begin:     generic environment wrapper',
            \ '',
            \ 'tab:       table environment',
            \ '',
            \ 'fig:       figure environment',
            \ '',
            \ 'subfig:    figure with two subfigures',
            \ '',
            \ 'sfigadd:   additional subfigure',
            \ '',
            \ 'eqn:       equation',
            \ '',
            \ 'eqa:       equation array',
            \ '',
            \ 'eqd:       math environment ("$ ${1} $")',
            \ '',
            \ 'enum:      enumerate environment',
            \ '',
            \ 'itemize:   itemize environment',
            \ '',
            \ 'quote:     quote environment',
            \ '',
            \ 'desc:      description environment',
            \ '',
            \ 'chap:      chapter environment',
            \ '',
            \ 'sec:       section environment',
            \ '',
            \ 'sub:       subsection environment',
            \ '',
            \ 'subs:      subsubsection environment',
            \ '',
            \ 'par:       paragraph environment',
            \ '',
            \ 'subp:      subparagraph environment',
            \ '',
            \ 'itd:       item with description',
            \ '',
            \ 'refchar:   chaper reference',
            \ '',
            \ 'reffig:    figure reference',
            \ '',
            \ 'reftab:    table reference',
            \ '',
            \ 'refsec:    section reference',
            \ '',
            \ 'refpag:    page reference',
            \ '',
            \ 'citen:     name citation',
            \ '',
            \ 'cite:      citation',
            \ '',
            \ 'verbatim:  verbatim environment',
            \ '',
            \ 'verb:      verb',
            \ '',
            \ 'lrp:       left and right parentheses',
            \ '',
            \ 'lrb:       left and right braces',
            \ '',
            \ 'lra:       left and right angle brackets',
            \ '',
            \ 'frame:     empty beamer frame',
            \ '',
            \ 'frlist:    beamer frame with itemised list',
            \ '',
            \ 'frfig:     beamer frame with figure',
            \ '',
            \ 'frsubfig:  beamer frame with multiple subfigures',
            \ '',
            \ 'frfullfig: beamer frame with full size image',
            \ '',
            \ 'beamerbox: framed/boxed text',
            \ ]                                                " }}}3
" used for new document creation                               " {{{2
" - document types (s:doc_types)                                 {{{3
"   . Dictionary(
"       key   : user-readable description,
"       value : token,
"     )
"   . used in function 's:getDocType'
let s:doc_types = {
            \ 'Standard LaTeX 2e article class': 'article',
            \ 'Standard LaTeX 2e report class' : 'report', 
            \ 'Standard LaTeX 2e book class'   : 'book',
            \ 'Beamer class for presentations' : 'beamer',
            \ }                                                " }}}3
" - information about doc types (s:doc_type_info)                {{{3
"   . info includes template file name and data items to be 
"     supplied by the user
"   . Dictionary(
"       key   : doc type,
"       value : Dictionary(
"         'template' : template file name,
"         'items'    : List[items],
"       ),
"     )
"   . used in functions 's:getDocData' and 's:getTemplate'
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
            \ }                                                " }}}3
" - attributes for data items (s:data_item_definitions)          {{{3
"   . Dictionary(
"       key   : user data item token from s:user_data,
"       value : Dictionary(
"         'name'    : data item name,
"         'explain' : explanation for user,
"         'prompt'  : console interface prompt to enter data,
"         'default' : default value,
"         'token'   : token in template text to be replaced,
"       ),
"     )
"   . used in function 's:getDocData'
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
            \       'explain': 'The document description should be no more than 60 characters',
            \       'prompt' : 'Enter a brief description: ',
            \       'token'  : '<DESCRIPTION>',
            \   },
            \ 'institute': {
            \       'name'   : 'institute',
            \       'explain': 'The document is produced under the auspices of an institute or body',
            \       'prompt' : 'Enter institute: ',
            \       'default': 'NT Government Department of Health',
            \       'token'  : '<INSTITUTE>',
            \   },
            \ 'title': {
            \       'name'   : 'title',
            \       'explain': 'The document title appears at the head of the document',
            \       'prompt' : 'Enter document title: ',
            \       'token'  : '<TITLE>',
            \   },
            \ }                                                " }}}3
" special characters to be inserted into text                  " {{{2
" - special characters                                           {{{3
let s:chars = {}
let s:chars['section (§)']       = '\S{}'
let s:chars['dagger (†)']        = '\dag{}'
let s:chars['double dagger (‡)'] = '\ddag{}'
let s:chars['copyright (©)']     = '\copyright{}'
let s:chars['trademark (™)']     = '\texttrademark{}'
let s:chars['registered (®)']    = '\textregistered{}'
let s:chars['ellipsis (…)']      = '\dots{}'
let s:chars['checkmark (✓)']     = '\checkmark{}'
let s:chars['ballot x (✗)']      = '\XSolidBrush{}'            " }}}3
" - reserved                                                     {{{3
let s:chars['latex reserved']  = {
            \ 'backslash (\)'   : '\textbackslash{}', 
            \ 'underscore (_)'  : '\_', 
            \ 'percent (%)'     : '\%', 
            \ 'open brace ({)'  : '\{', 
            \ 'close brace (})' : '\}', 
            \ 'ampersand (&)'   : '\&', 
            \ 'hash (#)'        : '\#' 
            \ }                                                " }}}3
" - math/scientific                                              {{{3
let s:chars['math/scientific'] = { 
            \ 'math asterisk (∗)'   : '\textasteriskcentered{}', 
            \ 'math multiply (×)'   : '$\times$', 
            \ 'micro (µ)'           : '\micro{}', 
            \ 'degrees (°)'         : '\degree{}', 
            \ 'degrees celsius (℃)' : '\textcelsius' 
            \ }                                                " }}}3
" - currency                                                     {{{3
let s:chars['currency']        = { 
            \ 'dollar ($)' : '\$', 
            \ 'pound (£)'  : '\pounds{}', 
            \ 'euro (€)'   : '\texteuro{}', 
            \ 'cent (¢)'   : '\textcent{}' 
            \ }                                                " }}}3
" - arrows                                                       {{{3
let s:chars['arrows']          = { 
            \ 'left (←)'       : '$\leftarrow$', 
            \ 'long left (⟵)'  : '$\longleftarrow$', 
            \ 'right (→)'      : '$\rightarrow$', 
            \ 'long right (⟶)' : '$\longrightarrow$' 
            \ }                                                " }}}3
" - greek upper                                                  {{{3
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
            \ }                                                " }}}3
" - greek lower                                                  {{{3
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
            \ }                                                " }}}3
                                                               " }}}2
" plugin resources directory                                   " {{{2
let s:plugin_resources_dir = ''                                " }}}2
                                                               " }}}2

" SETTINGS:                                                      {{{1
" override existing tab settings                                 {{{2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab                                                  " }}}2
                                                                 
" FUNCTIONS:                                                     {{{1
" Function: DNL_Initialise                                       {{{2
" Purpose:  insert special character
" Params:   1 - whether to insert template <default=false> <optional> [boolean]
" Insert:   nil
" Return:   nil
function! DNL_Initialise(...)
    " process arguments
    let l:insert_template = b:dn_false
    if a:0 > 0 && type(a:1) == type({}) && has_key(a:1, 'insert_template') 
                \ && a:1['insert_template']
        let l:insert_template = b:dn_true
    endif
    " deactivate <Right> key mapping as it interferes with Ctrl-J mapping
    call s:deactivateRightMapping()
    " avoid atp-vim collisions with CommandT
    nnoremap <buffer> <silent> <Leader>T :CommandT<CR>|
    nnoremap <buffer> <silent> <Leader>U :CommandTBuffer<CR>|
    " make sure beamer files are installed
    call s:syncBeamer()
    " insert template and user-supplied data
    if l:insert_template
        call s:insertTemplate()
    endif
endfunction                                                    " }}}2
" Function: DNL_InsertSpecialChar                                {{{2
" Purpose:  insert special character
" Params:   1 - insert mode [default=<false>, optional, boolean]
" Insert:   special character
" Return:   nil
" Note:     uses Dict variable with direct unicode characters
"           and so requires vim environment in which these can
"           be displayed
function! DNL_InsertSpecialChar(...)
	echo ''   | " clear command line
    " variables
    let l:insert = (a:0 > 0 && a:1) ? b:dn_true : b:dn_false
    " select special character
    let l:char = DNU_MenuSelect(s:chars, 'Select character to insert:')
    " insert character
    if l:char != '' | call DNU_InsertString(l:char) | endif
    if l:insert | call DNU_InsertMode() | endif
endfunction
" Function: DNL_AlignTable                                       {{{2
" Purpose:  arrange columns in table source
" Params:   1 - insert mode [default=<false>, optional, boolean]
" Insert:   spaces as required
" Return:   nil
" Note:     assumes table source has structure:
"             \begin{tabular}{xxx}
"             \toprule
"             Header 1 & Header 2 & Header 3 \\
"             \midrule
"             Content 1 & Content 2 & Content 3 \\
"             ...
"             \bottomrule
"             \end{tabular}
" Note:     the function must be called from within a table
" Note:     the begin and end tabular environment commands are used
"           to find the start and end of the table
" Note:     the function uses column separators ('&') to locate
"           columns; it ignores escaped ampersands but unescaped
"           ampersands in comments will cause unpredictable behaviour
function! DNL_AlignTable(...)
	echo ''   | " clear command line
    " variables
    let l:insert = (a:0 > 0 && a:1) ? b:dn_true : b:dn_false
    let l:start = 0 | let l:end = 0    " table beginning and end
    let l:start_token = '\\begin{tabular}' | let l:end_token = '\\end{tabular}'
    let l:col_sep = ' &'    " column separator token
    let l:replace_cs = ' \&'    " if no backslash '&' becomes concat token
    let l:left_padded_cs = '\s\{2,}&'    " left-padded column separator token
    let l:right_padded_cs = ' &\s\{2,}'    " right-padded column separator token
    let l:sep_count = 0     " number of column separators in table
    let l:data = {}    " holds table rows
    " remember where we started
    let l:save_cursor = getpos('.')
    " analyse table to get start and end lines
    let l:start = searchpair(l:start_token, '', l:end_token, 'bW')
    if l:start < 1    " not inside table or error occurred
        call DNU_Error('Cursor must be inside a table')
        return
    endif
    let l:start += 1
    let l:end = searchpair(l:start_token, '', l:end_token, 'W')
    if l:end < 1
        call DNU_Error('Unable to find end of table')
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
                        \ l:data[l:line_num], l:left_padded_cs, l:replace_cs, ''
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
        let l:matches = DNU_MatchCount(l:data[l:line_num], l:col_sep)
        if l:matches > l:sep_count | let l:sep_count = l:matches | endif
    endfor
    echo l:sep_count
    " loop through each column separator
    let l:loop = 1
    while l:loop <= l:sep_count
        " find right-most position of this column separator
        let l:max_pos = 0
        for l:line_num in keys(l:data)
            let l:pos = DNU_StridxNum(
                        \ l:data[l:line_num], l:col_sep, l:loop
                        \ )
            if l:pos > l:max_pos | let l:max_pos = l:pos | endif
        endfor
        " in each line pad this column separator to right-most position
        for l:line_num in keys(l:data)
            let l:pos = DNU_StridxNum(
                        \ l:data[l:line_num], l:col_sep, l:loop
                        \ )
            if l:pos > -1    " if line wrapped may not have col-sep match
                let l:data[l:line_num] = DNU_PadInternal(
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
    if l:insert | call DNU_InsertMode() | endif
endfunction                                                    " }}}2
" Function: s:resourcesDirIsSet                                  {{{2
" Purpose:  set script variable for plugin resources dir
" Params:   nil
" Insert:   nil
" Return:   whether variable set (boolean)
" Note:     sets script variable s:plugin_resources_dir
function! s:resourcesDirIsSet()
	" only do this once
    if exists('s:plugin_resources_dir')
        if strlen('s:plugin_resources_dir') > 0
            if isdirectory(s:plugin_resources_dir)
                return b:dn_true
            else    " bad directory (how the hell did that happen?
                let s:plugin_resources_dir = ''
            endif
        endif
    endif
    let l:var = DNU_GetRtpDir('vim-dn-latex-resources')
    if strlen(l:var) > 0
        if isdirectory(l:var)
            let s:plugin_resources_dir = l:var
            return b:dn_true
        else
            let l:msg = 'Could not find valid plugin resources directory'
            call DNU_Error(l:msg)
            call DNU_Error('Plugin resources directory was not set')
            return b:dn_false
        endif
    else    " empty string returned
        call DNU_Error('Could not detect plugin resources directory')
        call DNU_Error('Plugin resources directory was not set')
        return b:dn_false
    endif
endfunction                                                    " }}}2
" Function: s:getDir                                             {{{2
" Purpose:  Return directory path to desired directory
" Params:   directory type <required> <value='atp','beamer','templates'>
"                          [string]
" Insert:   nil
" Return:   directory path (string), boolean fail ('0') if fails
" Note:     directory path is returned without terminal slash
function! s:getDir(type)
    " check argument
    let l:valid_types = {
                \ 'atp'       : '',
                \ 'beamer'    : '',
                \ 'template'  : '',
                \ 'texmfhome' : '',
                \ }
    if !has_key(l:valid_types, a:type)
        call DNU_Error("Invalid directory type requested '" . a:type . "'")
        return 0
    endif
	" require resources directory
    if !s:resourcesDirIsSet()
        call DNU_Error('Unable to return ' . a:type . ' directory')
        return 0
    endif
    " return requested directory
    let l:dir = ''
    if     a:type =~ 'atp'
        let l:dir = s:plugin_resources_dir . '/atp'
    elseif a:type =~ 'beamer'
        let l:dir = s:plugin_resources_dir . '/beamer'
    elseif a:type =~ 'template'
        let l:dir = s:plugin_resources_dir . '/templates'
    elseif a:type =~ 'texmfhome'
        let l:dir = s:getTexmfhomeDir()
    endif
    if l:dir =~ '^$'
        call DNU_Error("Unknown directory type '" . a:type . "'")
        return 0
    endif
    if isdirectory(l:dir)
        return l:dir
    else
        let l:msg = "Invalid directory '" . l:dir
                    \ . " for directory type '" . a:type . "'")
        call DNU_Error(l:msg)
    endif
endfunction                                                    " }}}2
" Function: s:getTexmfhomeDir                                    {{{2
" Purpose:  Return TEXMFHOME directory path
" Params:   nil
" Insert:   nil
" Return:   directory path (string), boolean fail ('0') if fails
" Note:     directory is created if it does not exist
"           directory path is returned without terminal slash
function! s:getTexmfhomeDir()
    " need kpsewhich
    if !executable('kpsewhich')
        call DNU_Error('Need ''kpsewhich'' to locate TEXMFHOME')
        return b:dn_false
    endif
    " locate TEXMFHOME
    " - cannot use shellescape because it results in  shell interpreting
    "   entire string as single word and failing
    let l:cmd = 'kpsewhich --var-value TEXMFHOME'
    let l:dir = split(system(l:cmd), '\n')[0] . '/'
    if v:shell_error
        call DNU_Error('Error occurred while locating TEXMFHOME:')
        call DNU_Error('----------------------------------------')
        call DNU_Error(v:shell_error)
        call DNU_Error('----------------------------------------')
        return b:dn_false
    endif
    if l:dir =~ '^$'
        call DNU_Error('Failed to locate TEXMFHOME')
        return b:dn_false
    endif
    " create directory if it does not exist
    if isdirectory(l:dir)    " success
        return l:dir
    else    " have to create it
        let l:cmd = 'mkdir -p ' . l:dir
        call system(l:cmd)
        if v:shell_error
            call DNU_Error('Error occurred while creating TEXMFHOME:')
            call DNU_Error('----------------------------------------')
            call DNU_Error(v:shell_error)
            call DNU_Error('----------------------------------------')
            return b:dn_false
        endif
        if isdirectory(l:dir)
            return l:dir
        else    " something bad happened
            call DNU_Error('Failed to create TEXMFHOME directory')
            return b:dn_false
        endif
    endif
endfunction                                                    " }}}2
" Function: s:syncBeamer                                         {{{2
" Purpose:  install beamer files in local texmf tree
" Params:   nil
" Insert:   nil
" Return:   whether synchronised beamer files
" Note:     unix-only
" Note:     requires executables 'kpsewhich' and 'rsync'
function! s:syncBeamer()
    " only implemented for unix
    if !has('unix')
        call DNU_Error('Beamer installation not yet implemented on this OS')
        return b:dn_false
    endif
    " need rsync
    if !executable('rsync')
        call DNU_Error('Need ''rsync'' to synchronise beamer files')
        return b:dn_false
    endif
    " set source directory
    let l:source = s:getDir('beamer')
    if !isdirectory(l:source) | return b:dn_false | endif
    " set target directory
    let l:target = s:getDir('texmfhome')
    if !isdirectory(l:target) | return b:dn_false | endif
    " time to sync
    " - capture change summary with '-i'
    " - add terminal slashes as they are supposed to be important for rsync
    let l:cmd = 'rsync -i -a --delete' . ' '
                \ . shellescape(l:source . '/') . ' '
                \ . shellescape(l:target . '/')
    let l:changes = system(l:cmd)
    if v:shell_error
        call DNU_Error('Error occurred while syncing beamer files:')
        call DNU_Error('------------------------------------------')
        call DNU_Error(v:shell_error)
        call DNU_Error('------------------------------------------')
        return b:dn_false
    endif
    if !isdirectory(l:target)
        call DNU_Error('Failed to create TEXMFHOME directory')
        return b:dn_false
    endif
    " update local tex ls-R database if changes made to beamer files
    if strlen(l:changes) > 0
        let l:cmd = 'mktexlsr ' . strpart(l:target, 0, strlen(l:target)-1)
        call system(l:cmd)
        if v:shell_error
            call DNU_Error('Error occurred while updating local tex ls-R db:')
            call DNU_Error('------------------------------------------------')
            call DNU_Error(v:shell_error)
            call DNU_Error('------------------------------------------------')
            return b:dn_false
        endif
    endif
    " guess we made it!
    return b:dn_true
endfunction                                                    " }}}2
" Function: s:insertTemplate                                     {{{2
" Purpose:  insert template and ready it for use
" Params:   nil
" Insert:   template
" Return:   nil
" Note:     together with subsidiary functions uses script variables
"           's:doc_types', 's:doc_type_info', 's:data_item_definitions'
" Note:     directly uses functions 's:getDocType', 's:getDocData',
"           's:getTemplate', 's:insertData', 's:validVar'
function! s:insertTemplate()
    " get document type
    let l:doc_type = s:getDocType()
    " get template for that doc type
    let l:template = s:getTemplate(l:doc_type)
    if !l:template_dir | return | endif
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
        execute "normal df>"
    else
        call DNU_Warn("No start token '<START>' found")
    endif
    " save file
    execute ':write!'
endfunction                                                    " }}}2
" Function: s:getDocType                                         {{{2
" Purpose:  get document type
" Params:   nil
" Insert:   nil
" Return:   selected type, empty string if user aborts
" Note:     uses script variable 's:doc_types'
" Note:     used by function 's:insertTemplate'
function! s:getDocType()
    let l:pick = DNU_MenuSelect(keys(s:doc_types), 'Select document type:')
    if l:pick == '' | return '' | endif
    return s:doc_types[l:pick]
endfunction                                                    " }}}2
" Function: s:getDocData                                         {{{2
" Purpose:  get user data
" Params:   1 - doc type as supplied by s:doc_types
" Insert:   template
" Return:   List of Dictionary items as per values from
"           s:data_item_definitions, but containing only
"           'token' and, where supplied, 'value' keys
" Note:     uses script variables 's:doc_type_info', 's:data_item_definitions'
" Note:     used by function 's:insertTemplate'
function! s:getDocData(type)
    " sanity checks and variables
    " - need type
    if a:type == '' | return [] | endif
    " - need a matching doc type with defined items
    if !exists("s:doc_type_info[a:type]['items']")
        call DNU_Error("No data items defined for doc type '" . a:type . "'")
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
            call DNU_Warn(l:msg)
        endif
    endfor
    unlet! l:item
    " check validity of assembled doc type data items
    if !s:validVar(l:items, 'dt-items') | return [] | endif
    " user supplies some data
    for l:item in l:items
        let l:default = exists("l:item['default']") ? l:item.default : ''
        echo l:item.explain
        let l:value = input(l:item.prompt, l:default) | echo " "
        if l:value != ''
            let l:item['value'] = l:value
        else
            call DNU_Warn('No value entered for ' . l:item.name)
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
endfunction                                                    " }}}2
" Function: s:getTemplate                                        {{{2
" Purpose:  get template content and return as List
" Params:   1 - doc type as returned by s:getDocType()
" Insert:   template
" Return:   List
" Note:     uses script variable 's:doc_type_info'
" Note:     used by function 's:insertTemplate'
function! s:getTemplate(type)
    " sanity checks
    " - need type
    if a:type == '' | return [] | endif
    " - need doc type with defined template
    if !exists("s:doc_type_info[a:type]['template']")
        let l:msg = "No template filename defined for doc type '"
                    \ . a:type . "'"
        call DNU_Error(l:msg)
        return []
    endif
    " variables
    let l:template_content = []
    let l:template_dir = s:getDir('templates')
    if !isdirectory(l:template_dir) | return
    let l:template_file = l:template_dir 
                \ . s:doc_type_info[a:type]['template']
    if !filereadable(l:template_file)
        call DNU_Error("Unable to read template '" . l:template_file . "'")
        return []
    endif
    " read in template content
    let l:template_content = readfile(l:template_file)
    " check for success
    if len(l:template_content) == 0
        call DNU_Error('No content read from template ' 
                    \ . l:template_file . "'")
        return []
    endif
    return l:template_content
endfunction                                                    " }}}2
" Function: s:insertData                                         {{{2
" Purpose:  insert data items into template
" Params:   1 - data [List of Dictionary items]
"               Dictionary(
"                 key   = token,
"                 value = replacement text,
"               )
"           2 - template [List]
" Insert:   data items into template
" Return:   altered template [List]
" Note:     parameters are not checked for validity and
"           function assumes token key and value are always present
"           - so consider using 's:validVar' before calling this function
" Note:     used by function 's:insertTemplate'

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
                    call DNU_Warn(l:msg)
                endif
            endif  " exists(l:item['value'])
        endfor  " l:item in a:data
        let l:first_iteration = 0
        call add(l:new_template, l:line)
    endfor  " l:line in a:template
    " return altered template
    return l:new_template
endfunction                                                    " }}}2
" Function: s:validVar                                           {{{2
" Purpose:  check validity of variables derived from script variables
" Params:   1 - variable to be checked
"           2 - kind of variable ('template'|'dt-items'|'dt-items-trimmed')
" Insert:   nil
" Prints:   error message if error detected
" Return:   whether valid [Boolean]
" Note:     used by functions 's:insertTemplate' and 's:getDocData'
function! s:validVar(var, kind)
    " check 'template'
    if a:kind == 'template'
        " must be a list
        if type(a:var) != type([])
            call DNU_Error('Template variable is not a List')
            return 0
        endif
        " must have content
        if len(a:var) == 0
            call DNU_Error('Template variable is empty')
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
    elseif a:kind == 'dt-items' || a:kind == 'dt-items-trimmed'
        " set the required and optional keys, and human-readable var name
        if     a:kind == 'dt-items'
            let l:required = ['name', 'explain', 'prompt', 'token']
            let l:optional = ['default', 'value']
            let l:name = 'Doc type data items'
        elseif a:kind == 'dt-items-trimmed'
            let l:required = ['token']
            let l:optional = ['value']
            let l:name = 'Trimmed doc type data items'
        endif
        let l:allowed = l:required + l:optional
        " must be a list
        if type(a:var) != type([])
            call DNU_Error(l:name . ' is not a List')
            return 0
        endif
        " must have content
        if len(a:var) == 0
            call DNU_Error(l:name . ' is empty')
            return 0
        endif
        " elements must be dictionaries
        let l:item_count = 0
        for l:item in a:var
            if type(l:item) != type({})
                let l:msg = l:name . ' element ' . l:item_count
                let l:msg .= ' is a ' . DNU_VarType(l:item)
                let l:msg .= ", not a Dictionary:\n" . string(l:item)
                call DNU_Error(l:msg)
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
                    call DNU_Error(l:msg)
                    return 0
                endif
            endfor
            " - check that all required keys are present
            for l:key in l:required
                if count(keys(l:item), l:key) == 0
                    let l:msg = l:name . ' element ' . l:item_count
                    let l:msg .= " is missing required key '" . l:key . "':\n"
                    let l:msg .= string(l:item)
                    call DNU_Error(l:msg)
                    return 0
                endif
            endfor
            " - check all keys have values with content
            for l:key in keys(l:item)
                if l:item[l:key] == ''
                    let l:msg = l:name . ' element ' . l:item_count
                    let l:msg .= " has a key ('" . l:key . "') with no value:\n"
                    let l:msg .= string(l:item)
                    call DNU_Error(l:msg)
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
                call DNU_Error(l:msg)
                return 0
            endif
        endfor
        " check for multiple elements with the same 'name' value
        " - obviously can only be done before key-value pairs are trimmed
        if a:kind == 'dt-items'
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
                    call DNU_Error(l:msg)
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
                call DNU_Error(l:msg)
                return 0
            endif
        endfor
        return 1  " success if passed all tests
    else  " invalid a:kind
        call DNU_Warn("Invalid kind parameter '" . a:kind . "'")
        return 0
endfunction                                                    " }}}2
" Function: s:deactivateRightMapping                             {{{2
" Purpose:  deactivate <Right> mapping as it interferes with Ctrl-J mapping
"           if no existing mapping throw  'E31 = No such mapping'
" Params:   nil
" Insert:   nil
" Prints:   nil
" Return:   nil
function! s:deactivateRightMapping()
    try
        nunmap <Right>
    catch /^Vim\((\a\+)\)\=:E31:/
    endtry                             
    try
        nunmap <Right>
    catch /^Vim\((\a\+)\)\=:E31:/
    endtry                             
endfunction                                                    " }}}2

" MAPPINGS:                                                      {{{1
" alternative Command-T mappings: \T,\U [N]                      {{{2
" original mappings are overridden by ATP
nnoremap <buffer> <silent> <Leader>T :CommandT<CR>
nnoremap <buffer> <silent> <Leader>U :CommandTBuffer<CR>
"                                                                }}}2
" \is -> DNL_InsertSpecialChar                                   {{{2
" insert special character
imap <buffer> <unique> <Plug>DnIS <Esc>:call DNL_InsertSpecialChar(b:dn_true)<CR>
nmap <buffer> <unique> <Plug>DnIS :call DNL_InsertSpecialChar()<CR>
if !hasmapto('<Plug>DnIS', 'i')
	imap <buffer> <unique> <LocalLeader>is <Plug>DnIS
endif
if !hasmapto('<Plug>DnIS', 'n')
	nmap <buffer> <unique> <LocalLeader>is <Plug>DnIS
endif                                                          " }}}2
" \at -> DNL_AlignTable                                          {{{2
" align source table columns
imap <buffer> <unique> <Plug>DnAT <Esc>:call DNL_AlignTable(b:dn_true)<CR>
nmap <buffer> <unique> <Plug>DnAT :call DNL_AlignTable()<CR>
if !hasmapto('<Plug>DnAT', 'i')
	imap <buffer> <unique> <LocalLeader>at <Plug>DnAT
endif
if !hasmapto('<Plug>DnAT', 'n')
	nmap <buffer> <unique> <LocalLeader>at <Plug>DnAT
endif                                                          " }}}2"

" CONTROL STATEMENTS:                                            {{{1
" return settings to previous values                             {{{2
let &cpo = s:save_cpo                                          " }}}2
"                                                                }}}1

" vim: set foldmethod=marker :
