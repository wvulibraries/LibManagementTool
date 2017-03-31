# Lib Management Tool

[![Build Status](https://travis-ci.org/wvulibraries/LibManagementTool.svg?branch=master)](https://travis-ci.org/wvulibraries/LibManagementTool)]![Coverage Status](/coverage/coverage.jpg?raw=true)

The goal of this application is to create an application using a standard web framework so that it could be easily adopted by a community of schools and developers.   

  - hours (development)
  - directions (enhancement)
  - maps (enhancement)
  - available computers (enhancement)
  - directory (enhancement)
  - application auth (enhancement)

## Dependencies
  - CentOS 7.2
  - Vagrant / Virtual Box (For development)
  - Ruby Version (2.3.3)
  - Rails -v (5.0.0.1)
  - MySQL
  - Bundler



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

---
# LOCAL DEVELOPMENT

Can be done using vagrant or docker.  

## Vagrant

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

You may need to switch the database.yml depending on the last contributor or, if they database.yml was ever checked into the document.

```yml
  default: &default
    adapter: mysql2
    encoding: utf8
    pool: 5
    username: root
    password:
    socket: /var/lib/mysql/mysql.sock

  development:
    <<: *default
    database: LibraryManagementTool_development

  test:
    <<: *default
    database: LibraryManagementTool_test
```

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

- `rails server -b 0.0.0.0` this runs the rails server on an ip and helps to work with vagrant

## DOCKER
 - Download Docker for your OS
 - Clone the repo
 - cd into the repo and run `docker-compose up -d --build`
 - run the following command to open the container for interactive mode `bash -c "clear && docker exec -it LibraryManagementTool sh"`

### Changing the databases for Docker
-  Copy this snippet into your `config/database.yml`
    ```yml
      default: &default
        adapter: mysql2
        encoding: utf8
        username: root
        password:
        host: db

      development:
        <<: *default
        database: LibraryManagementTool_development

      test:
        <<: *default
        database: LibraryManagementTool_test
    ```
 - run the following commands bin/rails `db:create && bin/rails db:migrate && bin/rails db:seed`
 - if you need to restart the web server this is done automatically by restarting the container


 # TRAVIS CI For Testing

 Make sure your database.yml looks like
 ```yml
 test:
   adapter: mysql2
   username: travis
   encoding: utf8
   database: LibraryManagementTool_test
 ```
---
