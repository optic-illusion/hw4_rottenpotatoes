class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def find_similar_director
    raise ArgumentError, "No director info." unless (self.director != nil) and !self.director.strip.empty?
    Movie.find_all_by_director(self.director)
  end
end
