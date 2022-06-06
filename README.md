# README
Payment srivece - bank communication app

For project start:
ruby 2.5.8,
bundle

- cd /project
- bundle
- rake db:create
- rake db:migrate
- rake db:seed
- rails s

(to another terminal window)

- cd /project
- rails c
- service = PaymentAdapter.new(Product.last, Client.last)
- service.send_new_transaction - method for sending a created transaction for registration to the bank

- PaymentAdapter.check_status_active_transactions - method for sending all active transactions (status: "new", ad_id != nil) and then overwriting the transaction status with another one.


(to another terminal window)

- bundle exec sidekiq - to start the timer for sending transactions

API:

POST http://localhost:3000/products/:product_id/buy

success:

response: {
  {"link":"https://web.rbsuat.com/ab/merchants/typical/payment_ru.html?mdOrder=....}
}

failure:

error: {
  "undefined product_id"
}

response: {
  "order with this id is already taken"
}
