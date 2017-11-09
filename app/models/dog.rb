class Dog < ActiveRecord::Base
  belongs_to :animal

  def name
    animal.name
  end
end
