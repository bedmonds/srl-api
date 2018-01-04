module SRL
  # A race that has not yet been recorded or closed.
  class Race
    include Unmarshalable

    STATES = [
      :open,
      :unknown,
      :in_progress,
      :complete
    ].freeze

    # The IRC channel suffix for this race.
    attr_reader :oid
    alias channel oid

    # The state of this race. Entry Open / In Progress / Completed
    # [FIXME] Switch to enum-like behaviour with symbols.
    attr_reader :state

    def status
      STATES[state - 1]
    rescue
      :unknown
    end

    # The game associate with this race.
    attr_reader :game
    def game=(game)
      @game = game.is_a?(Game) ? game
                               : Game.from_hash(game)
    end

    # The players enlisted in this race as an array of Entrants.
    attr_reader :entrants
    def entrants=(arr)
      # Account for the api returning a hash with the entrants' name
      # as key instead of an array, despite repeating the entrants name 
      # in `displayname`.
      arr = arr.is_a?(Hash) ? arr.values : arr
      @entrants = SRL::Utils.collection(arr, Entrant)
    end

    attr_accessor :goal

    attr_accessor :time
    attr_accessor :numentrants

    # A participant in an active race.
    class Entrant
      include Unmarshalable

      # This entrant's player name.
      attr_reader :displayname
      alias name displayname

      # This entrant's Twitch account name.
      attr_reader :twitch

      # The position that this entrant finished this race in.
      attr_reader :place
      alias position place

      # The comment entered by this entrant for this race,
      # if applicable.
      attr_reader :message
      alias comment message 

      # The number of seconds that this entrant took to complete
      # the race goal. 
      #
      # = Notes
      # A time of -1 indicates a forfeit.
      attr_reader :time

      # Did this entrant forfeit the race?
      def forfeit?
        time == -1
      end

      # The state of this entrant in the race. 
      # Is he ready, finished, neither?
      #
      # [FIXME] Switch to an enum-like implementation with symbols.
      attr_reader :statetext
    end
  end
end
