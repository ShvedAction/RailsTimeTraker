class Track < ApplicationRecord
  belongs_to :user
  enum :work_type => [:designing, :developing, :analis, :testing, :training]
end
