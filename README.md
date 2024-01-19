# README
This project aims to target the following: 

1. Ruby on Rails application using PostgreSQL as the database.
2. Maintaining a list of 20 locations across India along with their location info - latitude, longitude.
3. Utilizing the OpenWeatherMap Air Pollution API to fetch current air pollution data for the locations.
4. Creating an importer to parse and save the fetched data into the database, including air quality index (AQI), pollutant concentrations, and location details.
5. Implementing a scheduled task to run the importer every 1 hour used Sidekiq (for demo purposes time interval is set to every 30s)
6. Use RSpec to write unit tests for the application (Used minitest instead)
7. Write queries to:
   a. Calculate the average air quality index per month per location.
   b. Calculate the average air quality index per location.
   c. Calculate the average air quality index per state.
8. Three apis from Openweathermap has been used
   1. OpenWeatherMap Air Pollution API https://openweathermap.org/api/air-pollution
   2. OpenWeatherMap Air Pollution History API https://openweathermap.org/api/air-pollution#history
   3. OpenWeatherMap Geocoding API https://openweathermap.org/api/geocoding-api
   
* Ruby version - ruby 3.0.2p107
* Rails version - rails 7.1.2

### Prerequisites
  - Ubuntu 20.04 +
  - Ruby 3.0 +

### How to Clone the repo
   - Fork the Repository
   - Clone your fork - git clone https://github.com/[your_username]/repository.git

### Getting Started
  - Clone the git repo
  - Once ruby and rails is setup on your system, install redis as well
  - sudo apt-get install redis (to install redis locally)
  - Run - bundle install/update to install all the gems
  - Create a standard postgres database, a user role and a password from the psql console
      - CREATE DATABASE your_database;
      - CREATE USER your_user WITH PASSWORD 'your_password';
      - GRANT ALL PRIVILEGES ON DATABASE your_database TO your_user;
      - \q to exit console
      - psql -U your_user -d your_database
  - Change the credentials in the database.yml file as per your new credentials
  - Run rake **db:migrate** to initialize the database for the RoR application

  ### Runnig the application
   - Once the basic setup and installation of the gems, redis and postgres is done, follow the below steps
   - run **rake db:seed** to populate the databse with some dummy cities, the seeds code use the GEOCODING API
   - Open 3 seperate terminals for 3 servers Rails, Redis and Sidekiq
   - Rails Server : rails s (in terminal 1)
   - Redis : redis-server (in terminal 2)
   - Sidekiq: **bundle exec sidekiq -C config/sidekiq.yml** (in terminal 3)

   ### About the tasks and background jobs
   - **Note**- there are 2 tasks that are timed for 30seconds and 1 hour, feel free to change the time intervals using CRON * /30 * * * * * or time notation e.g. 1m or 2h
   - Sidekiq server will keep running in the background and process 2 tasks every 30seconds and 1 hour
   - **Note** - Only 1000 api calls are allowed in total per day
   - To run the unit tests - cd into the project folder and run **bundle exec rspec**

  ### Use the application on web
    - Go to http://localhost:3000/locations on a browser
    - The simple UI will help you guide through the application

### About the Importers
    - The application has 2 importer services **AirQualityImporter** and **AirQualityImporterHistoric**
    - Both the importers use ETL style for the Openweathermap APIs (fetch, transform and save)
    - Each importer calls their respective APIs AIR_QUALITY_API and HISTORIC_AIR_QUALITY_API

### About the DB
   - The database consits of 3 relations Location, PollutionConcentraion and HistoricDataRecords
   - Both PollutionConcentraion and HistoricDataRecords have a one-many relation with Location indexed on location_id

