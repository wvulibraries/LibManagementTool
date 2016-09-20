# Lib Management Tool

The goal of this application is to create an application using a standard web framework so that it could be easily adopted by a community of schools and developers.   

  - hours (development)
  - directions (enhancement)
  - maps (enhancement)
  - available computers (enhancement)
  - directory (enhancement)

## Dependencies
  - CentOS 7.2
  - Vagrant / Virtual Box (For development)
  - Ruby Version (2.3.3)
  - Rails -v (5.0.0.1)
  - MySQL
  - Bundler

---

# Running in Vagrant Box

  - Clone the repo
  - Use the terminal to change directory into the cloned repo and do the command `vagrant up`
  - This will provision the box, but will not do everything you need to completed the setup so you will need to be inside of the box to continue.

### Vagrant SSH

  The following commands need to be done after entering `vagrant ssh` be sure that you are inside of your vagrant box.  
  - gem install bundler
  - gem install rails
  - gem install mysql

### Build the dependencies needed for the project
  - change directory in your vagrant box through vagrant ssh
  - bundle install

### Setup Databases
  - cd into /vagrant/bin/
  - run the command `rails db:reset`
  - followed by  `rails db:migrate`

### Run the Server
  - use `rails server` to boot server with vagrant by adding to the `config/boot.rb` file

  ```ruby
  require 'rails/commands/server'
  module Rails
    class Server
      def default_options
        super.merge(Host:  '0.0.0.0', Port: 3000)
      end
    end
  end
  ```

  - `rails server -b 0.0.0.0` this runs the rails server on an ip and helps to

# Deployment

# Customization

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
