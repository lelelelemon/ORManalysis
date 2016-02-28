# Each concern should be automatically added to each ActiveRecord class using extend.
module Concerns; end

Dir["#{File.dirname(__FILE__)}/concerns/*.rb"].each do |b|
  require File.join("cms", "concerns", File.basename(b, ".rb"))
  ActiveRecord::Base.extend "Concerns::#{File.basename(b, ".rb").camelize}".constantize
end