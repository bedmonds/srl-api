module SRL
  # A completed and recorded race.
  class PastRace
    include Unmarshalable

    attr_reader :game
    def game=(game)
      @game = game.is_a?(Game) ? game : Game.from_hash(game)
    end

    attr_reader :date
    def date=(val)
      @date = Time.at(val.to_i).utc.to_datetime
    end

    attr_reader :goal

    attr_reader :results
    def results=(arr)
      @results = SRL::Utils.collection(arr, Result)
    end

    # Result of an individual racer's time and rating adjustments.
    class Result
      include Unmarshalable

      # ID of the race this result entry is associated with.
      #
      # [NOTE] Not to be confused with the SRL Channel ID.
      attr_reader :race
      alias race_id race

      # Which place did this runner finish in?
      attr_reader :place
      alias position place

      # The runner's name
      attr_reader :player
      alias name player

      # Number of seconds the run lasted.
      attr_reader :time

      # Optional comment entered by the runner.
      attr_reader :message
      alias comment message

      attr_reader :oldtrueskill
      alias old_rating oldtrueskill

      attr_reader :newtrueskill
      alias new_rating newtrueskill

      attr_reader :trueskillchange
      alias rating_adjustment trueskillchange
    end
  end
end
