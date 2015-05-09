require 'paypal-sdk-merchant'
class WelcomeController < ApplicationController

  before_filter :set_merchant_api

  def index

  end

  def prenota
    @set_express_checkout = @api.build_set_express_checkout({
                                                                :Version => '104.0',
                                                                :SetExpressCheckoutRequestDetails => {
                                                                    :ReturnURL => 'http://localhost:3000/conferma',
                                                                    :CancelURL => 'http://localhost:3000/annullato',
                                                                    :PaymentDetails =>[{
                                                                                           :OrderTotal =>{
                                                                                               :currencyID => 'EUR',
                                                                                               :value => '4.99'},
                                                                                           :PaymentAction => 'Authorization'}],
                                                                    :BuyerEmail => 'buyer@soggetthis.com'
                                                                }})

    @set_express_checkout_response = @api.set_express_checkout(@set_express_checkout)
    if @set_express_checkout_response.ack.eql?'Success'
      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{@set_express_checkout_response.Token}", status: :found
    else
      @set_express_checkout_response
      render :errore, status: :expectation_failed
    end
  end

  def conferma
    @do_express_checkout_payment = @api.build_do_express_checkout_payment({
                                                                              :DoExpressCheckoutPaymentRequestDetails => {

                                                                                  # How you want to obtain payment. When implementing parallel payments,
                                                                                  # this field is required and must be set to `Order`. When implementing
                                                                                  # digital goods, this field is required and must be set to `Sale`. If the
                                                                                  # transaction does not include a one-time purchase, this field is
                                                                                  # ignored. It is one of the following values:
                                                                                  #
                                                                                  # * `Sale` - This is a final sale for which you are requesting payment
                                                                                  # (default).
                                                                                  # * `Authorization` - This payment is a basic authorization subject to
                                                                                  # settlement with PayPal Authorization and Capture.
                                                                                  # * `Order` - This payment is an order authorization subject to
                                                                                  # settlement with PayPal Authorization and Capture.
                                                                                  # Note:
                                                                                  # You cannot set this field to Sale in SetExpressCheckout request and
                                                                                  # then change the value to Authorization or Order in the
                                                                                  # DoExpressCheckoutPayment request. If you set the field to
                                                                                  # Authorization or Order in SetExpressCheckout, you may set the field
                                                                                  # to Sale.
                                                                                  :PaymentAction => 'Authorization',

                                                                                  # The timestamped token value that was returned in the
                                                                                  # `SetExpressCheckout` response and passed in the
                                                                                  # `GetExpressCheckoutDetails` request.
                                                                                  :Token => params['token'],

                                                                                  # Unique paypal buyer account identification number as returned in `GetExpressCheckoutDetails` Response
                                                                                  :PayerID => params['PayerID'],

                                                                                  # information about the payment
                                                                                  :PaymentDetails => [{

                                                                                                          # Total cost of the transaction to the buyer. If shipping cost and tax
                                                                                                          # charges are known, include them in this value. If not, this value
                                                                                                          # should be the current sub-total of the order.
                                                                                                          #
                                                                                                          # If the transaction includes one or more one-time purchases, this field must be equal to
                                                                                                          # the sum of the purchases. Set this field to 0 if the transaction does
                                                                                                          # not include a one-time purchase such as when you set up a billing
                                                                                                          # agreement for a recurring payment that is not immediately charged.
                                                                                                          # When the field is set to 0, purchase-specific fields are ignored.
                                                                                                          #
                                                                                                          # * `Currency Code` - You must set the currencyID attribute to one of the
                                                                                                          # 3-character currency codes for any of the supported PayPal
                                                                                                          # currencies.
                                                                                                          # * `Amount`
                                                                                                          :OrderTotal => {
                                                                                                              :currencyID => 'EUR',
                                                                                                              :value => '4.99'},

                                                                                  # Your URL for receiving Instant Payment Notification (IPN) about this transaction. If you do not specify this value in the request, the notification URL from your Merchant Profile is used, if one exists.
                                                                                  :NotifyURL => 'http://localhost:3000/ipn_notify'}
                                                                                  ]}})

    # ##Make API call & get response
    @do_express_checkout_payment_response = @api.do_express_checkout_payment(@do_express_checkout_payment)

    # ##Access Response
    # ###Success Response

    if @do_express_checkout_payment_response.Ack == 'Success'

      # Transaction identification number of the transaction that was
      # created.
      # This field is only returned after a successful transaction
      # for DoExpressCheckout has occurred.
      @api.logger.info('Transaction ID : ' + @do_express_checkout_payment_response.DoExpressCheckoutPaymentResponseDetails.PaymentInfo[0].TransactionID)

      render 'welcome/grazie'
    else
      # ###Error Response

      @api.logger.error(@do_express_checkout_payment_response.Errors[0].LongMessage)
      render 'welcome/errore'
    end
  end

  def annullato

  end

  def grazie

  end

  private
  def set_merchant_api
    @api = PayPal::SDK::Merchant::API.new
  end


end
