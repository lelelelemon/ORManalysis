#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'

# This is a simple program that reads in a Ruby ERB file, and parses
# it as an XHTML file. Specifically, it makes a decent attempt at
# converting the ERB tags (<% %> and <%= %>) to XML tags (<erb-disp/>
# and <erb-eval/> respectively.
#
# Once the document has been parsed, it will be validated and any
# error messages will be displayed.
#
# More complex option and error handling is left as an exercise to the user.

abort 'Usage: erb.rb <input_erb_filename> <output_filename>' if ARGV.empty?

filename = ARGV[0]
out_filename = ARGV[1]

begin
  # filename = 'index.html.erb'
  out_filename = 'index.html.erb.out'
  doc = ""
  File.open(filename) do |file|
    puts "\n*** Parsing #{filename} ***\n\n"
    file.read(nil, s = "")
    s = "<root>\n" + s + "\n</root>\n"
    # Substitute the standard ERB tags to convert them to XML tags
    #   <%= ... %> for <erb-disp> ... </erb-disp>
    #   <% ... %>  for <erb-eval> ... </erb-eval>
    #
    # Note that this won't work for more complex expressions such as:
    #   <a href=<% @some_object.generate_url -%> >link text</a>
    # Of course, this is not great style, anyway...
    s.gsub!(/<%=(.+?)%>/m, '<erb><erb-disp>\1</erb-disp></erb>')
    s.gsub!(/<%(.+?)%>/m, '<erb><erb-eval>\1</erb-eval></erb>')
    doc = Nokogiri::XML(s) do |config|
      # put more config options here if required
      # config.strict
    end
  end

  erbs = doc.xpath("//erb")

  output = File.open( out_filename, "w" )
  erbs.each {|x| output << x.children.children.to_s + "\n"}
  output.close    
  

  # puts doc.to_xhtml(:indent => 2, :encoding => 'UTF-8')
  # puts "Huzzah, no errors!" if doc.errors.empty?

  # Otherwise, print each error message
  doc.errors.each { |e| puts "Error at line #{e.line}: #{e}" }
rescue
  puts "Oops! Cannot open #{filename}"
end