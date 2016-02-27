  class UserGroupMembership < ActiveRecord::Base

    extend DefaultAccessible

    belongs_to :group, :class_name => 'Group'
    belongs_to :user, :class_name => 'PersistentUser'
  end
