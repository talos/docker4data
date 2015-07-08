## Docker4Data

How can we go from a system where working with large linked public data sets
takes weeks of onboarding to a few minutes?

Docker4Data is a system, requiring no commitment from government or other data
sources, that would massively speed up onboarding large linked public data
sets.

### Try it out

You'll need [Docker]() functioning on your system to get started.  Once that's
done, install is just one line:

    curl -s https://raw.githubusercontent.com/talos/docker4data/master/install.sh | bash

### Components

* Build Server: A build process that sucks in publicly available data and converts them according to a JSON specification into postgres dumps hosted on Docker Hub.  It is running constantly and keeps these dumps up to date.
   * An alpha version of this is finished and working.  It is not automatically building on a schedule, but it is able to pull, process, and push automatically when provided with the URL of a JSON specification.
   * Next steps:
      * Running a separate server where this is scheduled
      * Setting the server up to search for new JSON specifications, or allowing it to receive them from users
      * Enabling basic search/web interface to monitor the server (a la npm or docker hub)
* JSON Specification: A JSON specification that allows anyone to tell the build process about new data sets, as well as specify metadata, validation, and column + table links between different datasets.
   * An informal version of this spec is already in use for ACRIS.
   * Next steps:
      * Think about what else is “absolutely necessary” for the spec.
      * There are many things that could go in there, but hard to prioritize:
         * Data filtering features (use Gasket?)
         * Validation (metadata about size of rows?  Mapping existing metadata living remotely, like what length of table should be?)
         * SQL schema inside JSON
         * Pre-baked queries
         * Pre-packaging datasets together
      * Eventually formalize the spec.  Don’t want to do this too early.  How many services are actually built on JSON-LD or Google Public Data Explorer’s Dataset Publishing Language?
* CLI: A client CLI to interface with Docker, either locally or on a remote server, in order to allow end users to search for the data they want and pull it down.
   * This does not yet exist.
   * Next steps:
      * Build it!  Depends on interactions with the build server that don’t exist yet, but these could be mocked.  Could spec out the whole thing.
* Visualization: Pluggable visualization frontends for pulled data, using pre-canned queries defined in the specification.
   * This was mocked up for the pre-alpha ACRIS project.
   * Next steps:
      * Demonstrate Splunk functioning with Docker exposing psql-only
      * A Civomega front-end


### Examples

#### Build Server


    $ ./build.sh https://raw.githubusercontent.com/talos/docker4data/
    master/data/nyc_acris_parties/data.json


        Constructing data image based off of this data.json, pushing to
        thegovlab/docker4data-nyc_acris_parties

#### JSON Specification

    {
     "@id": "https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_acris_parties/data.json",
     "name": "nyc_acris_parties",
     "format": "csv",
     "data": {
       "@id": "http://www.opendatacache.com/data.cityofnewyork.us/api/views/636b-3b5g/rows.csv"
     },
     "after": [{
       "type": "postgres",
       "@id": "https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_acris_parties/index.sql"
     }],
     "schema": {
       "postgres": {
         "@id": "https://raw.githubusercontent.com/talos/docker4data/master/data/nyc_acris_parties/schema.sql"
       }
     }
    }

#### CLI

    $ data search property nyc
    1. nyc-acris-master [dataset]: NYC property transactions datin...
    2. nyc-acris-parties [dataset]: Names in NYC property transact...
    3. nyc-acris-legals [dataset]: Properties in NYC property tran...
    4. nyc-acris [data package]: Geographically enabled NYC transa...
    Which do you want to install?
    ^c


    $ data info nyc-acris
    nyc-acris: Geographically enabled NYC transactions dating from 1966 to the present.
    components: nyc-acris-master nyc-acris-parties nyc-acris-legals nyc-acris pluto
    last updated: February 12, 2015


    $ data install nyc-acris
    The following components will need to be installed requiring 17.4GB of disk space: pluto nyc-acris-master nyc-acris-legals nyc-acris-parties
    Are you sure? (y)
    > y
    Installing...
    ................................................
    Done! Installation took 3 minutes and 47 seconds.
    Data is accessible via postgres on port 54321 
    You can browse via psql:


        data browse nyc-acris


    $ data browse nyc-acris
    psql (9.3.5)
    Type "help" for help.

    postgres=#

#### Visualization
