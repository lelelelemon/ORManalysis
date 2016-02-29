#!/usr/local/bin/ruby

require "net/http"
require "nokogiri"
require "faker"
load "forms.rb"

$memorize_visit = true

class Crawl 
  def initialize(host)
    @host = host
    @fout_urls = File.open("urls.txt", "w")
  end

  def start_crawling
    self.login($login_path)
  end

  def login(login_path)
    puts "login path: " + login_path

    login_path = @host + login_path if not login_path.include?(@host)
    uri = URI(login_path)

    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      res = http.request req
      cookie = res['Set-Cookie'].split(";")[0]
      content = res.body #if res.response_body_permitted?

      page = Nokogiri::HTML(content)
    
      page.css($login_form_query).each do |form|
#first thing is to login the page
        action = form.attr("action")
        uri = URI(@host + action)
        _req = Net::HTTP::Post.new(uri)
        _req["cookie"] = cookie
        params = {}
        form.css("input[name]").each do |input|
          name = input.attr("name")
          value = input.attr("value")
          params[name] = value
        end

        $login_info.each do |k, v|
          params[k] = v
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
        while i < 2
          puts "looping..."
          params = get_params

          self.populate_form($page_path, $form_query, cookie, params)
          i += 1
        end
      end
    end
  end
  
  def populate_form(path, query_form_tag, cookie, params)

    path = @host + path if not path.include?(@host)
    uri = URI(path)


    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      req["cookie"] = cookie
      res = http.request req
      cookie = res['Set-Cookie'].split(";")[0]
      content = res.body #if res.response_body_permitted?
      page = Nokogiri::HTML(content)

      puts "query form: " + query_form_tag
      page.css(query_form_tag).each do |form|
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
        
        selects = form.css("select")
        #puts selects
        selects.each do |select|
          name = select.attr("name")
          options = select.css("option")
          index = rand(options.length)
          value = options[index].attr("value")
          _params[name] = value
        end
        
        params.each do |k, v|
        _params[k] = v
        end
       
        puts "------params: "
        puts _params
        
        _req.set_form_data(_params)
        Net::HTTP.start(uri.hostname, uri.port) do |http|
          _res = http.request _req
          puts _res.body
          puts _res.header
        end
      end
    end
  end

end

crawl_task = Crawl.new("http://localhost:3000")
crawl_task.start_crawling
