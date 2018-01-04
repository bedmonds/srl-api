require_relative 'srl/api'

module SRL
  # The current version of srl-api.
  RELEASE = '0.5.0'.freeze

  # Return the current release version as a dotted string.
  def self.release
    RELEASE
  end
end
