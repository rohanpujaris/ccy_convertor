module CcyConvertor
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end

  class Configuration
    attr_accessor :round_up_rate, :round_up_amount, :api_keys, :default_rate_provider, :cache_duration

    def default_rate_provider
      @default_rate_provider || CcyConvertor::YahooFinance
    end
  end
end