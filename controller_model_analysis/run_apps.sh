#!/bin/bash

#applications="boxroom lobsters communityengine publify jobsworth amahiPlatform railscollab sharetribe onebody linuxfr rucksack sugar kandan fulcrum tracks browsercms"
#applications="lobsters amahiPlatform fulcrum linuxfr onebody rucksack sugar boxroom jobsworth publify railscollab sharetribe tracks brevidy communityengine"

applications="sugar lobsters wallgig boxroom enki publify railscollab onebody jobsworth sharetribe communityengine linuxfr rucksack calagator forem fulcrum tracks brevidy"

#applications="lobsters boxroom enki publify communityengine sharetribe calagator forem"

export PATH=$PATH:~/jruby/bin

function run_single_app () {
	app=$1
	echo "start app ${app}"
	cd ~/ruby_source/ORM_analysis/applications/${app}/
	rm -rf results
	#mv results old_results
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
