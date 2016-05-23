
## About
Rush Hour is a web traffic tracking and analysis tool that analyzes HTTP request information for clients.  It allows a client to gain information about their users, particularly, how the site is being used and accessed.   Allows a client to register their site, accepts client data via POST request to a dedicated endpoint, and provides analytics at site and individual URL level.  

## Tools Utilized

* Sinatra with a Postgres database
* ActiveRecord
* Cabybara for feature testing
* Bootstrap for styling

## Project Requirements

[Project Requirements ](https://github.com/turingschool/curriculum/blob/master/source/projects/rush_hour.md)

## Contributors

* Parker Phillips
* Brian Sayler
* Kerry Sheldon


## Basic Usage

##### 1. Seed Database

First start the server by running `shotgun` from the project root directory. To seed the development database, run the command `./test.sh` from the project root directory. If you don't have permissions to run the file, run `sudo chmod u+x test.sh` before `./test.sh`.

##### 2. Use Application

4 clients are loaded into the application from `test.sh`. To view a client's dashboard, navigate to the following links:

* `localhost:9393/sources/google`
* `localhost:9393/sources/jumpstartlab`
* `localhost:9393/sources/apple`
* `localhost:9393/sources/yahoo`

On each client page, you'll find a dashboard displaying summary statistics. Links to URL statistics are located in the "All requested URLs" table.
