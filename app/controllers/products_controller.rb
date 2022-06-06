class ProductsController < ApplicationController
  before_action :find_product, only: :buy

  def buy
    if @product.present?
      result = PaymentAdapter.new(@product, current_client).send_new_transaction
      if result.include?('formUrl')
        render json: { link: result['formUrl'] }
      else
        render json: { error: 'error', status: 404 }
      end
    else
      render json: { error: 'something wrong' }
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end
end
