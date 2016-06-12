module CcyConvertor
  module ProcessAndValidateOption
    def validate_options!(options)
      validate_presence_of_hash_keys!(options, [:from_ccy, :to_ccy, :amount])
      validate_amount!(options[:amount])
      validate_currency_codes!([options[:from_ccy], options[:to_ccy]])
    end

    def validate_presence_of_hash_keys!(options, keys)
      options_not_provided = keys - options.keys
      if options_not_provided.count != 0
        raise ArgumentError,
          "argument hash should have #{options_not_provided.join(', ')} #{options_not_provided.count > 1 ? 'keys' : 'key'}"
      end
    end

    def validate_amount!(amount)
      unless amount.is_a?(Numeric)
        raise CcyConvertor::InvalidAmount, 'options[:amount] must be a number'
      end
    end

    def validate_currency_codes!(currency_codes)
      currency_codes.each do |code|
        unless CcyConvertor::Constant::CCY_CODE_AND_NAME[code]
          raise CcyConvertor::InvalidCurrencyCode, "Currency code '#{code}' doesn't exists"
        end
      end
    end

    def validate_currency_support!(currencies, rate_matrix)
      currencies.each do |ccy|
        if rate_matrix[ccy].nil?
          raise CcyConvertor::CurrencyNotSupported, "Currency '#{ccy}' is not supported by OpenExchangeRate"
        end
      end
    end
  end
end
