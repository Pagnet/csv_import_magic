# CsvImportMagic

## Getting started

CSV Import Magic works with Rails 4.1 onwards. You can add it to your Gemfile with:

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
$ rails generate csv_import_magic MODEL
```

Next, check the MODEL. This add into `app/csv_parsers`, parser of model and [relation into model](#configuring-models).

Then run `rake db:migrate`

### Configuring Models

The Csv Import Magic method in your models accepts only symbol with options to configure its parsers. For example:

```ruby
csv_import_magic :your_parser_name
```

### Parsers

See more example [here](https://github.com/pcreux/csv-importer#usage-tldr)

### Configuring views

We built CSV Importer view to help you quickly develop an application that uses importer. However, we don't want to be in your way when you need to customize it.

```console
$ rails generate csv_import_magic:views scope -i importable
```

If need specify scope.
Scope is name of folder views inside `app/views`.
This options `-i` add importable value into form.

### CSV Importer

CSV Import Magic is based on csv-importer. We encourage you to read more about csv-importer here:

https://github.com/pcreux/csv-importer

## License

MIT License. Copyright 2017 Pagnet.

You are not granted rights or licenses to the trademarks of Pagnet, including without limitation the CSV Importer Magic name.
