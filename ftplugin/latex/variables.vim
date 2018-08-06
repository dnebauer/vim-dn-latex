" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

if exists('b:disable_dn_md_utils') && b:disable_dn_md_utils | finish | endif
if exists('s:loaded') | finish | endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim
" }}}1

""
" @section Variables, vars
" The @plugin(name) plugin contributes to the |dn-utils| plugin's help system
" (see |dn#util#help()| for details). In the help system navigate to:
" vim -> tex.

" Add to help plugins list (g:dn_help_plugins)    {{{1
if !exists('g:dn_help_plugins')
    let g:dn_help_plugins = {}
endif
if !count(g:dn_help_plugins, 'tex')
    call add(g:dn_help_plugins, 'tex')
endif

" Add help topics (g:dn_help_topics)    {{{1
if !exists('g:dn_help_topics')
    let g:dn_help_topics = {}
endif
let g:dn_help_topics['tex'] = {
            \ 'spacing'          : 'tex_spacing',
            \ 'compiler commands': 'tex_compiler_commands',
            \ 'viewing pdf'      : 'tex_view_pdf',
            \ 'snippets'         : 'tex_snippets',
            \ }

" Add help data for help topics (g:dn_help_data)    {{{1
if !exists('g:dn_help_data')
    let g:dn_help_data = {}
endif
let g:dn_help_data['tex_spacing'] = [
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
let g:dn_help_data['tex_compiler_commands'] = [
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
let g:dn_help_data['tex_view_pdf'] = [
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
let g:dn_help_data['tex_snippets'] = [
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
            \ ]
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
