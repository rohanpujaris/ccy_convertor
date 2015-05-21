module CcyConvertor
  class JSONRate < CcyConvertor::RateProvider
    class << self
      def rest_url_for_rate_matrix(base_ccy)
        "http://jsonrates.com/get/?apiKey=#{api_key}&base=#{base_ccy || 'USD'}"
      end

      def rate_matrix(base_ccy = nil)
        JSON.parse(rate_matrix_response(base_ccy))['rates']
      end
    end
  end
end