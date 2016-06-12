require 'active_support/core_ext/string/inflections'
require 'active_support/cache.rb'
require 'digest/sha1'

require 'ccy_convertor/version'
require 'ccy_convertor/configuration'
require 'ccy_convertor/constant'
require 'ccy_convertor/exception'
require 'ccy_convertor/rate_cache'
require 'ccy_convertor/process_and_validate_option'
require 'ccy_convertor/rate_providers/rate_provider'
require 'ccy_convertor/rate_providers/yahoo_finance'
require 'ccy_convertor/rate_providers/open_exchange_rate'
require 'ccy_convertor/rate_providers/currency_layer'

module CcyConvertor
  class << self
    def rate(options)
      RateProvider.validate_presence_of_hash_keys!(options, [:from_ccy, :to_ccy])
      rate = rate_provider(options).rate(options[:to_ccy], options[:from_ccy])
      return rate if CcyConvertor.configuration.round_up_rate.nil?
      rate.to_f.round(CcyConvertor.configuration.round_up_rate)
    end

    def convert(options)
      amount = rate_provider(options).convert(options)
      return amount if CcyConvertor.configuration.round_up_amount.nil?
      amount.to_f.round(CcyConvertor.configuration.round_up_amount)
    end

    def rate_provider(options)
      options[:rate_provider] || CcyConvertor.configuration.default_rate_provider
    end
  end
end
