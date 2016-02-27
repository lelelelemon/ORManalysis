  class Tagging < ActiveRecord::Base
    belongs_to :tag, :class_name => 'Tag'
    belongs_to :taggable, :polymorphic => true, :class_name => 'Taggable', :foreign_type => 'taggable_type'

    extend DefaultAccessible
   #attr_accessible :tag, :taggable

    def content_type
      ContentType.first(:conditions => {:name => taggable_type})
    end

  end
