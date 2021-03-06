module CcyConvertor
  class OpenExchangeRate < CcyConvertor::RateProvider
    class << self
      def rest_url_for_rate_matrix(base_ccy = nil)
        "https://openexchangerates.org/api/latest.json?app_id=#{api_key}"
      end

      def rate_matrix
        rate_matrix_response = rate_matrix_response()
        if rate_matrix_response['error']
          raise CcyConvertor::ResponseInvalid, rate_matrix_response['description']
        end
        rate_matrix_response['rates']
      end
    end
  end
end
