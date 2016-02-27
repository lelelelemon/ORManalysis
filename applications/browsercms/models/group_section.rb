  class GroupSection < ActiveRecord::Base

    extend DefaultAccessible

    belongs_to :group, :class_name => 'Group'
    belongs_to :section, :class_name => 'Section'
  end
