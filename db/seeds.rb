# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed the RottenPotatoes DB with some movies.
more_movies = [
    {:title => 'My Neighbor Totoro', :rating => 'G',
      :release_date => '16-Apr-1988'},
    {:title => 'Green Book', :rating => 'PG-13',
      :release_date => '16-Nov-2018'},
    {:title => 'Parasite', :rating => 'R',
      :release_date => '30-May-2019'},
    {:title => 'Nomadland', :rating => 'R',
      :release_date => '19-Feb-2021'},
    {:title => 'CODA', :rating => 'PG-13',
      :release_date => '13-Aug-2021'}
  ]
  
  more_movies.each do |movie|
    Movie.create!(movie)
  end