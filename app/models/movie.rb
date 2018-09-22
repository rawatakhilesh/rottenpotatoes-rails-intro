class Movie < ActiveRecord::Base
    def self.all_ratings
        # ratings = Array.new
        # ratings.map! {|rating| Movie.active.pluck(:rating)}
        return Movie.pluck(:rating).uniq.sort
    end    
end
