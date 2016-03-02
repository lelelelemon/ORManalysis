
  class DynamicView < ActiveRecord::Base
    store_templates

    extend DefaultAccessible

    def self.with_file_name(file_name)
      conditions = {:name => nil, :format => nil, :handler => nil}
      if file_name && (parts = file_name.split(".")).size == 3
        conditions[:name] = parts[0]
        conditions[:format] = parts[1]
        conditions[:handler] = parts[2]
      end
      where(conditions)
    end

	scope :published, -> { where(:published => true) }
  scope :unpublished, -> {
    if self.versioned?
      q = "#{connection.quote_table_name(version_table_name)}.#{connection.quote_column_name('version')} > " +
          "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name('version')}"
      select("distinct #{connection.quote_table_name(table_name)}.*").where(q).joins(:versions)
    else
      where(:published => false)
    end
  }
	scope :created_by, lambda{|user| {:conditions => {:created_by => user}}}
  scope :updated_by, lambda{|user| {:conditions => {:updated_by => user}}}      

        before_validation :set_publish_on_save
        before_validation :set_defaults, :set_path

        validates_presence_of :name, :format, :handler, :path, :locale
        validates_uniqueness_of :name, :scope => [:format, :handler],
                                :message => "Must have a unique combination of name, format and handler",
                                conditions: -> { where(deleted: false) }


    # Returns the title of this class
    def self.title
      self.name.demodulize.titleize
    end

    def self.new_with_defaults(options={})
      new({:format => "html", :handler => "erb", :body => default_body, :locale => I18n.locale}.merge(options))
    end

    def self.find_by_file_name(file_name)
      with_file_name(file_name).first
    end

    def self.base_path
      File.join(Rails.root, "tmp", "views")
    end

    def file_name
      "#{name}.#{format}.#{handler}"
    end

    def display_name
      self.class.display_name(file_name)
    end

    def self.default_body
      ""
    end

    def set_publish_on_save
      self.publish_on_save = true
    end

    def set_path
      self.path = self.class.relative_path + '/' + name
    end

    def set_defaults
      self.locale = I18n.locale.to_s unless locale
      self.partial = partial?
      true
    end
  end
