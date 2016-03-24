$cur_url = nil
$visited = Array.new
$output_file = File.open("reached_urls.txt", "w")
$global_r = Random.new(1327)
$prefix = "localhost:3000/"

$reject_url_list = Array.new
$reject_url_list.push("/auth/users/")
$reject_url_list.push("/users/")

