run:
	bundle install
	rails s

database:
	rm -f ./db/development.sqlite3
	rm -f ./db/test.sqlite3
	rails db:create
	rails db:migrate
	rails db:seed

heroku_db:
	heroku run rails db:migrate
	heroku run rails db:seed

deploy:
	./script/deploy/deploy.sh

cucumber:
	bundle install
	rails db:drop RAILS_ENV=test
	cucumber

rspec:
	rspec
