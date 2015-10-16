run script:
$ python parse.py
It will generate simple.diag file, and also print out the call graph on the console.
Install blockdiag: http://blockdiag.com/en/
$ sudo easy_install blockdiag
Running the blockdiag on simple.diag will generate the graph simple.png:
$ blockdiag simple.diag
