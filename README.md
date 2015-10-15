# Scaffolding

Generate a rails scaffold from a CSV, Dat or Txt file and imports the data into your rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scaffolding'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scaffolding

## Usage

    $ rails g scaffolding [source] [name]

You can pass either a path/to/the/file or a URL as the [source].    

If a [name] is not passed, the scaffold will be named from the source:

    $ rails g scaffolding path/to/file.csv

Will generate a scaffold named file

    $ rails g scaffolding path/to/file.csv purchase_orders

Will generate a scaffold named purchase_orders


#### Multiple

To generate multiple scaffolds at the same time setup a scaffolding folder

    $ rake scaffolding:folder

then add files to the 'tmp/scaffolding' directory and process them all with:

    $ rails g scaffolding

The scaffold's will be named the same as there respective files names.

#### Options
(You will be asked these at the terminal if not specified)

Automatically determine the data types of each column:

    --auto

Migrate the database after the scaffold has been generated:

    --migrate

Import the data from the data source into the development database:

    --import

Example:

    $ rails g scaffolding --auto --migrate --import

#### Import file uploads

To import data from a file uploaded through the web browser:

    $ rake scaffolding:production

    $ rails s

Then go to http://localhost:3000/scaffolding/new

And upload the file you wish to import.

##### Hot Tips:
  This will only work if the file is named the same as the model.
  If the files are rather large use the activerecord-session_store gem: https://github.com/rails/activerecord-session_store

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jordan-deJong/scaffolding. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
