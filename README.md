# [boatware](https://boatware3.dev): Drupal Project

> This project gives you a quick start to a new Drupal project. It includes all commonly used QA tools like PHPStan or Psalm but also a database dump if you want to start with a fully configured system.

> This README is a starting point for your project and not necessarily part of the project template.

# Table of contents

- [System requirements](#system-requirements)
- [Login](#login)
- [Changelog](#changelog)
- [Documentation](#documentation)
- [Setup](#setup)
- [Working on a project](#working-on-a-project)
- [Update Drupal](#update-drupal)
- [Included binaries](#included-binaries)
- [Common problems](#common-problems)
- [License](#license)
- [Contributing](#contributing)
- [Acknowledgements](#acknowledgements)
- [Contact](#contact)
- [Project status](#project-status)

# System requirements

- PHP >= 8.3
- MySQL >= 8 or MariaDB >= 10.2
- Apache >= 2.4 or Nginx >= 1.15
- Composer >= 2.0
- Node.js >= 16.0
- npm >= 7.0
- bun >= 1.0
- Git >= 2.0

## Server requirements

- PHP extensions:
  - ctype
  - curl
  - date
  - dom
  - filter
  - gd
  - hash
  - json
  - libxml
  - mbstring
  - openssl
  - pcre
  - pdo
  - phar
  - session
  - simplexml
  - spl
  - tokenizer
  - xml
  - xmlwriter
- RAM: 256 MB minimum, 512 MB recommended
- Disk space: 1 GB minimum, 2 GB recommended
- Apache modules:
  - mod_rewrite
- CPU: 2 core minimum, 4 cores recommended
- Plesk or similar highly recommended
- SSH access

### Recommended servers

- [dogado Cloud Server M 4.0](https://www.dogado.de/server/vserver) (or higher)

## For local development

- Docker (Desktop) >= 4.19
- Git >= 2.0
- Node.js >= 18.0
- npm >= 7.0
- bun >= 1.0

### Recommended

- PHP >= 8.3
- Composer >= 2.0

# Login

Passwords listed below are the default passwords for the default accounts. First step should be to change the password for every account.

Login via `/user/login` or `/user` (in the latter case you'll be redirected if you aren't logged in already).

| Username     | Password     | Description                                                           |
|--------------|--------------|-----------------------------------------------------------------------|
| admin        | admin        | Administrator account, only used by us                                |
| editor       | editor       | Editor account, most often used by customers                          |
| user-manager | user-manager | User manager account that can create, update and delete user accounts |
| api          | api          | API user account that can be used to authenticate against the API     |


# Changelog

You can find the changelog in the file [CHANGELOG.md](CHANGELOG.md).

# Documentation

You'll be able to find the documentation in this README file and in the [docs](./docs/index.md) directory.

# Setup

> If you are working on an existing project, you can skip this section.
> Alternatively, you can also just delete this section from the customers project documentation since it's not needed anymore.

## Requirements

- [Lando](https://docs.lando.dev/getting-started/installation.html)
- [Composer](https://getcomposer.org/download/)* >= 2.0.0
- [PHP](https://www.php.net/downloads.php)* >= 8.1

*\* Only needed if you want to run commands like `composer install` locally. With Lando you also can run such commands inside Lando by prefixing the commands with `lando`.*

## 1. Copy the repository

The composer way means that you install the project template with the `composer create-project` command.

You can create the project by running the following command in your terminal:
```shell
$ composer create-project boatware/drupal-project PROJECT_NAME
```

With this step you can skip step 2 since the `create-project` command will already install dependencies and run the `bin/setup` binary for you.

## 2. Install dependencies

To install all dependencies, run the following command in your terminal:
```shell
$ composer install
```

When creating a new project, this command will also run the binary `bin/setup` which will do some setup steps for you. After that you can delete that file since it won't be used anymore.

## 3. Unpack media files

To unpack the media files, run the following command in your terminal:
```shell
$ tar -xzf sites-default-files.tar.gz
```

This command will put the pre-saved files into the correct directory.

## 4. Setup environment

To get the project running, you need to provide at least database credentials.

For this, this template provides an `.env` file which should have been created by the `bin/setup` command. If not, you can create it manually by copying the `.env.example` file.

The default credentials are as follows:
```dotenv
# Database credentials
MYSQL_HOSTNAME='database'
MYSQL_USER='drupal10'
MYSQL_PASSWORD='drupal10'
MYSQL_DATABASE='drupal10'
MYSQL_PORT='3306'
```

If you choose to use another environment, for example Homestead, you need to adjust these values according to your development environment.

## 5. Setup Lando (optional)

> If you are not using Lando as development environment, you can skip this step.

Before you can start Lando for the first time, you need to adjust the project name in the `.lando.yml` file. Per convention, you name it after the directory you're in.

## 6. Setup Deployment

Since the first thing you do after a fresh install is to setup the deployment. This way we don't need to store any database dumps inside the repository.

To setup the deployment, remove the file `deploy.php` if it exists, copy the file `deploy.dist.php` to `deploy.php` and adjust the values according to your needs.

:warning: **Make sure to check the `deploy.php` file after you're done! The project template is set up to be deployed to its own hosts.**

## 7. Start Environment

To start the environment, run the following command in your terminal:
```shell
$ make start
```

## 8. Install Drupal

Grab the current database dump from the server that serves the current state of the project and import it into your local database. You can do this by running the following command in your terminal:

```shell
$ docker compose run --rm database mysql -udrupal -pdrupal drupal < DUMPFILE.sql
```

Make sure to apply the latest configuration changes by running the following command in your terminal:
```shell
$ bin/drush cim
```

Then clear the cache by running the following command in your terminal:
```shell
$ bin/drush cr
```
This ensures that the configuration is up-to-date since the database dump might be a bit older.

## 9. Download files directory

To have the uploaded media files for the imported content on your local environment, login to the server via SSH and run the following command in your terminal:
```shell
$ cd PROJECT_ROOT && tar -czf files.tar.gz web/sites/default/files
```
where `PROJECT_ROOT` is the path to the project root directory (not the document root `/web`).

Then download the file to your local machine and unpack it.

One way to do this is to run the following command in your terminal:
```shell
$ scp USER@HOST:PATH/TO/files.tar.gz .
# e.g. scp user@host:/path/to/files.tar.gz .
```
where `USER` is the SSH user, `HOST` is the SSH host and `PROJECT_ROOT` is the path to the project root directory (not the document root `/web`).

Then unpack the file by running the following command in your terminal:
```shell
$ tar -xzf files.tar.gz
```

> Make sure to delete the `files.tar.gz` file on the server and locally after you're done.

## 10. Aftercare

After the installation is done, you can deploy the freshly created project to a staging server. For this to work properly you need to follow these steps:

- Setup staging environment (database, webserver, etc.)
- Export configuration from the local environment via `lando drush cex`
- Export database from the local environment via `lando db-export`
- Import database to staging environment
- Upload files directory to staging environment

Now you can deploy the project by running
```shell
$ vendor/bin/dep deploy stage
```

Some additional steps you might want to do:
- Delete this setup section from the README
- Rename the following section to be just "Setup"
- Replace PROJECT_URL with the actual SSH URL of the repository

# Setup (existing project)

## Requirements

- [Lando](https://docs.lando.dev/getting-started/installation.html)
- [Composer](https://getcomposer.org/download/)* >= 2.0.0
- [PHP](https://www.php.net/downloads.php)* >= 8.1

*\* Only needed if you want to run commands like `composer install` locally. With Lando you also can run such commands inside Lando by prefixing the commands with `lando`.*

## 1. Copy the repository

To get the latest version of the project, create a new directory first:
```shell
$ mkdir PROJECT_NAME
```

Then clone the project into the current directory by executing the following command in your terminal:
```shell
$ git clone PROJECT_URL PROJECT_NAME
```

## 2. Install dependencies

To install all dependencies, run the following command in your terminal:
```shell
$ composer install
```

## 3. Setup environment

To get the project running, you need to provide at least database credentials.

For this, copy the `.env.example` file and name it `.env`. Then adjust the values according to your needs.

The default credentials are as follows:
```dotenv
# Database credentials
MYSQL_HOSTNAME='database'
MYSQL_USER='drupal10'
MYSQL_PASSWORD='drupal10'
MYSQL_DATABASE='drupal10'
MYSQL_PORT='3306'
```

When working in another environment than Lando, you need to adjust these values according to your development environment.

## 4. Start Lando

To start Lando, run the following command in your terminal:
```shell
$ lando start
```

The first time will take a while since Lando needs to build the containers, so go and get yourself a coffee.

## 5. Import database

If the system has been deployed anywhere get the database dump:
- If the system has been deployed into a production environment, get the database from there
- If the system has been deployed into a staging environment, get the database from there
- If the system has not been deployed yet, reach out to the documentation or ask the developer who set this project up

Then import the database into your local environment by running the following command in your terminal:
```shell
$ lando db-import DATABASE_DUMP
```

## 6. Import configuration

Make sure you have the latest configuration changes in your environment by running the following command in your terminal:
```shell
$ lando drush cim
```

## 7. Clear cache

To make sure everything is working properly, clear the cache by running the following command in your terminal:
```shell
$ lando drush cr
```

## 8. Validate environment

To finish the local setup you should check the following:
- The project is running on the correct URL (ending with `.lndo.site` by default)
- You can log in with the default credentials (admin / admin or the credentials stored in Keeper)
- You can access the admin area
- There is a file called `settings.local.php` in the `web/sites/default` directory
- The file `development.services.yml` in the `web/sites` directory contains the following:
```yaml
parameters:
  http.response.debug_cacheability_headers: true
  twig.config:
    debug: true
    auto_reload: true
    cache: false
```

# Working on a project

While working on a project, you should follow some conventions to make sure that everything is working properly and that
we maintain our standards.

## Commit messages

Commit messages should be written in English and follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard.

For example:
```
feat: add new feature
```

If you're working on a Jira ticket or a GitHub issue, you should reference the ticket in the commit message:
```
feat: add new feature (ISSUE-123)
```

## Branch names

Branch names should be written in English and follow the [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) standard.

Some notable caveats:
- When merging `develop` into `main` *all* features merged into `develop` will be deployed to production afterwards (or at least they're ready to be deployed). This behavior may conflict with the customers expectations, so make sure to communicate this to the customer. The customer may expect only feature A to be deployed to production but is testing feature B internally. The customer needs to be aware that feature B will be deployed to production as well. To prevent that, you need to create a software switch for feature B (by creating a configuration for example) and disable it on the production environment.

## Drupal Coding Standards

Make sure to follow the Drupal coding standards. You can check your code by running the following command in your terminal (either locally or from within your environment):
```shell
$ bin/phpcs
```

## Naming conventions

- Modules made for the individual project start with the customers name (e.g. `customer_xy_` or `mysite_`)
- Same goes for themes and profiles

## Structural conventions

### Modules

- Modules should be placed in the `web/modules/custom` directory (only modules loaded via Composer will take place in `web/modules/contrib`)
- Services should be placed in the namespace `Drupal\PROJECT_NAME\Service` - thus a directory `web/modules/custom/PROJECT_NAME/src/Service` is needed
- Controllers should be placed in the namespace `Drupal\PROJECT_NAME\Controller` - thus a directory `web/modules/custom/PROJECT_NAME/src/Controller` is needed
- Forms should be placed in the namespace `Drupal\PROJECT_NAME\Form` - thus a directory `web/modules/custom/PROJECT_NAME/src/Form` is needed
- Rule of thumb: Place classes in directories determining their type, e.g. `web/modules/custom/PROJECT_NAME/src/Service/MyService.php` for a service class or `web/modules/custom/PROJECT_NAME/src/Controller/MyController.php` for a controller class

### Themes

- Themes should be placed in the `web/themes/custom` directory (only themes loaded via Composer will take place in `web/themes/contrib`)
- For automation purposes you should provide an entry in the `scripts` section of the `package.json` file if the frontend code needs some extra treatments (e.g. compiling SCSS to CSS)

### Classes

- Controllers are only meant for routing requests, any logic should be placed in a service
- Use dependency injection wherever possible (you need to in order to follow the Drupal Best Practice coding standard)
- Avoid monolithic classes and methods, split your code into several classes and methods to make it more readable and maintainable. This way you follow the [Single Responsibility Principle](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design-de#single-responsibility-prinzip) and the [Open/Closed Principle](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design-de#open-closed-prinzip)
- Entity classes should have getters and fluent setters for every defined field. In Drupal this is a bit harder than in Symfony but this makes sure you don't need to lookup any field names and can instead leverage the autocomplete feature of your IDE.

## Commit frequency

Commit often and commit early. This way you can easily revert changes, and you can easily track down bugs.

## Changelog

Whenever you do add, change or replace something, make sure to add a changelog entry. This way you can easily track down changes and communicate them to the customer.

You should follow the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standard.

**Important**: Don't add entries for every single commit. Instead, add entries for every real change. You may work on an addition, removal or change in over 10+ commits, but you should only add one entry to the changelog.

# Update Drupal

To update the Drupal core, all contributed projects (modules, themes, etc.) and their dependencies, you can either choose the semi automatic way by running a single command or the manual way by running all necessary commands one by one.

## Semi automatic

To update Drupal to the latest minor version run the following command in your terminal:
```shell
make update
```

This command executes the same commands as the manual way but in a single command.

## Manual

> Note: All commands below utilize the `docker compose run` command. If you prefer doing this on your local machine or any other setup, adjust the commands to your needs.

In order tpo update Drupal you need to fetch the latest compatible version of the Drupal core and all contributed projects by executing the following command in your terminal:
```shell
$ docker compose run --rm php composer update --with-all-dependencies
```

The next step is to update the database by running the following command:
```shell
$ docker compose run --rm php drush updb
```

Since the database update may change configuration files, you need to export the configuration by running the following command:
```shell
$ docker compose run --rm php drush cex
```

Finally, you only should clear the cache by running the following command:
```shell
$ docker compose run --rm php drush cr
```

Now you can check the project for any errors, commit every changed file and push the updates.

# Included binaries

All binaries described below are located at `./bin`.

## `lint-php` - PHP Linter

Lints all PHP files in the `./web/modules/custom` and `./web/themes/custom` directories to find syntax errors.

### Usage

```shell
$ bin/lint-php
```

## `phpcs` - PHP Code Sniffer

Detect issues with code style and formatting in the `./web/modules/custom`, `./web/themes/custom` and `./web/profiles/custom` directories.

The standard that is being used is the Drupal coding standard. Have a look at the [Drupal coding standards](https://www.drupal.org/docs/develop/standards/coding-standards) for more information.

### Usage

To check for issues, run the following command in your terminal:
```shell
$ bin/phpcs
```

## `phpstan` - PHP Static Analysis Tool

Detects possible errors in the `./web/modules/custom`, `./web/themes/custom` and `./web/profiles/custom` directories.

The level that is being used is level 8. Have a look at the [configuration](./phpstan.dist.neon) for more information.

### Usage

```shell
$ bin/phpstan
```

# Common problems

## 1. Deployer throws an error at the `deploy:lock` step

The error message looks like this:
```shell
$ vendor/bin/dep deploy <HOST>
task deploy:info
[stage] info deploying develop
task deploy:lock
[stage]  error  in lock.php on line 9:
[stage] run [ -f <DEPLOY_PATH>/.dep/deploy.lock ] && echo +locked || echo 'YOUR NAME' > <DEPLOY_PATH>/.dep/deploy.lock
[stage] err bash: line 1: <DEPLOY_PATH>/.dep/deploy.lock: No such file or directory
[stage] exit code 1 (General error)
task deploy:failed
task deploy:unlock
```

This happens when the `deploy.lock` file is not present on the server. To fix this, make sure the `deploy:prepare` step is being executed on deployment. This step ensures the directory structure and that the `deploy.lock` file can be created.

## 2. Deployer throws an error at the `deploy:update_code` step

The error message looks like this:
```shell
The command "git archive --remote GIT_URL --format tar BRANCH | (cd DEPLOYMENT_DIR && tar xf -)" failed.

  Exit Code: 2 (Misuse of shell builtins)

  Host Name: stage

  ================
  Permission denied, please try again.
  Permission denied, please try again.
  Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
  fatal: The remote end hung up unexpectedly
```

When this error occurs there may be one of the following reasons:
- Your SSH key is not added to the server
  - To fix this, add your SSH key to the server by running the following command in your terminal:
  ```shell
  $ ssh-copy-id <SSH_USER>@<SSH_HOST>
  ```
- Your SSH key is not added to the GitLab/GitHub/etc. instance
  - To fix this, add your SSH key by going to the SSH keys section at the settings of your used Git host and adding your SSH key
- You're working on a Mac and the SSH key is not added to the keychain
  - To fix this, add your SSH key to the keychain by running the following command in your terminal:
  ```shell
  $ ssh-add --apple-use-keychain
  ```

# License

Since Drupal itself is licensed under the [GNU General Public License](https://www.gnu.org/licenses/gpl-2.0.html), this project is licensed under the same license.

# Contributing

# Acknowledgements

# Contact

# Project status

---
(c) 2024 [Thomas Artmann](https://boatware3.dev)
