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

See `:h dn-latex-atp` for further details.

Beamer
------

The plugin includes files for beamer themes Air, Amsterdam, Bunsen, Frederiksberg, Lleida, McGill, Oxygen, Stockton, Sybila, Torino and UNL. These files are located in the vim-dn-latex-resources/beamer plugin subdirectory. To install the themes in tex they need to copied into a latex directory.

Provided vim-dn-latex-resources/beamer is on the runtimepath, the beamer files can be copied to the TEXMFHOME directory (usually ~/texmf on unix) by running the DNL_SyncBeamer function. This function determines the target directory with 'kpsewhich' and the files are copied (synchronised) by 'rsync'.

To synchronise beamer files with each git-merge (which includes all git-pulls) it is possible to set up a template. In the vim-dn-latex-resources/git plugin subdirectory is a script that can be used as a global post-merge hook (it checks repository name and only acts on a vim-dn-latex repository merge/pull.)

Templates
---------

Templates are provided for article, report, book and beamer presentation documents. Function DNL_InsertTemplate provides for the user to select document type and enter document author, title and description (and institute for Beamer presentations). An appropriate template is inserted and the values replace tokens in the templates.  

This function is designed to be called from the vim configuration file on the BufNewFile event.

Settings
--------

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

Special characters can be selected from a menu and their tex codes inserted into the document. See `:h dn-latex-mapping-at` and `:h DNL-AlignTable` for more details.

Align tables
------------

Columns in a table can be automatically aligned. Certain conditions have to be followed in creating the table. See `:h dn-latex-mapping-at` and `:h DNL-AlignTable` for further details.

Custom snippets
---------------

Custom ultisnips snippets are provided. See `:h dn-latex-ultisnips` for details.

[atp]: http://atp-vim.sourceforge.net/
