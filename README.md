[![Build Status](https://travis-ci.org/CalvertYang/pay2go.svg?branch=master)](https://travis-ci.org/CalvertYang/pay2go)

# 智付寶 Pay2go

這是智付寶 API 的 Ruby 包裝，更多資訊請參閱 [API 文件專區](https://www.pay2go.com/info/site_description/api_description)。

- 這不是 Rails 插件，只是個 API 包裝。
- 使用時只需要傳送需要的參數即可，不用產生檢查碼，`pay2go_client` 會自己產生。
- 感謝[大兜](https://github.com/tonytonyjan)撰寫的 [allpay](https://github.com/tonytonyjan/allpay)

## 安裝

```bash
gem install pay2go_client
```

## 使用

```ruby
test_client = Pay2go::Client.new({
  merchant_id: 'MERCHANT_ID',
  hash_key: 'HASH_KEY',
  hash_iv: 'HASH_IV',
  mode: :test
})

production_client = Pay2go::Client.new({
  merchant_id: 'MERCHANT_ID',
  hash_key: 'HASH_KEY',
  hash_iv: 'HASH_IV'
})

test_client.query_trade_info({
  MerchantOrderNo: '4e19cab1',
  Amt: 100
})
```

本文件撰寫時，智付寶共有 5 個 API：

API 名稱           | 說明
---                  | ---
MPG API              | MPG(Multi Payment Gateway)，單一串接多種支付方式。<br>透過 MPG API 可串接平台提供的所有支付方式。
交易狀態查詢 API       | 透過交易查詢 API 可自動化查核所有交易是否同步更新付款資訊。
信用卡-取消授權模組 API | 透過取消授權 API，可進行信用卡交易授權取消，以返還持卡人及商店信用卡額度。
信用卡-請退款模組 API   | 透過請退款 API，可進行信用卡交易的請退款。
信用卡-定期定額 API     | 透過信用卡定期定額 API，可進行信用卡定期定額交易。

詳細 API 參數請參閱智付寶技術串接手冊，注意幾點：

- 使用時不用煩惱 `MerchantID`、`RespondType`、`CheckValue`、`TimeStamp` 及 `Version`，正如上述範例一樣。
- MPG/信用卡-定期定額 API 回傳的內容是 HTML，這個請求應該是交給瀏覽器發送的。

## Pay2go::Client

實體方法                                                   | 回傳       | 說明
---                                                       | ---       | ---
`verify_check_code(params)`                               | `Boolean` | 會於檢查收到的參數，其檢查碼是否正確，用於智付寶的 `NotifyURL` 參數及檢核資料回傳的合法性。
`generate_mpg_params(params)`                             | `Hash`    | 用於產生 MPG API 表單需要的參數。
`query_trade_info(params)`                                | `Hash`    | 用於查詢交易狀態。
`credit_card_deauthorize(params)`                         | `Hash`    | 用於進行信用卡交易授權取消作業。
`credit_card_deauthorize_by_merchant_order_no(params)`    | `Hash`    | `credit_card_deauthorize` 的捷徑方法，將 `IndexType` 設為 1
`credit_card_deauthorize_by_trade_no(params)`             | `Hash`    | `credit_card_deauthorize` 的捷徑方法，將 `IndexType` 設為 2
`credit_card_collect_refund(params)`                      | `Hash`    | 用於進行信用卡交易的請退款作業。
`credit_card_collect_refund_by_merchant_order_no(params)` | `Hash`    |  `credit_card_collect_refund` 的捷徑方法，將 `IndexType` 設為 1
`credit_card_collect_refund_by_trade_no(params)`          | `Hash`    |  `credit_card_collect_refund` 的捷徑方法，將 `IndexType` 設為 2
`generate_credit_card_period_params(params)`              | `Hash`    | 用於產生信用卡-定期定額 API 表單需要的參數。

## 使用範例

##### MPG、信用卡-定期定額
```bash
git clone git@github.com:CalvertYang/pay2go.git
cd pay2go
bundle install
ruby examples/server.rb
```

- MPG(GET)：http://localhost:4567/mpg
- 信用卡-定期定額(GET)：http://localhost:4567/period
- 驗證資料合法性(POST)：http://localhost:4567/validate

##### 交易狀態查詢
```ruby
result = test_client.query_trade_info({
  MerchantOrderNo: '4e19cab1',
  Amt: 100
})

puts "Result: #{result}"
puts "Valid?: #{@client.verify_check_code(result)}"
```

##### 信用卡-取消授權模組
```ruby
result = test_client.credit_card_deauthorize({
  TradeNo: '16010112345678901',
  Amt: 100,
  IndexType: 1
})

puts "Result: #{result}"
puts "Valid?: #{@client.verify_check_code(result)}"
```

```ruby
result = test_client.credit_card_deauthorize_by_merchant_order_no({
  MerchantOrderNo: '4e19cab1',
  Amt: 100
})

puts "Result: #{result}"
puts "Valid?: #{@client.verify_check_code(result)}"
```

```ruby
result = test_client.credit_card_deauthorize_by_trade_no({
  TradeNo: '16010112345678901',
  Amt: 100
})

puts "Result: #{result}"
puts "Valid?: #{@client.verify_check_code(result)}"
```

##### 信用卡-請退款模組
```ruby
result = test_client.credit_card_collect_refund({
  MerchantOrderNo: '4e19cab1',
  Amt: 100,
  CloseType: 2,
  IndexType: 1
})

puts "Result: #{result}"
```

```ruby
result = test_client.credit_card_collect_refund_by_merchant_order_no({
  MerchantOrderNo: '4e19cab1',
  Amt: 100,
  CloseType: 2
})

puts "Result: #{result}"
```

```ruby
result = test_client.credit_card_collect_refund_by_trade_no({
  TradeNo: '16010112345678901',
  Amt: 100,
  CloseType: 2
})

puts "Result: #{result}"
```

## License
MIT

![Analytics](https://ga-beacon.appspot.com/UA-44933497-3/CalvertYang/pay2go?pixel)
