" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

if exists('b:disable_dn_latex') && b:disable_dn_latex | finish | endif
if exists('s:loaded') | finish | endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Documentation    {{{1
" - vimdoc does not automatically generate a mappings section

""
" @section Mappings, mappings
"
" [NI]<Leader>is
"   * insert a special character at cursor location
"   * calls @function(dn#latex#insertSpecialChar)
"
" [NI]<Leader>at
"   * align current table on "&" character
"   * calls @function(dn#latex#aligTable)
"
" [N]>E
"   * move to next environment
"
" [N]>E
"   * move to previous environment

" }}}1

" Mappings

" \is - insert special character    {{{1

" Calls @function(dn#latex#insertSpecialChar) from |Insert-mode| and
" |Normal-mode| to insert a special character at the current location.
imap <buffer> <unique> <Plug>DnIS <Esc>:call DNL_InsertSpecialChar(v:true)<CR>
nmap <buffer> <unique> <Plug>DnIS :call DNL_InsertSpecialChar()<CR>
if !hasmapto('<Plug>DnIS', 'i')
	imap <buffer> <unique> <LocalLeader>is <Plug>DnIS
endif
if !hasmapto('<Plug>DnIS', 'n')
	nmap <buffer> <unique> <LocalLeader>is <Plug>DnIS
endif

" \at - align current table columns    {{{1

" Calls @function(dn#latex#alignTable) to align the current latex table on the
" "&" character.
imap <buffer> <unique> <Plug>DnAT <Esc>:call DNL_AlignTable(v:true)<CR>
nmap <buffer> <unique> <Plug>DnAT :call DNL_AlignTable()<CR>
if !hasmapto('<Plug>DnAT', 'i')
	imap <buffer> <unique> <LocalLeader>at <Plug>DnAT
endif
if !hasmapto('<Plug>DnAT', 'n')
	nmap <buffer> <unique> <LocalLeader>at <Plug>DnAT
endif
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
