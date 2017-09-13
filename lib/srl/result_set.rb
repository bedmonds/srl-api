module SRL
  # Wrapper around various calls to paginated data, such as past races.
  # Contains pagination information, and information on all records,
  # on top of the current page's records.
  class ResultSet
    # Records for this result set.
    # [NOTE]
    # Always an array, though the type of object contained in the array
    # can vary depending on the query that spawned it.
    attr_reader :results
    alias data results
    alias records results
    alias items results

    # The page of this result set.
    attr_reader :page

    attr_reader :page_size
    alias per_page page_size

    # Total number of records matching the query for this result set.
    attr_reader :count
    alias total_records count
    alias num_records count

    def initialize(results, params = {})
      @results = results
      @page = params.fetch(:page)
      @page_size = params.fetch(:page_size)
      @count = params.fetch(:count)
    end

    def num_pages
      (count.to_f / page_size.to_f).ceil
    end
    alias pages num_pages

    def last_page?
      page == num_pages
    end
  end
end
