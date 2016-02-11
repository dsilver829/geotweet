# Geotweet
Geotweet filters tweets by location and search query.

## Back-End Architecture
The webapp uses [Ruby on Rails](http://rubyonrails.org/) for the web framework, and an [Elasticsearch](https://www.elastic.co/products/elasticsearch) instance for geohashing and querying.

A [deamon](https://github.com/thuehlinger/daemons) uses the [tweetstream gem](https://github.com/tweetstream/tweetstream) to continously stream tweets from Twitter's [Developer API](https://dev.twitter.com/), store them to the database, and index them in the Elasticsearch instance.

The Rails app uses the [Geocoder](http://www.rubygeocoder.com/) gem to identify the user's location.

#### Elasticsearch
Elasticsearch is the data store for the webapp.

The Rails app handles search requests by sending query and filter requests to the Elasticsearch instance. Elasticsearch uses the [geo point type](https://www.elastic.co/guide/en/elasticsearch/reference/1.4/mapping-geo-point-type.html), with [geohashing](https://www.elastic.co/guide/en/elasticsearch/guide/current/geohashes.html) enabled, to index tweets. 

To locate tweets within the bounds of a user's Google Map, the Rails app uses [geo bounding box filters](https://www.elastic.co/guide/en/elasticsearch/reference/1.4/query-dsl-geo-bounding-box-filter.html).

To group and count tweets by geographic location, the Rails app uses [geohash cell filters](https://www.elastic.co/guide/en/elasticsearch/guide/current/geohash-cell-filter.html). 

The app uses the [elasticsearch-persistence](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-persistence) gem with the ActiveRecord pattern. This pattern requires the Rails [ActiveRecord](http://guides.rubyonrails.org/active_record_basics.html) class, which in turn requires a database connection. Therefore the webapp maintains a connection to a PostgreSQL database, although it stores no data in that database.

## Front-End Architecture
The user interface relies on [Rails Ajax patterns](http://guides.rubyonrails.org/working_with_javascript_in_rails.html), [jQuery](https://jquery.com/), and the [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/).

#### Ajax
Every one second, the browser issues an Ajax request to the Rails app, asking for the newest tweets. 

If the browser boundaries change (i.e. zooming or panning), the browser sends the AJAX request immediately. 

If the user adds, removes, or changes a search query (e.g. "#2016"), the browser sends the AJAX request immediately.

#### Layout
The layout is structured with [Bootstrap](http://getbootstrap.com/), allowing for responsive, mobile-friendly design. The UI also uses many of Bootstrap's built-in CSS styles.

The webapp uses a combination of jQuery, CSS, and Bootstrap to implement highlighting and scrolling features.

## Test-Driven Development
I developed this Rails app using [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) with [RSpec](http://rspec.info/). I wrote both model and integration (feature) specs, using the ["Red, Green, Refactor"](https://www.google.com/search?client=ubuntu&channel=fs&q=red+green+refactor&ie=utf-8&oe=utf-8) pattern.

Capybara webkit is the driver for headless JavaScript testing. 

## Deployment
AWS hosts the webapp on a variety of services available as part of their [Free Tier](https://aws.amazon.com/free/).

I used [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) to create, configure, and deploy to the production environment. Elastic Beanstalk manages an AWS Elastic Compute Cloud([EC2](https://aws.amazon.com/ec2/)) instance of an [Ubuntu](http://www.ubuntu.com/) server, which hosts the Rails app.

The webapp uses a Postgres database hosted by AWS Relational Database Service ([RDS](https://aws.amazon.com/rds/)).

[AWS Elasticsearch Service](https://aws.amazon.com/elasticsearch-service/) provides the search instance and associated functions.

## Limits
The app uses geohash to divide the world into 156.5km x 156.5km grid cells ([geohash length 3](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-geohashgrid-aggregation.html)). For each grid cell, the app stores up to 250 tweets at a time, and deletes older tweets to make room for newer tweets.

At maximum utilization, I estimate this configuration will require ~1 GB of storage, which fits comfortably within the [AWS Free Tier](https://aws.amazon.com/free/):

150 trillion sq. m. (land surface area of earth) / 24.4 billion sq. m. (surface area of a grid cell) * 250 tweets * ~500 bytes (per tweet) = ~0.8 GB

This is the highest feasible resolution on the Free Tier. For example, geohash level 4 (39.1km x 19.5km) would require up to ~25 GB of storage.

## To Do
1. Implement access control on the AWS Elasticsearch Service instance.
2. Develop mocks for 3rd-party services (i.e. tweetstream) so the specs have fewer dependencies.
3. Improve the search feature to search all tweets (not just the ones on the map right now), and intelligently moves the map to the tweets.
4. Investigate avenues for accelerating the stream of tweets (e.g. obtain elevated access and use the 'count' parameter on the Twitter API to backfill on the fly).
