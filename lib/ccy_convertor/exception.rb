module CcyConvertor
  class NoApiKeyPresent < StandardError; end

  class InvalidAmount < StandardError; end

  class InvalidCurrencyCode < StandardError; end

  class CurrencyNotSupported < StandardError; end

  class ResponseInvalid < StandardError; end
end
