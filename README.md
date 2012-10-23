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

1. Install postgreSQL 8.3 or later

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

### Ruby

* Currently only supports ruby 1.8.7

### GEMS

1. Configure PostgreSQL adapter

    For Mac ensure `PGHOME/bin` is in path then:

        $ export ARCHFLAGS="-arch x86_64"

2. Install bundler

        $ gem install bundler

3. Install bundle

        $ bundle install

### BUILD TARGETS

* *Exercise all migrations and prepare test database:* `$ rake db:reset_and_prepare`

* *Developer full-build:* `$ rake dev`

    Performs migrations and executes behaviors

* *CI full-build:* `$ rake ci`

    Developer build with metrics checks and build report generation

* *Behavior build:* `$ rake spec` or `$ rake spec:rcov`

* *Source code metrics analysis:* `$ rake metrics`
  