module SRL
  module Utils
    # Return an array of +klass+ objects from a source array
    # of hashes.
    #
    # = Notes
    # If +src+ is already an array of +klass+, this function simply
    # returns +src+.
    def self.collection(src, klass)
      raise ArgumentError unless src.is_a?(Array)
      raise ArgumentError unless klass.respond_to?(:from_hash)

      return [] if src.empty?
      return src if src.first.is_a?(klass)

      src.map { |i| klass.from_hash(i) }
    end
  end
end
