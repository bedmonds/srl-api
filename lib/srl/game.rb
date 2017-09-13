module SRL
  # Summary information about a game run on SRL.
  class Game
    include Unmarshalable

    # This game's ID as per the SRL data.
    attr_reader :oid
    alias game_id oid

    # This game's complete name.
    attr_reader :name

    # This game's abbreviation, as used by RaceBot.
    attr_reader :abbrev
    alias abbreviation abbrev
    alias short_name abbrev

    # This game's popularity rating, according to SRL data.
    attr_reader :popularity

    # This game's position in the popularity contest,
    # according to SRL data.
    attr_reader :popularityrank
    alias popularity_rank popularityrank

    # The amount of ranked players on this game's leaderboard.
    attr_reader :leadersCount
    alias leaders_count leadersCount
    alias num_leaders leadersCount

    # This game's leaderboard, as an array of Players.
    #
    # While generally sorted by rank, this method does not
    # guarantee the order of the players return.
    #
    # If you absolutely need them sorted, use the `leaders_by_rank`
    # method or call `sort_by(&:rank)` on this value.
    attr_reader :leaders
    def leaders=(arr)
      @leaders = SRL::Utils.collection(arr, Runner)
    end

    # Statistics about this game. Things like the number of races, 
    # number of players, total time played and raced.
    # 
    # [SEE] SRL::Statistics
    attr_accessor :stats
    def stats=(val)
      @statistics =
        val.is_a?(Statistics) ? val
                              : Statistics.from_hash(val)
    end
    alias statistics stats

    # An array of players on this game's leaderboard, sorted by their
    # rank.
    #
    # 
    def leaders_by_rank(dir = :asc)
      raise ArgumentError unless %i(asc desc).include?(dir)
      
      dir == :asc ? leaders.sort_by(&:rank) 
                  : leaders.sort_by(&:rank).reverse
    end

    # Name, rating and rank of people that run a game on SRL.
    #
    # [NOTE] This structure is used exclusively by game leaderboards.
    class Runner
      include Unmarshalable

      # This player's name on the SRL website.
      attr_reader :name
      
      # This player's TrueSkill rating for a particular game.
      attr_reader :trueskill
      alias rating trueskill

      # This player's position on the leaderboards for a specific game.
      attr_reader :rank
      alias position rank
    end

    # Summary information about runs of a particular game.
    class Statistics
      include Unmarshalable

      # Number of races that a particular game has had.
      attr_reader :totalRaces
      alias total_races totalRaces

      # Number of players that have participated in a race of a
      # given game.
      attr_reader :totalPlayers
      alias total_players totalPlayers

      # The ID of the race with the highest number of entrants.
      attr_reader :largestRace
      alias largest_race_id largestRace

      # Number of entrants in the largest race of the game associated
      # with these Statistics.
      attr_reader :largestRaceSize
      alias largest_race_player_count largestRaceSize
      alias largest_race_size largestRaceSize

      # Number of seconds that this game has been raced.
      # A sum of the worst time of each race.
      attr_reader :totalRaceTime
      alias total_race_time totalRaceTime

      # Number of seconds that this game has been played for.
      # A sum of all the times in all races.
      attr_reader :totalTimePlayed
      alias total_time_played totalTimePlayed
    end
  end
end
