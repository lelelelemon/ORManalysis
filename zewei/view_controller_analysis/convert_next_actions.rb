require "fileutils"
$next_action_path = ARGV[0]
$new_next_action_path = ARGV[1]
def get_file_name_from_path(filename)
    i = filename.rindex('/')
      if i == nil
            return nil
              end
        n = filename[i+1..filename.length]
          return n
end

def get_nested_path(filepath, basepath)
    i = filepath.rindex(basepath)
      j = filepath.rindex('/')
        if i == nil or j == nil
              return nil
                end
          n = filepath[i+basepath.length..j]
            return n
end

def convert_next_action(old_file, new_file)
  fp = File.open(new_file, "w")
  File.open(old_file, "r").each_line do |line|
    if line.strip.length == 0

    else
      if line.include?"new/create\n"
        line1 = line.gsub("new/create\n", "")
        line = line1 + "new\n" + line1 + "create\n"
      end
      line.gsub! "/", "::"
      fp.write line
    end
  end
  fp.close
end

Dir.glob($next_action_path + "**/*") do |item|
  puts item
  next if not item.end_with?".txt"
  nested_path = get_nested_path(item, $next_action_path)
  file_name = get_file_name_from_path(item)
  if not File.directory?($new_next_action_path + nested_path)
    FileUtils.mkdir_p $new_next_action_path + nested_path
  end
  convert_next_action(item, $new_next_action_path + nested_path + file_name)
end

