require 'spec_helper'
require Rails.root.join('db','seeds')

describe Movie do
  subject {Movie.find_by_title("Chicken Run")}

  it "has all ratings" do
    Movie.all_ratings.should =~ %w(G PG PG-13 NC-17 R) 
  end

  its(:find_similar_director) { should have(2).things }

  it "does not have director info" do
    @movie = Movie.find_by_title("The Help")
    expect {@movie.find_similar_director}.to raise_error(ArgumentError)
  end
end
