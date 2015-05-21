class Numeric
  CcyConvertor::Constant::CCY_CODE_AND_NAME.each do |code, name|
    define_method(code.downcase) { CcyConvertor::Money.new(code, self) }
  end
end