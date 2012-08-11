require 'spec_helper'
require Rails.root.join('db','seeds')

describe MoviesController do
  describe "create movie" do
    it "should create movie" do
      fake_movie = mock(Movie)
      fake_movie.should_receive(:title).and_return("Fake Movie Title")
      Movie.should_receive(:create!).and_return(fake_movie)
      post :create
#assigns(:movies).should_not be_nil
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
  end

  describe "destroy movie" do
    it "should destroy movie" do
      fake_movie = mock(Movie)
      fake_movie.should_receive(:destroy)
      fake_movie.should_receive(:title).and_return("Fake Movie Title")
      Movie.should_receive(:find).and_return(fake_movie)
      post :destroy, {:id => 1} 
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
  end

  describe "search for similar directors" do
    it "should fail and redirect to movies path if no search type given" do
      post :search, {:id => 1}
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end

    it "should fail and redirect to movies path if wrong search type given" do
      post :search, {:id => 1, :type => "title"}
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end

    it "should call Movies.find_similar_director" do
      fake_movie = mock(Movie)
      fake_movie.should_receive(:find_similar_director).and_return([mock(Movie), mock(Movie)])
      Movie.should_receive(:find).and_return(fake_movie)
      post :search, {:id => 1, :type => "director"}
    end

    it "should succeed and continue to search movies path" do
      fake_movie = mock(Movie)
      fake_movie.should_receive(:find_similar_director).and_return([mock(Movie), mock(Movie)])
      Movie.should_receive(:find).and_return(fake_movie)
      post :search, {:id => 1, :type => "director"}
      assigns(:movies).should have_at_least(2).items
      flash[:notice].should be_nil
      response.should render_template(:search)
    end
#
    it "should fail and redirect to movies path if no movies returned" do

      fake_movie = mock(Movie)
      fake_movie.should_receive(:find_similar_director).and_raise(ArgumentError)
      fake_movie.should_receive(:title).and_return("Fake Movie Title")
      Movie.should_receive(:find).and_return(fake_movie)
      post :search, {:id => 1, :type => "director"}
      flash[:notice].should_not be_nil
      response.should redirect_to(movies_path)
    end
#
  end
end
