vim-dn-latex
============

Installation
------------

See documentation for your favourite plugin manager.

Do note that several plugin functions depend on the `vim-dn-latex-resources` directory being findable on the `runtimepath`.

Dependencies
------------

Requires [vim-dn-utils](https://github.com/dnebauer/vim-dn-utils) by the same author.

ATP-vim
-------

Plugin assumes you are using [atp-vim][atp]. An atp configuration file is provided that:

*   Sets it to use vim completion rather than python completion
*   Provides shortcuts for moving between environments
*   Sets progress bar to display on tex compilation
*   Switches to the lualatex engine
*   Sets the compilation switch '-recorder'
*   Changes settings to play nice with CommandT and UltiSnips plugins
*   Optionally configures project to use subdirectory ('working') for compilation.

The user's choice regarding use of a subdirectory is recorded in a hidden file ('.dna_atprc') at file creation time so the user is not asked when the file is subsequently opened.

See the file itself for further documentation.

Initialisation
--------------

The function `DNM_Initialise` is provided. It performs several tasks. A summary follows and further information is provided in vim documentation (see `dn-latex-ftplugin`).

### Beamer

The plugin includes files for beamer themes Air, Amsterdam, Bunsen, Frederiksberg, Lleida, McGill, Oxygen, Stockton, Sybila, Torino and UNL. These are synchronised with the TEXMFHOME directory (usually ~/texmf on unix systems). The target file directory is determined using 'kpsewhich' and the files synchronised with 'rsync'. Snchronisation does not occur if these tools are not available.

Although there are a large number of files being synchronised, on a modern computer system the delay is not noticeable.

### Templates

Templates are provided for article, report, book and beamer presentation documents. On opening a new `.tex` file the user selects document type and enters document author, title and description. For beamer presentations the user also enters institute. An appropriate template is inserted and the values entered into the template.

### Settings

Adjust vim settings:

*   tabstop=2

*   softtabstop=2

*   shiftwidth=2

*   expandtab=ON

*   textwidth=72

*   formatoptions-=la

*   formatoptions+=tc

Special characters
------------------

Special characters can be selected from a menu and their tex codes inserted into the document. This function is bound to `LocalLeader-is` in normal and insert modes.

Align tables
------------

Columns in a table can be automatically aligned. Certain conditions have to be followed in creating the table. See vimhelp ('DNL-AlignTable') for further details.

This function is bound to `LocalLeader-at` in normal and insert modes.

Custom snippets
---------------

Custom ultisnips snippets are provided. See vimhelp ('ft-latex-dn-plugin-ultisnips') for details.

[atp]: http://atp-vim.sourceforge.net/
