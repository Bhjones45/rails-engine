class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end
end
