module CcyConvertor
  class Money
    attr_accessor :code, :name, :amount

    def initialize(code, amount)
      @code = code
      @amount = amount
    end

    def name
      CcyConvertor::Constant::CCY_CODE_AND_NAME[code]
    end

    CcyConvertor::Constant::CCY_CODE_AND_NAME.each do |code, name|
      define_method("to_#{code.downcase}") do |options = {}|
        options.merge!(money: self, to_ccy: code)
        CcyConvertor.convert(options)
      end
    end
  end
end