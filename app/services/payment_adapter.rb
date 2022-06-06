require "faraday"
require "faraday/net_http"
Faraday.default_adapter = :net_http

class PaymentAdapter
  def initialize(product, client)
    @current_client = client
    @product = product
  end

  def send_new_transaction
    if @current_client != nil && @product != nil
      @transaction = Transaction.create!(client_id: @current_client.id, product_id: @product.id)
      response = post_transaction
      parsed = JSON.parse(response.body)
    end

    if parsed["orderId"].present?
      @transaction.update!(ab_id: parsed["orderId"])
    end
    parsed['dulya'] = 'im'
    parsed
  end

  def self.check_status_active_transactions
    Transaction.active.each do |transaction|
      response = get_status(transaction.order_id)
      status_handler(transaction, JSON.parse(response.body))
    end
  end

  private

  def self.faraday_connection
    @conn ||= Faraday.new(url: 'https://web.rbsuat.com')
  end

  def self.get_status(transaction)
    faraday_connection.post '/ab/rest/getOrderStatusExtended.do' do |req|
      req.params["token"] = "#{ ENV['TOKEN'] }"
      req.params["orderId"] = "#{ transaction }"
    end
  end

  def post_transaction
    conn = Faraday.new(url: 'https://web.rbsuat.com')
    conn.post('post') do |req|
    req.url '/ab/rest/register.do'
    req.params["token"] = "#{ ENV['TOKEN'] }"
    req.params["amount"] = product_amount
    req.params["orderNumber"] = "#{ @transaction.id }"
    req.params["returnUrl"] = "https://localhost:3000"
    req.params["failUrl"] = "https://localhost:3000"
    req.headers['Content-type'] = 'application/json'
    end
  end

  def product_amount
    Product.find_by(id: @transaction.product_id).amount * 100
  end

  def self.status_handler(transaction, response)
    case response["orderStatus"]
    when 2
      transaction.update!(status: 'Paid')
    when 6, 3
      transaction.update!(status: 'Failed')
    end
  end
end

