#!/usr/local/bin/ruby

require "net/http"
require "nokogiri"

class Crawl 
  def initialize(host)
    @host = host
    @visited = ["/auth/users/sign_out_post", "/auth/users/sign_out"]
  end

  def start_crawling
    tags = ["/auth/users/sign_in"]
    self.send_requests([tags, ""])
  end

  def send_requests(tags)
    tags.each do |(tag, cookie)|
   
      puts tag

      _tags = []
      if tag.instance_of? String
        new_tags, new_cookie = send_single_get_request(tag, cookie)
        new_tags.each do |new_tag|
          _tags.push [new_tag, new_cookie]
        end
      elsif tag.instance_of? Nokogiri::CSS::Node or tag.instance_of? Nokogiri::XML::Element
        new_tags, new_cookie = send_single_post_request(tag, cookie)
        new_tags.each do |new_tag|
          _tags.push [new_tag, new_cookie]
        end
      else
        puts tag.class
      end
      send_requests(_tags)

    end      
  end

  def send_single_get_request(href, cookie)

    href = @host + href if not href.start_with?"http"
    #not href =~ URI::regexp and 
    #if not href.include?(@host) and 

    tags = []
    return tags, cookie if @visited.include?(href)
    href.gsub! /[\\"]/, ""
    puts href
    uri = URI(href)
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new uri
      req["cookie"] = cookie
      begin
        res = http.request req
        puts "------------------href: #{href}---------------------------"
        cookie = res['Set-Cookie'].split(";")[0]
        #puts "session: " +
        content = res.body #if res.response_body_permitted?
        puts content

        puts "------------------end of: #{href}---------------------------"

        new_hrefs = get_href_tag_array_from_html(res.body)
        new_forms = get_form_tag_array_from_html(res.body)

        tags += new_hrefs
        tags += new_forms
      rescue

      end
    end
     
    @visited.push href
    return tags, cookie
  end

  def send_single_post_request(form, cookie)
    tags = []
    action = form.attr("action")
    return tags, cookie if @visited.include?(action + "_post")
    puts "---------------------------start form action: " + action + "--------------------------------"
    uri = URI(@host + action)
    @visited.push @host + action
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
    puts "---------------------------end form action: " + action + "--------------------------------"

    @visited.push action+"_post"
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
end

crawl_task = Crawl.new("http://localhost:3000")
crawl_task.start_crawling
