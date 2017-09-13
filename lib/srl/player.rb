module SRL
  # A registered user of SpeedRunsLive.com
  class Player
    include Unmarshalable

    attr_reader :oid
    alias player_id oid

    # This player's registered name on SpeedRunsLive.
    # [NOTE] This might not be the same name that he has registered on IRC.
    attr_reader :name

    # --
    # Stream information for the player
    # ++
    # This player's profile name on a streaming service.
    attr_reader :channel

    # Streaming platform used by this player. For example: Twitch.
    attr_reader :api
    def api=(val)
      @api = val.intern
    end

    # This player's YouTube channel.
    attr_reader :youtube

    # This player's Twitter name.
    attr_reader :twitter

    # URL to this player's stream.
    #
    # [FIXME] Add support for non-twitch streams.
    def stream
      api == :twitch ? "https://twitch.tv/#{channel}/"
                     : 'Unsupported'
    end

    # Does this player exist?
    def exists?
      player_id != 0
    end
  end
end
