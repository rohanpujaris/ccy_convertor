module CcyConvertor
  class CurrencyLayer < CcyConvertor::RateProvider
    class << self
      def rest_url_for_rate_matrix(base_ccy)
        "http://apilayer.net/api/live?access_key=#{api_key}&source=#{base_ccy || 'USD'}&format=1"
      end

      def rate_matrix(base_ccy = nil)
        rates = rate_matrix_response(base_ccy)['quotes']
        rates.inject({}) { |acc, (k, v)| acc[k[3, 3]] = v; acc }
      end
    end
  end
end
