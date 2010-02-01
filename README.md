Shrink - BDD artifact management tool
=====================================

A conventional Rails application managing BDD artifacts, currently limited to Cucumber features.

Highlights
----------

* Manage features, scenarios, steps
* Step fit table support
* Step auto-completion based on existing steps
* Organize features into folders
* Tag features
* Full-text search across features
* Manage feature projects

For a full-set of requirements see the [http://www.pivotaltracker.com/](http://www.pivotaltracker.com/) _Platter_ project.

Development Installation instructions
-------------------------------------

### DATABASE

1. Install postgreSQL
For Mac see [http://developer.apple.com/internet/opensource/postgres.html](http://developer.apple.com/internet/opensource/postgres.html)

2.  Configure UTF8 encoding
Change template1 template database - instructions taken from [http://www.postgresql.org/docs/8.1/interactive/manage-ag-templatedbs.html](http://www.postgresql.org/docs/8.1/interactive/manage-ag-templatedbs.html)

        $ psql -U postgres template1
        # UPDATE pg_database SET datallowconn = TRUE where datname = 'template0';
        # \c template0
        # UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';
        # drop database template1;
        # create database template1 with template = template0 encoding = 'UNICODE';
        # UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';
        # \c template1
        # UPDATE pg_database SET datallowconn = FALSE where datname = 'template0';

3. Create users

        $ createuser --createdb --pwprompt shrink_dev
        $ createuser --createdb --pwprompt shrink_test

See `config/database.yml` for exact details

4. Create development database

        $ createdb --owner=shrink_dev shrink_dev

5. Populate development database and create test database

        $ rake db:reset_and_prepare

### GEMS

* Install rack

        $ sudo gem install rack --no-ri --no-rdoc --version=1.0.1

* Install postgreSQL adapter
For Mac ensure `PGHOME/bin` is in root path then

        $ sudo su -
        $ export ARCHFLAGS="-arch x86_64"
        $ sudo gem install pg --no-ri --no-rdoc

* Install build specific gems

    $ sudo gem install rspec --no-ri --no-rdoc --version=1.2.9
    $ sudo gem install rspec-rails --no-ri --no-rdoc --version=1.2.9
    $ sudo gem install reek --no-ri --no-rdoc
    $ sudo gem install roodi --no-ri --no-rdoc
    $ sudo gem install rcov --no-ri --no-rdoc

### BUILD TARGETS

Full build: Performs migrations, metrics checks and executes behaviors

    $ rake dev

Behavior build:

    $ rake spec

or

    $ rake spec:rcov

Source code metrics analysis:

    $ rake metrics
  