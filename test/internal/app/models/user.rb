class User < ActiveRecord::Base
  validates :email, presence: true
end
