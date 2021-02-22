class Movie < ActiveRecord::Base


 def self.all_ratings
     self.all.select(:rating).distinct.pluck(:rating)
 end

 def self.with_ratings(ratings) 
    #Input an array of ratings and output will be relational Movie object with those
    byebug
    if ratings.empty? || ratings.nil?
     self.where({rating: self.all_ratings})
    else
     self.where({rating: ratings})
    end
 end

end
