run: bundle
	rails s

clean:
	rm -f temp.*
	rm -f *.log
	rm -f ./log.json

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
	bundle exec cucumber --publish-quiet --profile default --format json --out ./log.json

rspec: clean bundle
	bundle exec rspec spec

rubocop: clean bundle
	bundle exec rubocop --config .rubocop.yml --autocorrect-all
