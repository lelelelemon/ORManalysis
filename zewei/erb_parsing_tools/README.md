The scripts are used to parse erb files and extract all ruby variables out of the erb file

used in windows cmd
Usage: extract.bat input.erb input.rb input.var

input.erb is the erb file for parsing
all ruby code inside "<%" and "%>" will be extracted out and saved in input.rb
input.rb will be parsed and all ruby variables will be saved to input.var