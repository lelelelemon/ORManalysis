#!/usr/local/bin/ruby

require "net/http"
require "nokogiri"
require "faker"
#load "story.config.rb"
load "message.config.rb"

$memorize_visit = true

class Crawl 
  def initialize(host)
    @host = host
    @fout_urls = File.open("urls.txt", "w")
  end

  def start_crawling
    self.login("/login")
  end

  def login(login_path)

    login_path = @host + login_path if not login_path.include?(@host)
    uri = URI(login_path)

    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      begin
        res = http.request req
        cookie = res['Set-Cookie'].split(";")[0]
        content = res.body #if res.response_body_permitted?

        page = Nokogiri::HTML(content)
        page.css("form[action='/login']").each do |form|
#first thing is to login the page
          action = form.attr("action")
          uri = URI(@host + action)
          _req = Net::HTTP::Post.new(uri)
          _req["cookie"] = cookie
          params = {}
          form.css("input[name]").each do |input|
            name = input.attr("name")
            value = input.attr("value")
            if value == nil or value == ""
              value = "test" if name == "email" 
              value = "test" if name == "password" 
            end
            params[name] = value
          end
          _req.set_form_data(params)
          Net::HTTP.start(uri.hostname, uri.port) do |http|
            _res = http.request _req
            content = _res.body
          
            temp_cookie = _res.response['Set-Cookie']
            puts temp_cookie
            if temp_cookie
              cookie = temp_cookie.split(";")[0]
            end
          end
  
          i = 0
          while i < 20
            puts "looping..."
            
            params = get_params

            self.populate_form($page_path, $form_query, cookie, params)

            i += 1
          end

        end
      rescue

      end
    end
  end
  
  def populate_form(path, query_form_tag, cookie, params)
    path = @host + path if not path.include?(@host)
    uri = URI(path)

    puts path
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      req["cookie"] = cookie
      begin
        res = http.request req
        cookie = res['Set-Cookie'].split(";")[0]
        content = res.body #if res.response_body_permitted?
        page = Nokogiri::HTML(content)
        page.css(query_form_tag).each do |form|
        
          puts form
          #first thing is to login the page
          action = form.attr("action")
          action = @host + action if not action.include?(@host)
          uri = URI(action)
          _req = Net::HTTP::Post.new(uri)
          _req["cookie"] = cookie
          _params = {}
          form.css("input[name]").each do |input|
            name = input.attr("name")
            value = input.attr("value")
            _params[name] = value
          end
          puts "params: "
          puts _params
          
          params.each do |k, v|
            _params[k] = v
          end
          puts "------params: "
          puts _params
          _req.set_form_data(_params)
          Net::HTTP.start(uri.hostname, uri.port) do |http|
            _res = http.request _req
            puts _res
            puts _res.body
            puts _res.msg
          end
        end
      rescue
      end
    end
  end

  def send_single_post_request(form, cookie)
    tags = []
    action = form.attr("action")
    return tags, cookie if @visited.include?("POST " + action) and $memorize_visit 
    puts "---------------------------start form action: " + @host + action + "--------------------------------"
    uri = URI(@host + action)
    @visited.push @host + action if $memorize_visit
    req = Net::HTTP::Post.new(uri)
    req["cookie"] = cookie
    params = {}
    form.css("input[name]").each do |input|
      name = input.attr("name")
      value = input.attr("value")
    #  next if name == 'utf8'
      if value == nil or value == ""
        value = name
        value = "admin" if name == "user[username]" 
        value = "password" if name == "user[password]" 
        value = "test" if name == "email" 
        value = "test" if name == "password" 
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
        cookie = temp_cookie.split(";")[0]
      end
      
      new_hrefs = get_href_tag_array_from_html(res.body)
      new_forms = get_form_tag_array_from_html(res.body)

      tags += new_hrefs
      tags += new_forms
    end

    if action == "/login"
      @visited = ["POST /logout"]
    end

    puts "---------------------------end form action: " + action + "--------------------------------"

    @visited.push "POST " + action if $memorize_visit
    @fout_urls.write("POST " + action + "\n")

    return tags, cookie
  end

end

crawl_task = Crawl.new("http://localhost:3000")
crawl_task.start_crawling
