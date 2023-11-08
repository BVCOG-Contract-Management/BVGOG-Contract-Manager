run: bundle
	rails s

clean:
	rm -f temp.*
	rm -f *.log

bundle:
	bundle install

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

cucumber: clean bundle
	bundle exec cucumber --profile default --out ./out.log

rspec: clean bundle
	bundle exec rspec spec

rubocop: clean bundle
	bundle exec rubocop --config .rubocop.yml --autocorrect-all