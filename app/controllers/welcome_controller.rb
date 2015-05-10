class WelcomeController < ApplicationController

  before_filter :set_payment_manager, only: [:prenota,:conferma]

  def index

  end

  def prenota
    @set_express_checkout_response = @payment.start_payment
    if @set_express_checkout_response.ack.eql?'Success'
      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{@set_express_checkout_response.Token}", status: :found
    else
      @set_express_checkout_response
      render :errore, status: :expectation_failed
    end
  end

  def conferma

    @do_express_checkout_payment_response = @payment.finalize_payment params['token'], params['PayerID']

    # ##Access Response
    # ###Success Response

    if @do_express_checkout_payment_response.Ack == 'Success'

      # Transaction identification number of the transaction that was
      # created.
      # This field is only returned after a successful transaction
      # for DoExpressCheckout has occurred.
      @payment.api.logger.info('Transaction ID : ' + @do_express_checkout_payment_response.DoExpressCheckoutPaymentResponseDetails.PaymentInfo[0].TransactionID)

      render 'welcome/grazie'
    else
      # ###Error Response

      @payment.api.logger.error(@do_express_checkout_payment_response.Errors[0].LongMessage)
      render 'welcome/errore'
    end
  end

  def annullato

  end

  def grazie

  end

  private
  def set_payment_manager
    @payment = PaymentManager.new request.host_with_port
  end


end
