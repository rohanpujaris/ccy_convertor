module CcyConvertor
  class NoApiKeyPresent < StandardError; end

  class InvalidAmount < StandardError; end

  class InvalidCurrencyCode < StandardError; end

  class CurrencyNotSupported < StandardError; end
end