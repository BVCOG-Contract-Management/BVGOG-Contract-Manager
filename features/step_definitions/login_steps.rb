# frozen_string_literal: true



Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create user
  end
end

Then(/I should see "(.*)" before "(.*)"/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When(/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %(I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}")
  end
end

Then(/I should see all the movies/) do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %(I should see "#{movie.title}")
  end
end

Then(/^the director of "(.*)" should be "(.*)"$/) do |title, director|
  # puts "Title and director: ", title, director, Movie.find_by_title(title).director
  expect(Movie.find_by(title:).director).to eq(director)
end

Then(/^(?:|I )should be on (.+)$/) do |step_string|
  page_name = step_string.match(/the (.+) page/)[1]
  puts page_name
  if page_name == 'Similar Movies'
    movie_title = step_string.match(/for "(.+)"/)[1]
    movie = Movie.find_by title: movie_title
    expect(page).to have_current_path(same_director_path(movie))
  else
    page_name = step_string
    current_path = URI.parse(current_url).path
    if current_path.respond_to? :should
      current_path.should == path_to(page_name)
    else
      assert_equal path_to(page_name), current_path
    end
  end
end
