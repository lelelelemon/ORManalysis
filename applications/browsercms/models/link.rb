  class GroupTypePermission < ActiveRecord::Base
    belongs_to :group_type, :class_name => 'GroupType'
    belongs_to :permission, :class_name => 'Permission'

    extend DefaultAccessible
  end
