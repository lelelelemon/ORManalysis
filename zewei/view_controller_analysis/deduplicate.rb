def parse_rails_console_get_controller_action(line)
    line.strip!
      line = line[1..-1] if line.start_with?"{"
        line = line[0..-2] if line.end_with?"}"
          line = line.split ","
            hash = {}
              line.each do |item|
                    item = item.split("=>")
                        item[0].strip!
                            item[1].strip!
                                item[1].gsub! /['"]/, ""
                                    hash[item[0]] = item[1]
                                      end
                return hash 
end


next_actions = []
File.open(ARGV[0], "r").each_line do |line|
  if line.start_with?"#visiting page:"
    
    next_actions.uniq.each do |next_action|
      puts next_action
    end
    puts line
    next_actions = []
  elsif line.start_with?"{:controller=>\"errors\", :action=>\"not_found\", :path=>\"maps/"
  
  elsif line.start_with?"{"
    hash = parse_rails_console_get_controller_action(line)

    next_actions.push "#{hash[":controller"]},#{hash[":action"]}"
  end
end
