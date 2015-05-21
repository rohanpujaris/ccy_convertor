module CcyConvertor
  module RateCache
    attr_writer :cache_duration

    def cache
      @cache ||= {}
      @cache[rate_provider_name] ||= ActiveSupport::Cache::MemoryStore.new(expires_in: cache_duration)
    end

    def cache_duration
      @cache_duration ||= if cache_duration_nil?
        0
      else
        CcyConvertor.configuration.cache_duration[rate_provider_name]
      end
    end

    def cache_duration_nil?
      @cache_duration.nil? &&
      (CcyConvertor.configuration.cache_duration.nil? ||
      CcyConvertor.configuration.cache_duration[rate_provider_name].nil?)
    end

    def cache_key(request_url)
      Digest::SHA2.hexdigest request_url
    end
  end
end