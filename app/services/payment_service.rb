require "faraday"
require "faraday/net_http"
Faraday.default_adapter = :net_http

class Payment
  def initialize(transaction)
    @transaction = transaction
    @return_url = "localhost:3000/"
    @conn = Faraday.new(
      url: 'https://web.rbsuat.com',
      params: { param: '1' }
      headers: { 'Content-type' => 'application/json' }
      )
  end

  def send_new_transaction
    response = @conn.post do |req|
      req.url '/ad/rest/register.do',
      req.headers['Content-type'] = 'applications/json'
      req.body = {
        "userName": "#{currnet_client.username}",
        "password": "#{currnet_client.password}",
        "orderNumber": "#{@transaction.product_id}",
        "amount": "#{Product.find_by(id: @transaction.product_id).amount}"
        "returnUrl": 'https://localhost:3000'
       }
     end
    parsed_json = ActiveSupport::JSON.decode(response)
    @transaction.update_column(:order_id, parsed_json.orderId)
    url_for_payment = parsed_json.formUrl
  end

  def check_status_active_transacions
    Transaction.active.each do |transaction|
      client = Client.find_by(id: @transaction.client_id)
      response = @conn.get do |req| # перезаписывается,надо решить
        req.url '/ad/rest/getOrderStatus.do'
        req.params[
          "userName": "#{client.username}",
          "password": "#{client.password}",
          "orderId": "#{transaction.order_id}"
        ]
      end
      response
    end
  end
end
