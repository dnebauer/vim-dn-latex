vim-dn-latex
============

Installation
------------

See documentation for your favourite plugin manager.

Do note that several plugin functions depend on the `vim-dn-latex-resources` directory being findable on the `runtimepath`.

Dependencies
------------

Requires [vim-dn-utils](https://github.com/dnebauer/vim-dn-utils) by the same author.

Provides
--------

###Templates

Templates are provided for article, report, book and beamer presentation documents. On opening a new `.tex` file the user selects document type and enters document author, title and description. For beamer presentations the user also enters institute. An appropriate template is inserted and the values entered into the template.

###Beamer

Files required for the following beamer themes are copied to TEXMFHOME on unix systems (usually ~/texmf): Air, Amsterdam, Bunsen, Frederiksberg, Lleida, McGill, Oxygen, Stockton, Sybila, Torino and UNL.

###Mappings

The \<Right\> key mapping is removed to precent interference with the Ctrl-J mapping.

The following mappings prevent atp-vim from clashing with CommandT:

*   \<Leader\>T --- CommandT
*   \<Leader\>U --- CommandTBuffer
