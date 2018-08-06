" Control statements    {{{1
set encoding=utf-8
scriptencoding utf-8

if exists('b:disable_dn_latex') && b:disable_dn_latex | finish | endif
if exists('s:loaded') | finish | endif
let s:loaded = 1

let s:save_cpo = &cpoptions
set cpoptions&vim
" }}}1

" Commands

" InsertSpecialChar - insert special character at cursor   {{{1

""
" Insert a special character into text at current cursor location. Calls
" @function(dn#latex#insertSpecialChar).
command -buffer InsertSpecialChar call dn#latex#insertSpecialChar()

" AlignTable        - align latex table    {{{1

""
" Align latex table on "&" characters. Calls @function(dn#latex#alignTable).
command -buffer AlignTable call DNL_AlignTable()
" }}}1

" Control statements    {{{1
let &cpoptions = s:save_cpo
unlet s:save_cpo
" }}}1

" vim: set foldmethod=marker :
