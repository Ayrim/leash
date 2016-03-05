class Flock < ActiveRecord::Base
  belongs_to :user
  belongs_to :flock
  belongs_to :animal
  belongs_to :planning
end
