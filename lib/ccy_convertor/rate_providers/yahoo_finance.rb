module CcyConvertor
  class YahooFinance < CcyConvertor::RateProvider
    class << self
      def rest_url_for_rate(from_ccy, to_ccy)
        'https://query.yahooapis.com/v1/public/yql?q='\
        "select%20%20Rate%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22#{to_ccy}#{from_ccy}%22)"\
        '&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'
      end

      def rate(from_ccy, to_ccy)
        rate = rate_response(from_ccy, to_ccy)['query']['results']['rate']['Rate']
        if rate.nil? || rate == 'N/A'
          raise CcyConvertor::CurrencyNotSupported, "No rates available for #{from_ccy}/#{to_ccy}"
        end
        rate.to_f
      end
    end
  end
end