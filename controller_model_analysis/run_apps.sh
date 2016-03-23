#!/bin/bash

#applications="boxroom lobsters communityengine publify jobsworth amahiPlatform railscollab sharetribe onebody linuxfr rucksack sugar kandan fulcrum tracks browsercms"
applications="lobsters amahiPlatform fulcrum linuxfr onebody rucksack sugar boxroom jobsworth publify railscollab sharetribe tracks brevidy communityengine"

#applications="communityengine linuxfr railscollab rucksack discourse amahiPlatform"

#applications="onebody linuxfr"

export PATH=$PATH:~/jruby/bin

function run_single_app () {
	app=$1
	echo "start app ${app}"
	cd ~/ruby_source/ORM_analysis/applications/${app}/
	rm -rf results
	mkdir results
	#rm -rf dataflow
	#cd ~/ruby_source/ORM_analysis/applications/
	#python generate_dataflow.py ${app} >> logs/${app}_log.log
	cd ~/ruby_source/ORM_analysis/controller_model_analysis
	ruby main.rb -a -d ../applications/${app} &> ${app}_run.log
  echo "Finish app ${app}"
}



for app in $applications ; do
	run_single_app "${app}" &
done
