run: bundle
	rails s

clean:
	rm -f temp.doc
	rm -f temp.html
	rm -f temp.mp3
	rm -f temp.mp4
	rm -f temp.other
	rm -f temp.pdf
	rm -f temp.pptx
	rm -f temp.txt
	rm -f temp.xlsx
	rm -f temp.zip

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
	rails cucumber

rspec: clean bundle
	bundle exec rspec spec

rubocop: clean bundle
	rubocop --config .rubocop.yml --autocorrect-all
