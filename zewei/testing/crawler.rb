require "net/http"
require "nokogiri"

class Crawl 
  def initialize(host)
    @host = host
    @visited = []
    @cookie = ""
  end

  def start_crawling
    

    uri = URI(@host + "/login")
    @visited.push @host + "/login"


    req = Net::HTTP::Post.new(uri)

    #req.basic_auth "test", "test"

    req.set_form_data({
      'email' => 'test', 
      'password' => 'test'
    })
=begin
    res = Net::HTTP.post_form(
      uri, 
      'email' => 'test', 
      'password' => 'test'
    )

    puts res['Set-Cookie']
    puts res.body
=end
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      res = http.request req
      puts uri
      puts res.code
      content = res.body
      puts content
      puts res.response

#      puts res.response.header
      #puts res.header
      cookie = res.response['Set-Cookie']
      puts cookie

      puts res.header["Location"]
      puts res["Set-Cookie"]

      hrefs = get_href_tag_array_from_html(content)
      send_get_requests(hrefs, cookie)
    end
  end

  def send_get_requests(hrefs, cookie)
   
    while not hrefs.empty?
      
      href = hrefs.pop
      href = @host + href if not href.start_with?"http"
        #not href =~ URI::regexp and 
        #if not href.include?(@host) and 
      next if @visited.include?(href)

      puts "href: " + href
      uri = URI(href)

      Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Get.new uri
#        req['Cookie'] = 

        res = http.request req

        puts "------------------href: #{href}---------------------------"
        puts res.code
        puts res.message
        puts res.class.name
        puts "Cookie: "
        puts res['Set-Cookie']
        #puts "session: " +
        
        puts res.body #if res.response_body_permitted?
        
        puts "------------------end of: #{href}---------------------------"


        new_hrefs = get_href_tag_array_from_html(res.body)
        hrefs += new_hrefs
      end

      @visited.push href 
    end

  end

  def get_href_tag_array_from_html(content)
    page = Nokogiri::HTML(content)
    res = Array.new
    page.css("a").each do |a|

      href = a["href"]
      href = "" if href == nil
      res.push(href)
    end
    return res
  end

end

crawl_task = Crawl.new("http://localhost:3000")
crawl_task.start_crawling
