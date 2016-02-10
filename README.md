# GeoTweet
Geotweet filters tweets by location and search query.

## Back-End Architecture
The webapp uses [Ruby on Rails](http://rubyonrails.org/), a [PostgreSQL database](http://www.postgresql.org/), and an [Elasticsearch](https://www.elastic.co/products/elasticsearch) instance for geohashing and querying.

A deamon (stored in the lib/ directory) uses the [tweetstream gem](https://github.com/tweetstream/tweetstream) to continously stream tweets from Twitter's [Developer API](https://dev.twitter.com/), store them to the database, and index them in the Elasticsearch instance.

The Rails app uses the [Geocoder](http://www.rubygeocoder.com/) gem to identify the user's initial location.

### Elasticsearch
The Rails app handles search requests by issuing queries and filters to the Elasticsearch instance. The webapp indexes the tweets with the [geo point type](https://www.elastic.co/guide/en/elasticsearch/reference/1.4/mapping-geo-point-type.html), with [geohashing](https://www.elastic.co/guide/en/elasticsearch/guide/current/geohashes.html) enabled. 

To locate tweets within the bounds of the Google Map, the Rails app uses [geo bounding box filters](https://www.elastic.co/guide/en/elasticsearch/reference/1.4/query-dsl-geo-bounding-box-filter.html).

To group and count tweets by geographic location, the Rails app uses [geohash cell filters](https://www.elastic.co/guide/en/elasticsearch/guide/current/geohash-cell-filter.html). 

## Front-End Architecture
The user interface relies on [Rails Ajax patterns](http://guides.rubyonrails.org/working_with_javascript_in_rails.html), [jQuery](https://jquery.com/), and the [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/).

Every one second, the browser issues an Ajax request to the Rails app, asking for the newest tweets. If the browser boundaries change (zooming or panning), the browser sends the AJAX request immediately. If the user adds, removes, or changes a search query (e.g. "#2016"), the browser sends the AJAX request immediately.

### Layout
The layout is structured with [Bootstrap](http://getbootstrap.com/), allowing for responsive, mobile-friendly design. The UI also uses many of Bootstrap's built-in CSS styles.

The webapp uses a combination of jQuery, CSS, and Bootstrap to implement highlighting and scrolling features.

## Deployment
AWS hosts the webapp on a variety of services available as part of their [Free Tier](https://aws.amazon.com/free/).

I used [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) to create, configure, and deploy to the production environment. Elastic Beanstalk manages an AWS Elastic Compute Cloud([EC2](https://aws.amazon.com/ec2/)) instance of an [Ubuntu](http://www.ubuntu.com/) server, which hosts the Rails app.

The webapp uses a Postgres database hosted by AWS Relational Database Service ([RDS](https://aws.amazon.com/rds/)).

[AWS Elasticsearch Service](https://aws.amazon.com/elasticsearch-service/) provides the search instance and associated functions.

## Limits
The app uses geohash to divide the world into 156.5km x 156.5km grid cells ([geohash length 3](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-geohashgrid-aggregation.html)). For each grid cell, the app stores up to 250 tweets at a time, and deletes older tweets to make room for newer tweets.

At maximum utilization, I estimate this configuration will require ~1 GB of storage, which fits comfortably within the [AWS Free Tier](https://aws.amazon.com/free/):

150 trillion sq. m. (surface area of earth) / 24.4 billion sq. m. (surface area of a grid cell) * 250 tweets * 500 bytes (per tweet) = ~0.8 GB

Using smaller grid cells than this (i.e. longer geohashes) is not feasible on the Free Tier. For example, geohash level 4 (39.1km x 19.5km) would require up to ~25 GB of storage.
