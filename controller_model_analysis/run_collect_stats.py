import os
import sys

applications = ['boxroom','lobsters','publify','communityengine','jobsworth','railscollab','amahiPlatform','browsercms','linuxfr','diaspora']

for app in applications:
	print app
	os.system("python collect_stats.py %s"%app)

