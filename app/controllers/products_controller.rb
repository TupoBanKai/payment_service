class ProductsController < ApplicationController
  before_action :find_product, only: :buy

  def buy
    if @product.present?
      result = PaymentAdapter.new(@product, current_client).send_new_transaction
      if result.formUrl.present?
        render json: { link: result.formUrl }
      else
        render json: { error: result["errorMessage"] }
      end
    else
      render json: { error: 'undefined product_id' }
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end
end
