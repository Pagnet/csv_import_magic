# CsvImportMagic

[![Build Status](https://travis-ci.org/Pagnet/csv_import_magic.svg?branch=master)](https://travis-ci.org/Pagnet/csv_import_magic)
[![Gem Version](https://badge.fury.io/rb/csv_import_magic.svg)](https://badge.fury.io/rb/csv_import_magic)
[![Code Climate](https://codeclimate.com/github/Pagnet/csv_import_magic/badges/gpa.svg)](https://codeclimate.com/github/Pagnet/csv_import_magic)

## Getting started

CSV Import Magic works with Rails 5.2 onwards. You can add it to your Gemfile with:

```ruby
gem 'csv_import_magic'
```

Then run `bundle install`

Next, you need to run the generator:

```console
$ rails generate csv_import_magic:install
```

The generator will install an initializer, add route and migration in your application. When you are done, you are ready to add CSV Import Magic to any of your models.

```console
$ rails generate csv_import_magic MODEL -c foo bar
```

MODEL is scope, scope is model you have add `csv_import_magic` method.
Options `--columns` or `-c` is required.
Columns are attributes you want parse by model.
And add into `app/csv_parsers`, parser of model with relation with columns, [read more.](#configuring-models).

Then run `rake db:migrate`

### Configuring Models

The Csv Import Magic method in your models accepts only symbol with options to configure its parsers. For example:

```ruby
csv_import_magic :your_parser_name
```

### Parsers

See more example [here](https://github.com/pcreux/csv-importer#usage-tldr)

### Configuring views

We built CSV Importer view to help you quickly develop an application that uses importer.
However, we don't want to be in your way when you need to customize it.

```console
$ rails generate csv_import_magic:views scope -i importable
```

If need specify scope.
Scope is name of folder views inside `app/views`.

### Configuring base controller

We built CSV Importer base controller to help you quickly develop.
However, we don't want to be in your way when you need to customize it.

```console
$ rails generate csv_import_magic:controllers
```

### I18n

See our wiki page([I18n](https://github.com/Pagnet/csv_import_magic/wiki/I18n)).
If your language not translated yet, send your yaml to append in our wiki, we appreciate your contribution.

### Development

To run tests you should first configure it's database and dependencies with:

```console
$ bundle install && bundle exec rake db:schema:load
```

Then run specs with:

```console
$ bundle exec rspec
```

### CSV Importer

CSV Import Magic is based on csv-importer. We encourage you to read more about csv-importer here:

https://github.com/pcreux/csv-importer

## License

MIT License. Copyright 2017 Pagnet.

You are not granted rights or licenses to the trademarks of Pagnet, including without limitation the CSV Importer Magic name.
