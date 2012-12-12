frecklinghamster
================

A Rails app to export time tracking data from the Linux [Hamster](http://projecthamster.wordpress.com/) desktop software to the [Freckle](http://letsfreckle.com/) online service.

### Why

Hamster is a really nice and minimal piece of desktop software that I find ideal for tracking time on Linux.  However my company is using the, also very nice, online service Freckle to record the times of their employees.  I used to copy the time tracking data manually, but with FrecklingHamster it is so much easier.

In addition to that FrecklingHamster also gives you a nice additional perspective on your Hamster data and is very easy to extend, especially for web developers (because it's a plain Rails web app).

### How

Hamster stores it's data in a simple sqlite database and FrecklingHmaster is just a Rails app that accesses that database, displays it's content in the browser and allows exporting of individual or multiple time entries to Freckle using their [REST API](http://developer.letsfreckle.com/)

# Installation

#### Prerequisites

* git
* Ruby
* bundler

Installation should go as follows:

1. Clone the repository

    git clone git@github.com:jhilden/frecklinghamster.git

2. Install gem dependencies using Bundler

   cd frecklinghamster
   bundle install

3. Configure the path to the hamster database

   cp config/database.yml.example config/database.yml
  
   # entry for development database should be something like:
   database: /home/username/.local/share/hamster-applet/hamster.db

4. Configure Freckle API access

  cp config/initializers/freckle.rb.example config/initializers/freckle.rb

(fill with your respective data)

5. Migrate the database

   rake db:migrate

(this will add an `exported_at` column to the time entries in the database, to keep track of which entries have already been exported to Freckle)

6. Start the app/server

   rails s

7. Open the app in your browser

   http://localhost:3000/


