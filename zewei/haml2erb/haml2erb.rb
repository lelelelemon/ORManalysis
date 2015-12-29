require "fileutils"
require "net/http"
require "json"

hamlfile = ARGV[0]
file = File.open(hamlfile, "r")
content = file.read

uri = URI("https://haml2erb.org/api/convert")

#req = Net::HTTP::Post.new(uri)
#req.haml = content
#req.converter = "herbalizer"

#res = Net::HTTP.start(uri.hostname, uri.port) do |http|
#	http.request(req)
#end

res = Net::HTTP.post_form(uri, "haml" => content, "converter" => "herbalizer")

res = JSON.parse(res.body)
puts res["erb"]
