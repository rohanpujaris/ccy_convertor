# CcyConvertor

CcyConvertor provides live currency rate for various currencies and allows to convert money from one currency to other. Currently it supports 3 rate provider. New rate provider can be easily plugged in

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ccy_convertor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ccy_convertor

## Usage

Once gem is installed you can find out exchange rate between currency as follows
```ruby
CcyConvertor.rate(from_ccy: 'USD', to_ccy: 'NZD') # will use default rate provider to get rate
```
Note:  Default rate provider is CcyConvertor::YahooFinance. You can change default rate provider. Check [configuration section](#configuration)

Rate provider can also be provided as a parameter. Rate provider is a class which provides rate by using rest_api
```ruby
CcyConvertor.rate(from_ccy: 'USD', to_ccy: 'NZD', rate_provider: CcyConvertor::OpenExchangeRate)
CcyConvertor.rate(from_ccy: 'USD', to_ccy: 'NZD', rate_provider: CcyConvertor::CurrencyLayer)
```
You can also directly use rate provider class as follows.
```ruby
CcyConvertor::OpenExchangeRate.rate('USD', 'INR') # will return USD/INR rate
```
Note: CcyConvertor::OpenExchangeRate and CcyConvertor::CurrencyLayer requires api_key. You can register at respective websites to get a api key

#### Rate Providers
| Rate provider class name  | rest api source  | Api key required   |
|---|---|---|
|  CcyConvertor::YahooFinance | 'yahoo.finance.xchange' table yql  | no  |
| CcyConvertor::OpenExchangeRate  | www.openexchangerates.org  | yes  |
| CcyConvertor::CurrencyLayer  | www.currencylayer.com  | yes  |

Api key can be provided individually to this classes as

```ruby
CcyConvertor::OpenExchangeRate.api_key = 'XXXXXXXXX'
CcyConvertor::OpenExchangeRate.api_key = 'XXXXXXXXX'
```

Also check [configuration section](#configuration) to know other ways to provide api_key to rate provider classes

You can convert money from one currency to another in following ways
Below code will use rate provided from www.openexchangerates.org
```ruby
CcyConvertor::OpenExchangeRate.convert(from_ccy: 'USD', to_ccy: 'NZD', amount: 10)
10.usd.to_nzd(rate_provider: Ccyconvertor::OpenExchangeRate)
```

Below code will use default rate provider. Default rate provider is configurable . Check [configuration section](#configuration)
```ruby
CcyConvertor.convert(from_ccy: 'USD', to_ccy: 'NZD', amount: 10)
10.usd.to_nzd
```
You can also get all currency rate  (rate matrix) with respect to USD in single request for OpenExchangeRate and CurrencyLayer rate provider
```ruby
Ccyconvertor::OpenExchangeRate.rate_matrix
Ccyconvertor::CurrencyLayer.rate_matrix
```
Above method will return hash with currency code as key and rate as value. All rates would be with respect to USD. OpenExchangeRate do not allow us to specify other base currency and USD is always the base currency.

While For Ccyconvertor::CurrencyLayer we can specify the base currency
```ruby
Ccyconvertor::CurrencyLayer.rate_matrix('NZD')
```
 All rates returned would be with respect to NZD. If no parameter is given then base currency is USD by default
 
 Note:
 You cannot provide base currency for free account at currencylayer.com. By defualt base currency will be USD. You need a paid account at currencylayer.com to supply base currency
 Ccyconvertor::YahooFinance do not support rate_matrix method

## Configuration

You can configure following parameters

1. default_rate-provider: Default rate provider is the rate provider which is used when no rate provider is species. Rate provider is a api service that this gem uses to provide rate. By default default rate provider is CcyConvertor::YahooFinance. Check rate providers details [here](#rate-providers)

2. api_keys: CcyConvertor::OpenExchangeRate and CcyConvertor::CurrencyLayer provider requires api_key. You can register at there respective sites to get the api_key

3. cache_duration: specifies the time for which the response would be cached. By default this time is zero seconds i.e no caching is done by default. If cache_duration is 60 seconds and if you want a exchange rate of USD/INR multiple times in your application, request to rate provider would be made only once in 60 seconds and after 60 seconds next request would be made.
ActiveSupport::Cache is used for caching

4. roud_up_rate: This takes fixnum which tells number of decimal places to which the rate would be rounded to.

5. roud_up_amount: This takes fixnum which tells number of decimal places to which the rate would be rounded to.

Sample configuration:
```ruby
CcyConvertor.configure do |config|
  config.round_up_rate = 4
  config.round_up_amount = 4
  config.default_rate_provider = CcyConvertor::CurrencyLayer
  config.api_keys = {
    open_exchange_rate: 'XXXXXXXXX',
    currency_layer: 'XXXXXX'
  }
  config.cache_duration = {
    open_exchange_rate: 20,
    yahoo_finance: 30,
    currency_layer: 20
  }
end
```
If you are using rails, above code can be pasted in config/initializers/ccy_convertor.rb

Note: api_keys and cache_duration expects hash. Hash key is name of the class without module name in a underscore format

## Adding new rate provider

Its simple to add a new rate provider. You can plug in any rate provider which provides rest api.

##### Steps for adding rate provider that support api call to get all rate in single api call:

1. Make a class with appropriate name inherit it from CccyConvertor::RateProvider
2. Add following class methods
```ruby
  rest_url_for_rate_matrix(base_ccy=nil)
```
Above method should return rest api url to get rates of alll currencies.
```ruby
rate_matrix(base_ccy=nil)
```
Above method should return rates in hash format as
```ruby
{
    'currency_code1' => rate with respect to base_ccy,
    'currency_code2' => rate with respect to base_ccy
}
```
Note: currency_code should be in upper case
You can call ``` rate_matrix_response(base_ccy) ``` method inside ```rate_matrix(base_ccy)``` method to get response from url returned by ```rest_url_for_rate_matrix(base_ccy=nil)``` method
Once you get response from rate_matrix_response method you can convert it to response format as mentioned above

##### Steps for adding rate provider that does not support api call to get all rate in single api call:

1. Make a class with appropriate name inherit it from CccyConvertor::RateProvider
2. Add following class methods
```ruby
rest_url_for_rate(from_ccy, to_ccy)
```
Above method should return url for geting exchange rate between from_ccy and to_ccy
```ruby
rate(from_ccy, to_ccy)
```
Above method should return exchange rate(Numeric type) between from_ccy and to_ccy. You can call ```rate_response(from_ccy, to_ccy)``` inside ```rate(from_ccy, to_ccy)``` to get response from url returned by ```rest_url_for_rate(from_ccy, to_ccy)```

Now you can directly use new rate provider added by you as an existing rate provider present in the gem. You can also use all the cofiguration present for th rate provider. If rate provider added by you require api_key, you can provide it as metioned in configurtion section.
If you want to use api_key inside you rate provider class, you can use class method api_key to access it.
Check rate providers inside lib/rate_providers for more information

## Contributing

1. Fork it ( https://github.com/rohanpujaris/ccy_convertor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
