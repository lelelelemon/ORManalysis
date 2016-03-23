$select_root_perc = 0

$story_id_list = Array.new
$comment_id_list = Array.new

$prefix = "http://localhost:3000/"

#Avoid going to these urls...
$reject_url_list = Array.new
$reject_url_list.push("/settings")
$reject_url_list.push("/logout")


$entrance_list = Array.new

#$entrance_list.push("#{$prefix}filters")
#$entrance_list.push("#{$prefix}privacy")
#$entrance_list.push("#{$prefix}about")
#$entrance_list.push("#{$prefix}threads")
