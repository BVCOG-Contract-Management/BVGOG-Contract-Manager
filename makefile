run:
	rails s

database:
	rm -f ./db/development.sqlite3
	rm -f ./db/test.sqlite3
	rails db:create
	rails db:migrate
	rails db:seed

deploy:
	./script/deploy/deploy.sh
