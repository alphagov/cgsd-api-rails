# Government Service Data – API

This is the API for interacting with Government Service Data. It is currently consumed by the the [`gsd-view-data`](https://github.com/alphagov/gsd-view-data) application.

## Setup

First you need the Ruby version defined in [`.ruby-version`](https://github.com/alphagov/gsd-api/blob/master/.ruby-version) installed, which is currently `2.4.1`. It's easy to switch Ruby versions on demand with [`rbenv`](http://rbenv.org/), which you can do using [`Homebrew`](https://brew.sh/).

```
brew install rbenv
```

If you have rbenv installed, you can run

```
rbenv install 2.4.1
```

Next, you'll need [`Bundler`](http://bundler.io/) in order to install all the dependencies you'll need to run the app.

```
gem install bundler
```

Installing Bundler means that you have it for the current version of Ruby. If you ever switch Ruby versions, you'll need to re-install Bundler.
After bundle has been installed, install the dependencies for this application with

```
bundle
```

Once you have all the dependencies, you need to configure the database you will be using.  Copy config/database.yml.example to config/database.yml to use the suggested database name. Once you have done this you should run

```
bin/rails db:create db:migrate db:seed
```

To start the server.

1. You can check out [`Pow`](http://pow.cx/) for a really easy no-config server solution.
2. You can do the more conventional `rails -s` command. If you're already running another app on port 3000 (the API, for example), then pass in a new port number with `rails -s --port 3000`

You can test the server is up and running by visiting [http://127.0.0.1:3000/v1/data/government](http://127.0.0.1:3000/v1/data/government) or [http://gsd-api.dev/v1/data/government](http://gsd-api.dev/v1/data/government) if you are using [`Pow`](http://pow.cx/).


## Tests

To run tests, you should run

```
bin/rails spec
```

## Deployment

### Running Migrations

The migrations aren't automatically run by CI on deployment. To run all pending
migrations use the following:

    cf run-task gsd-api "cd app && bundle exec rake db:migrate" --name migrate

