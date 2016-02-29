#!/usr/local/bin/ruby

require "net/http"
require "nokogiri"
load "lobsters/forms.rb"

class Crawl 
  def initialize(host)
    @host = host
    @visited = []
    @fout_urls = File.open("urls.txt", "w")
  end

  def start_crawling
    tags = ["/"]
    self.send_requests([tags, ""])
  end

  def send_requests(tags)
    tags.each do |(tag, cookie)|
   
      puts tag

      _tags = []
      if tag.instance_of? Nokogiri::CSS::Node or tag.instance_of? Nokogiri::XML::Element
        new_tags, new_cookie = send_single_post_request(tag, cookie)
        new_tags.each do |new_tag|
          _tags.push [new_tag, new_cookie]
        end
      elsif tag.instance_of? String
        #  if $forms.has_key?(tag)
        #    populate_form(tag, $forms[tag][:form_query], cookie, $forms[tag][:params])
        #  else
        new_tags, new_cookie = send_single_get_request(tag, cookie)
        new_tags.each do |new_tag|
          _tags.push [new_tag, new_cookie]
        end
        puts tag.class
      end
      send_requests(_tags)

    end      
  end

  def send_single_get_request(href, cookie)

    href = @host + href if not href.include?(@host)
    tags = []
    return tags, cookie if @visited.include?("GET " + href)
    href.gsub! /[\\"]/, ""
    puts href
    begin
      uri = URI(href)
    rescue
      puts "invalid uri:"
      puts href
    #  @fout_urls.write("GET " + href + "\n")
      @visited.push href
      return tags, cookie
    end
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      req["cookie"] = cookie
      res = http.request req
      puts "------------------href: GET #{href}---------------------------"
      cookie = res['Set-Cookie']
      if cookie != nil
        cookie = cookie.split(";")[0]
      end
      #puts "session: " +
      content = res.body #if res.response_body_permitted?
      puts content

      puts "------------------end of: GET #{href}---------------------------"

      new_hrefs = get_href_tag_array_from_html(res.body)
      new_forms = get_form_tag_array_from_html(res.body)

      tags += new_forms
      tags += new_hrefs
    end
     
    @fout_urls.write("GET " + href + "\n")
    @visited.push("GET " + href)
    return tags, cookie
  end

  def send_single_post_request(form, cookie)
    tags = []
    action = form.attr("action")
    return tags, cookie if @visited.include?("POST " + action)
    
    puts "---------------------------start form action: POST #{action} --------------------------------"
    uri = URI(@host + action)
    @visited.push @host + action
    req = Net::HTTP::Post.new(uri)
    req["cookie"] = cookie
    params = {}
    form.css("input[name]").each do |input|
      name = input.attr("name")
      value = input.attr("value")
      if value == nil or value == ""
        value = name
      end
      puts name, value
      params[name] = value
    end

    selects = form.css("select")
    #puts selects
    selects.each do |select|
      name = select.attr("name")
      options = select.css("option")
      index = rand(options.length)
      value = options[index].attr("value")
      params[name] = value
    end

    if $forms.has_key?(action)
      _params = $forms[action][:params].call
      _params.each do |k, v|
        params[k] = v
      end
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

      tags += new_forms
      tags += new_hrefs
    end
    puts "---------------------------end form action: POST #{action} --------------------------------"

    @fout_urls.write("POST " + action + "\n")

    if "POST " + action == "POST " + $login
      @visited = ["POST " + $login, "GET " + $logout]
    end
    @visited.push("POST " + action)
    return tags, cookie
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

  def populate_form(path, query_form_tag, cookie, params)

    path = @host + path if not path.include?(@host)
    uri = URI(path)

    tags = []
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      req["cookie"] = cookie
      res = http.request req
      cookie = res['Set-Cookie'].split(";")[0]
      content = res.body #if res.response_body_permitted?
      page = Nokogiri::HTML(content)

      puts "query form: " + query_form_tag
      page.css(query_form_tag).each do |form|
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
          new_hrefs = get_href_tag_array_from_html(res.body)
          new_forms = get_form_tag_array_from_html(res.body)

          tags += new_hrefs
          tags += new_forms

        end
      end
    end
    @visited.push href
    return tags, cookie
  end
end

crawl_task = Crawl.new("http://localhost:3000")
crawl_task.start_crawling
