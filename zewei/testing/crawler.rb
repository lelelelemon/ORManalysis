require "net/http"
require "nokogiri"

class Crawl 
  def initialize(host)
    @host = host
    @visited = ["/auth/users/sign_out_post", "/auth/users/sign_out"]
    @cookie = ""
  end

  def start_crawling
    

#    uri = URI(@host + "/login")
#    @visited.push @host + "/login"
=begin
    action = "/auth/users/sign_in"
    uri = URI(@host + action)

    @visited.push @host + action

    req = Net::HTTP::Post.new(uri)
    req.add_field("Content-Type", "application/x-www-form-urlencoded")
    req.add_field("Content-Length", "204")

    req.basic_auth "admin", "password"

    req.set_form_data({
      'user[username]' => 'admin', 
      'user[password]' => 'password'
    })

    puts req
    tags = []
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      res = http.request req
      puts uri
      puts res.code
      content = res.body

      @cookie = res.response['Set-Cookie']
      puts @cookie

      next_page = res.response["Location"]
      puts content
      puts next_page
      tags.push next_page
    end
=end
    tags = ["/auth/users/sign_in"]

    self.send_requests(tags)
  end



  def send_requests(tags)
    while not tags.empty?
      tag = tags.pop

      next if @visited.include?(tag)

      if tag.instance_of? String
        new_tags = send_single_get_request(tag)
        tags += new_tags
      elsif tag.instance_of? Nokogiri::CSS::Node or tag.instance_of? Nokogiri::XML::Element
        new_tags = send_single_post_request(tag)
        tags += new_tags
      else
        puts tag.class
      end

      @visited.push(tag)
    end      
  end

  def send_single_get_request(href)

    href = @host + href if not href.start_with?"http"
    #not href =~ URI::regexp and 
    #if not href.include?(@host) and 

    href.gsub! /[\\"]/, ""
    puts href

    uri = URI(href)


    tags = []
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      req["cookie"] = @cookie

      begin
        res = http.request req

        puts "------------------href: #{href}---------------------------"
        puts res.code
        puts res.message
        puts res.class.name
        puts "Cookie: "
        puts res['Set-Cookie']
        #puts "session: " +
        content = res.body #if res.response_body_permitted?
        puts content

        puts "------------------end of: #{href}---------------------------"

        new_hrefs = get_href_tag_array_from_html(res.body)
        new_forms = get_form_tag_array_from_html(res.body)

        tags = new_hrefs
        tags += new_forms
      rescue

      end
    end
     
    return tags
  end

  def send_single_post_request(form)
    tags = []
    
    action = form.attr("action")

    return [] if @visited.include?(action + "_post")
    
    
    
    puts "---------------------------start form action: " + action + "--------------------------------"
    uri = URI(@host + action)
    @visited.push @host + action
    req = Net::HTTP::Post.new(uri)
    req["cookie"] = @cookie
    params = {}
    form.css("input[name]").each do |input|
      name = input.attr("name")
      value = input.attr("value")
    #  next if name == 'utf8'
      if value == nil or value == ""
        value = name
        value = "admin" if name == "user[username]" 
        value = "password" if name == "user[password]" 
      end
      puts name, value
      params[name] = value
    end

    req.set_form_data(params)
    Net::HTTP.start(uri.hostname, uri.port) do |http|
      res = http.request req
      puts uri
      puts res.code
      content = res.body
      puts content
      temp_cookie = res.response['Set-Cookie']
      if temp_cookie
        @cookie = temp_cookie.split(";")[0]
      end
      puts @cookie

      
      new_hrefs = get_href_tag_array_from_html(res.body)
      new_forms = get_form_tag_array_from_html(res.body)

      tags = new_hrefs
      tags += new_forms
    end

    puts "---------------------------end form action: " + action + "--------------------------------"

    @visited.push action+"_post"
    return tags
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

  def get_form_tag_array_from_html(content) 
    page = Nokogiri::HTML(content)
    res = Array.new
    forms = []
    page.css("form").each do |form|
      forms.push form
    end

    return forms
  end
end

crawl_task = Crawl.new("http://localhost:3000")
crawl_task.start_crawling
