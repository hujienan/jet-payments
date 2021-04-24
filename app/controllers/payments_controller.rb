class PaymentsController < ApplicationController
  def index
  end

  def create
    card_number = params[:card_number]
    if card_number == "5560000000000001"
      render :json => "Faild to proceed!", :status => 400
    else
      payment = Payment.new
      # mask credit card number
      card_number.gsub!(/.(?=....)/, '*')
      payment.card_number = card_number
      payment.name_on_card = params[:name_on_card]
      payment.expiry_date = params[:expiry_date]
      payment.email_address = params[:email_address]
      payment.billing_address = params[:billing_address]
      payment.description = params[:description]
      
      if payment.save
        render :json => "/payments/#{payment.id}"
      else
        render :json => payment.errors, :status => 400
      end
    end
  end

  def show
    @payment = Payment.find_by(id: params[:id])
    if @payment.nil?
      redirect_to root_url
    end
  end

  private
    # strong parameters for payment
    def payment_params
      params.require(:payment).permit(:card_number, :name_on_card, :expiry_date, :email_address, :billing_address, :description)
    end
end
