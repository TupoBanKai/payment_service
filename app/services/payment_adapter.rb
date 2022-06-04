require "faraday"
require "faraday/net_http"
Faraday.default_adapter = :net_http

class PaymentAdapter
  def initialize(product, client)
    @current_client = client
    @product = product
  end

  def send_new_transaction
    @transaction = Transaction.create!(client_id: @current_client.id, product_id: @product.id)

    response = post_transaction
    if response.orderId.presen?
      @transaction.update(order_id: response.order_id)
    end

    parsed
  end

  def self.check_status_active_transactions
    Transaction.active.each do |transaction|
      client = Client.find_by(id: transaction.client_id)

      next unless client

      response = get_status(client, transaction)
      status_handler(transaction, response)
    end
  end

  private

  def self.faraday_connection
    @conn ||= Faraday.new(url: 'https://web.rbsuat.com')
  end

  def self.get_status(client, transaction)
    faraday_connection.get('/ab/rest/getOrderStatus.do',
      {
      "userName" => "#{ client.username }",
      "password" => "#{ client.password }",
      "orderId" => "#{ transaction.order_id }"
      })
  end

  def post_transaction
    conn = Faraday.new(url: 'https://web.rbsuat.com')
    body = {
      "userName" => "#{ @current_client.username }",
      "password" => "#{ @current_client.password }",
      "orderNumber" => "#{@transaction.product_id}",
      "amount" => "#{ product_amount }",
      "returnUrl" => "https://localhost:3000"
      }
    conn.post('/ab/rest/register.do', "#{body}",
      "Content-type" => "applications/json")
  end

  def product_amount
    Product.find_by(id: @transaction.product_id).amount
  end

  def self.status_handler(transaction, response)
    status = response.orderStatus
    case status
    when '2'
      transaction.update!(:status, 'Paid')
    when '6', '3'
      transaction.update!(:status, 'Failed')
    end
  end
end
