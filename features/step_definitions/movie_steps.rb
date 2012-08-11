# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.find_or_create_by_title_and_rating(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date], :director => movie[:director])
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  step %{I should see "#{e1}"}
  step %{I should see "#{e2}"}
  (page.body =~ /#{Regexp.escape(e1)}/).should < (page.body =~ /#{Regexp.escape(e2)}/)
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rating|
    if !uncheck then
      step %{I check "ratings_#{rating}"}
    else
      step %{I uncheck "ratings_#{rating}"}
    end
  end
end

Then /I should (not )?see the following/ do |not_see, movies_table|
  movies_table.hashes.each do |movie|
    if !not_see then
      step %{I should see "#{movie[:title]}"}
    else
      step %{I should not see "#{movie[:title]}"}
    end
  end
end

Then /I should see all movies/ do
  assert page.should have_css("tbody#movielist tr", :count => 10)
#assert page.find("#movielist").find("tr").count.should == 10
end

Then /I should see the movies in the following order/ do |movies_table|
  position = 0;
  movies_table.hashes.each do |movie|
    new_position = (page.body =~ /#{Regexp.escape(movie[:title])}/)
    position.should < new_position 
    position = new_position
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie_title, director|
#page.find(:css, 'td', :text => /#{Regexp.escape(movie_title)}/).find(:xpath,".//..").has_css?('td', :text => /^#{director}$/)
  page.has_css?('li', :text => /#{Regexp.escape(director)}/)
end
