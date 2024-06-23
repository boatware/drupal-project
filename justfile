#theme-install:
#	cd web/themes/custom/THEME && bun install

#theme-build:
#	cd web/themes/custom/THEME && bun run build

cache:
	docker compose run --rm php drush cr

theme: cache

update:
	docker compose run --rm php composer update -W
	docker compose run --rm php drush updb -y
	docker compose run --rm php drush cr
	docker compose run --rm php drush cex -y

deploy:
	vendor/bin/dep deploy live

build:
	docker compose build

start:
	docker compose up -d

stop:
	docker compose down

install:
	docker compose run --rm php composer install
