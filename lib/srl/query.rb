module SRL
  class Query # :nodoc:
    def initialize(url, klass, args = {})
      @url = url
      @klass = klass
      @args = rewrite_args(args)

      @page = @args.fetch(:page, 1)
      @per_page = @args.fetch(:pageSize, 20)
    end

    def each_page
      return enum_for(:each_page) unless block_given?

      loop do
        res = fetch_page
        break if res.records.empty?

        yield res.records

        break if res.last_page?
      end
    end
    alias each each_page

    def page
      fetch_page
    end

    private

    # Return a hash with the results of a query to the SRL API. :nodoc:
    def fetch_page
      url = URI([API, @url].join) # *hiss* "URI" has been wrong for years!

      unless @args.empty?
        url.query = URI.encode_www_form(@args.merge({ page: @page }))
      end

      res = Net::HTTP.get_response(url)
      raise SRL::NetworkError, res unless res.is_a?(Net::HTTPSuccess)

      data = JSON.parse(res.body)
      @page += 1

      ResultSet.new(
        SRL::Utils.collection(data.fetch(@args[:pkey]), @klass),
        count: data.fetch('count', data.fetch(@args[:pkey]).size),
        page: (@page - 1),
        page_size: @args.fetch(:pageSize, 25)
      )
    end

    # SpeedRunsLive API URL. :nodoc:
    API = 'http://api.speedrunslive.com/'.freeze

    # Alias camelCase argument names to snake_case. :nodoc:
    def rewrite_args(args)
      { pageSize: args.fetch(:page_size, 25) }.merge(args)
    end
  end
end
