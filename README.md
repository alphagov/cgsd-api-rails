# Service Performance

This is the application for interacting with Service Performance data. It contains:

- the application frontend for viewing metrics
- the publishing workflow for collecting metrics from Services
- an admin interface to coordinate data collection

## Setup

You must install the version of Ruby defined in [`.ruby-version`](https://github.com/alphagov/service-performance/blob/master/.ruby-version). 

You can easily switch between Ruby versions with [`rbenv`](http://rbenv.org/), which you can install using [`Homebrew`](https://brew.sh/):

```
brew install rbenv
```

For example, if you have installed `rbenv`, you can run:

```
rbenv install 2.4.2
```

You will also need [`Bundler`](http://bundler.io/) in order to install all the application's dependencies.

```
gem install bundler
```

You should note that each time you install Bundler, you will have it available for your current version of Ruby. If you ever switch Ruby versions, you will need to reinstall Bundler.

After installing Bundler, you can install the dependencies for the application with:

```
bundle
```

You then need to configure the database you will be using.  

Copy `config/database.yml.example` to `config/database.yml` to use the example database name, then run:

```
bin/rails db:create db:migrate db:seed
```

To start the server, use the conventional `rails -s` command. 

If you are already running another app on port 3000, then pass in a new port number with `rails -s --port <NEW NUMBER>`

You can test the server is running by visiting [http://127.0.0.1:3000/](http://127.0.0.1:3000/) in a web browser.

## Tests

To run tests, you should run:

```
bin/rails spec
```

## Deployment

### Running Migrations

Migrations are not run automatically by CI on deployment. To manually run all pending
migrations, you must run:

```
cf run-task service-performance "cd app && bundle exec rake db:migrate" --name migrate
```

### Staging

Deployments are initiated by merging `master` into `staging`, and then by pushing the `staging` branch.

## Tests

### Frontend test setup

Make sure you have [`npm`](https://www.npmjs.com/get-npm) installed, as well as a recent version of [`node`](https://nodejs.org/en/).

You can use to install and manage different versions of `node` using [`nvm`](https://github.com/creationix/nvm#installation). 

To install a version of `node` using `nvm`, you should only need to run (for example):

```
nvm install 6.11.0
```

There is [an `.nvmrc` file](https://github.com/creationix/nvm#nvmrc) in the root directory of this repository that `nvm` will recognise when you call certain commands (such as `nvm use`) without arguments.

To install the frontend dependencies, run:

```
npm install
```

### Frontend tests

#### linting

[GDS](https://github.com/alphagov/styleguides/blob/master/js.md#linting) uses [`standardjs`](https://standardjs.com/):

```
npm run lint
```

This command will lint the JavaScript files it finds in the `app/assets/javascripts/*` directory. It will return npm error traces and plain-English error messages. 

#### unit tests

GDS uses [Jest](https://facebook.github.io/jest/) for JavaScript unit tests:

```
./script/run-npm-test
```

This command will run any JavaScript test files it finds across the whole codebase.

### Installing capybara-webkit

The `capybara-webkit` gem relies on `qt v5.5`. To install the gem:

```
brew install qt@5.5
export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
bundle install
```
