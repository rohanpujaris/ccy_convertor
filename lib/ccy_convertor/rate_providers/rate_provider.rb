require 'net/http'
require 'json'

module CcyConvertor
  class RateProvider
    extend CcyConvertor::RateCache
    extend CcyConvertor::ProcessAndValidateOption

    class << self
      attr_writer :api_key

      def api_key
        if api_key_nil?
          raise CcyConvertor::NoApiKeyPresent, "api_key not set for #{name}"
        end
        @api_key ||= CcyConvertor.configuration.api_keys[rate_provider_name]
      end

      def api_key_nil?
        @api_key.nil? &&
        (CcyConvertor.configuration.api_keys.nil? ||
        CcyConvertor.configuration.api_keys[rate_provider_name].nil?)
      end

      def rate_provider_name
        self.name.demodulize.underscore.to_sym
      end

      def response_hash(request_url)
        cache_key = cache_key(request_url)
        return cache.read(cache_key) if cache.exist?(cache_key)

        response = JSON.parse(Net::HTTP.get(URI(request_url)))
        cache.write(cache_key, response, expires_in: cache_duration)
        response
      end

      def rate_matrix_response(base_ccy=nil)
        response_hash(rest_url_for_rate_matrix(base_ccy))
      end

      def rate_response(from_ccy, to_ccy)
        response_hash(rest_url_for_rate(from_ccy, to_ccy))
      end

      def rate_from_rate_matrix(from_ccy, to_ccy)
        rate_matrix = rate_matrix()
        validate_currency_support!([from_ccy, to_ccy], rate_matrix)
        rate_matrix[from_ccy].to_f / rate_matrix[to_ccy].to_f
      end
      alias :rate :rate_from_rate_matrix

      def convert(options)
        validate_options!(options)
        converted_rate = options[:amount] * rate(options[:to_ccy], options[:from_ccy])
        return converted_rate if CcyConvertor.configuration.round_up_amount.nil?
        converted_rate.round(CcyConvertor.configuration.round_up_amount)
      end
    end
  end
end
