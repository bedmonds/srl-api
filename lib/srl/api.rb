require 'json'
require 'net/http'
require 'time'

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'srl/utils'

require 'srl/unmarshalable'

require 'srl/game'
require 'srl/past_race'
require 'srl/player'
require 'srl/race'
require 'srl/result_set'

module SRL
  class << self
    # Fetch usage data about a specific game, identified 
    # by its abbreviation.
    #
    # call-seq: game(abbreviation) -> obj
    def game(abbrev)
      res = query("stat", game: abbrev)
      game = Game.from_hash(res.fetch('game'))
      game.stats = res.fetch('stats')

      game
    end

    # Fetch a player's public profile, by name.
    # Raises a NameError if the given name does not exist.
    #
    # call-seq: player(name) -> obj
    def player(name)
      player = Player.from_hash(query("players/#{name}"))

      raise NameError, "Player '#{name}' not found." unless player.exists?

      player
    end

    # Fetch the leaderboard for a specific game, identified 
    # by its abbreviation.
    #
    # call-seq: leaderboard(abbrev) -> obj
    def leaderboard(abbrev)
      SRL::Utils.collection(
        query("leaderboard/#{abbrev}").fetch('leaders'),
        Player
      )
    end

    # Return an array of Race objects for races currently being
    # run or set up.
    #
    # call-seq: current_races -> array
    def current_races
      SRL::Utils.collection(query('races').fetch('races'), Race)
    end

    # Return an array of PastRace objects for completed races.
    #
    # You may filter the results by providing a `player` or `game`
    # argument, to limit results to a specific player or game 
    # abbreviation.
    #
    #   # To fetch only the six million LTTP Rando races.
    #   completed_races(game: 'alttphacks') 
    #
    #   # To only retrieve Edgeworth's FF Randomizer races.
    #   completed_races(player: 'Edgeworth', game: 'ffhacks') 
    #
    # Results are paginated at `page_size` records per page, 
    # starting at 1. An upper limit to this number has not
    # been tested, though I'd recommend that you not be a twat 
    # and limit your requests to something that will not murder
    # the server.
    #
    # call-seq: current_races -> array
    def completed_races(args = {})
      res = query('pastraces', rewrite_args(args))
      ResultSet.new(
        SRL::Utils.collection(res.fetch('pastraces'), PastRace),
        count: res.fetch('count'),
        page: args.fetch(:page, 1),
        page_size: args.fetch(:pageSize, 25)
      )
    end
    alias past_races completed_races

    private

    # SpeedRunsLive API URL. :nodoc:
    API = 'http://api.speedrunslive.com/'.freeze

    # Return a hash with the results of a query to the SRL API. :nodoc:
    def query(url, params = {})
      url = URI([API, url].join) # *hiss* "URI" has been wrong for years!
      url.query = URI.encode_www_form(params) unless params.empty?

      res = Net::HTTP.get_response(url)
      raise NetworkError, res unless res.is_a?(Net::HTTPSuccess)

      JSON.parse(res.body)
    end

    # Alias camelCase argument names to snake_case. :nodoc:
    def rewrite_args(args)
      { pageSize: args.fetch(:page_size, 25) }.merge(args)
    end

  end
  # Raised when an HTTP request to the SRL API server fails,
  # whether due to a malformed request or the server being down.
  #
  # [FIXME] Add actual descriptions of what fucked up and 
  #         possible solutions to the issue.
  class NetworkError < StandardError; end
end
