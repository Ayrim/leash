class Photoalbum < ActiveRecord::Base
  belongs_to :user
  has_many :picture
end
