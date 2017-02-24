1. Run the static analysis:

$cd controller\_model\_analysis

1.1 run
$ruby main.rb --help
to get the options 

1.2 Basically, to get the statistics and program flow of a specific action from an app, you would like to run:
$ruby main.rb -d DIR\_TO\_APP\_FILES -s CONTROLLER\_NAME,ACTION\_NAME

For example,
$ruby main.rb -s -d ../applications/forem PostsController,index

Results will be printed to the screen.

1.3 If you wish to run all actions from an application, do:
$ruby main.rb -a -d DIR\_TO\_APP\_FILES

Results will be saved to the folder under the app directory.
The folder name is defined under global.rb, and by default is /result/.

2. Applications:

There are already many applications that can be run, under the applications/ directory.
To run your own applications, there are some work to do:
(not completed yet...)

a. copy the ruby files to some directory APPDIR, under the applications/ folder:
$cd applications/
$mkdir APPNAME/
$cd ..

b. in your app, run:
$rake routes | tail -n +2 | awk '{ for (i=1;i<=NF;i++) if (match($i, /.#./)) print $i}' | sed -e 's/#/,/g' | sort | uniq
to get the list of entrance controller actions that can be invoked by the app, copy it to APPDIR/calls.txt

c. go to preprocess\_views/ folder, and check the README.md there to extract the code from view. 
If there are only .erb files in views, it is probably fine. But if you are using haml, the convertion from haml to erb may run into some trouble.

d. copy schema.rb in your app to APPDIR/.

e. use jruby to "compile" your app. The modified jruby should be checked out at <https://github.com/congy/jruby\_for\_orm.git>.
Then go to the applications folder and run the script:
$cd applications/
$python generate\_dataflow.py APPNAME




