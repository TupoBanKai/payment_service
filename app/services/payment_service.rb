require "faraday"
require "faraday/net_http"
Faraday.default_adapter = :net_http

class PaymentService
  def initialize(transaction)
    @transaction = transaction
  end

  def send_new_transaction
    parsed = parse_json(post_transaction)
    @transaction.update_column(:order_id, parsed.orderId)
    parsed.formUrl
  end

  def self.check_status_active_transactions
    Transaction.active.each do |transaction|
      client = Client.find_by(id: transaction.client_id)
      get_status(client, transaction)
      status_handler(transaction, parse_json(response))
    end
  end

  private

  def faraday_connection
    @conn ||= Faraday.new(
      url: 'https://web.rbsuat.com',
      params: { param: '1' }
      headers: { 'Content-type' => 'application/json' }
      )
  end

  def get_status(client, transaction)
    response = faraday_conenction.get do |req|
      req.url '/ad/rest/getOrderStatus.do'
      req.params{
        "userName": "#{ client.username }",
        "password": "#{ client.password }",
        "orderId": "#{ transaction.order_id }"
      }
    end
  end

  def post_transaction
    response = faraday_conenction.post do |req|
      req.url '/ad/rest/register.do',
      req.headers['Content-type'] = 'applications/json'
      req.body = {
        "userName": "#{ currnet_client.username }",
        "password": "#{ currnet_client.password }",
        "orderNumber": "#{@transaction.product_id}",
        "amount": "#{ product_amount }"
        "returnUrl": 'https://localhost:3000'
       }
     end
  end

  def product_amount
    Product.find_by(id: @transaction.product_id).amount
  end

  def parse_json(response)
    JSON.parse(response)
  end

  def status_handler(transaction, response)
    status = response.orderStatus
    case status
    when 2
      transaction.update_column(:status, "Paid")
    when 6, 3
      transaction.update_column(:status, "Failed")
    end
  end
end
