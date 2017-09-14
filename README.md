SpeedRunsLive Ruby Client
=========================

Ruby library to retrieve data from SpeedRunsLive.com.


## Installation

The gem is hosted on RubyGems, so you can either install it 
with `gem install srl-api` or, if you are using bundler, by adding
it to your program's Gemfile and running `bundle install`.


## Documentation

`rdoc lib/` from the project root, or let RubyGems do it for you in $GEM_HOME.


## Sample Usage

Short version: 

    require 'srl'

    puts SRL.past_races(player: 'Artea', game: 'ffhacks').records.size # => Some number probably in the low 20s.

The `examples/` directory should provide you with an adequate amount
of usable, real-world examples.

Client code should focus on the `SRL` module, with its relevant functions 
being found in `lib/srl/api.rb`.


### One-liners

Fetch a player's stream:

    SRL.player('Foobar').stream

Get the leaderboard for a particular game:

    SRL.leaderboard('alttphacks') # => array

Retrieve a game's total time played:

    SRL.game('ffhacks').stats.total_time_played

## OS / Ruby Support

While the code probably runs on Ruby 2.1+, I have not yet tested it on 
anything lower than 2.3.0.

The library itself should work fine on MS Windows, though the examples
will not.


## Maintainer

Brian Edmonds "Artea" <[brian@bedmonds.net](mailto:brian@bedmonds.net)>

## Disclaimer

I am not affiliated in any way with SpeedRunsLive.com; I'm just a runner 
and viewer that likes the convenience of CLI tools. I wrote this small
library for myself and my tools, but thought other people might like to
use it as well.

Do try to not be a twat; servers and bandwidth cost money, so don't go 
around writing a cron job that requests outrageous amounts of data every
five seconds.
