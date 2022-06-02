class ProductsController < ApplicationController
  before_action :find_product, only: :buy

  def buy
    if @product.present?
      @current_client.products.push(@product)
      #(app/service/payment).start
      # redirect
    else
      # redirect
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

end
