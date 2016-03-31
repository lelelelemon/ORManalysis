#!/bin/bash

echo $#

if [ "$#" -ne 2 ]; then
  echo "Usage: ./setup.sh git_path project_path"
  exit
fi

git_path=$1
project_path=$2

#sudo gem install yard
#sudo gem install unicode
#sudo gem install rb-readline

cp $1/zewei/named_routes/* $2
cp $1/zewei/extract_erb/* $2
cp $1/zewei/haml2erb/* $2
cp $1/zewei/view_controller_analysis/read_files.rb $2
cp $1/zewei/view_controller_analysis/data_structure.rb $2
cp $1/zewei/view_controller_analysis/helper.rb $2
cp $1/zewei/view_controller_analysis/render.rb $2
cp $1/zewei/view_controller_analysis/archive.rb $2
cp $1/zewei/scripts/test_yard.rb $2

echo "generating named_routes.txt..."
bash named_routes.sh 

echo "dealing with haml..."
#ruby traverse_view_dir_preprocess_haml.rb app/views

#ruby traverse_view_dir_convert_haml.rb app/views

echo "compiling extract_ruby..."
g++ extract_ruby.cpp -o extract_ruby

echo "extracting ruby code out of erb files..."
ruby traverse_view_dir_extract_ruby.rb extract_ruby app/views

echo "Generating controllers merged with views..."
#ruby read_files.rb -c -a > controller-log.txt
echo "Now you may find merged controllers inside app/new_controllers"

echo "Generating links for each controller action..."
#ruby read_files.rb -c > links-log.txt
echo "Now you may find links for each controller action inside app/new_views"

echo "If you want links with log info, try: ruby read_files.rb -c > links-log.txt"
cp $1/ormanalysis/zewei/scripts/filter_start_render.rb $2
