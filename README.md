# dirserver

## About

Code spike to serve a directory prettified and recursively using [Sinatra](http://sinatrarb.com).

Uses Twitter's pretty sweet [Bootstrap CSS](http://twitter.github.com/bootstrap).

## Usage

    DIRSERVE_ROOT=`pwd` ruby dirserve.rb

## Todo

* Tests? No friggin' tests?
* Fix breadcrumb urls
* Add auth? Or is that better served with a Rack middleware in front of Dirserve? Yes.
* Syntax highlighting... Whoa back, sonny. Now we're getting sassy.
* Include bootstrap instead of linking
