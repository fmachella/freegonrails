require 'paypal-sdk-merchant'
class PaymentManager

  attr_reader :api

  def initialize(host_with_port)
    @api = PayPal::SDK::Merchant::API.new
    @host_with_port = host_with_port
    @action='Authorization'
  end

  def start_payment
    set_express_checkout = @api.build_set_express_checkout({
                                                               Version: '104.0',
                                                               SetExpressCheckoutRequestDetails: {
                                                                   ReturnURL: "http://#{@host_with_port}/conferma",
                                                                   CancelURL: "http://#{@host_with_port}/annullato",
                                                                   PaymentDetails: [createOrder.merge({PaymentAction: @action})]
                                                               }})

    @set_express_checkout_response = @api.set_express_checkout(set_express_checkout)
  end


  def finalize_payment(token, payerid)
    do_express_checkout_payment = @api.build_do_express_checkout_payment({
                           DoExpressCheckoutPaymentRequestDetails: {

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
                               PaymentAction: @action,

                               # The timestamped token value that was returned in the
                               # `SetExpressCheckout` response and passed in the
                               # `GetExpressCheckoutDetails` request.
                               Token: token,

                               # Unique paypal buyer account identification number as returned in `GetExpressCheckoutDetails` Response
                               PayerID: payerid,

                               # information about the payment
                               PaymentDetails: [createOrder.merge({NotifyURL: "http://#{@host_with_port}/ipn_notify"})]
                           }})

    # ##Make API call & get response
    @api.do_express_checkout_payment(do_express_checkout_payment)

  end

  private_methods

  def createOrder(price=4.99)
    {
        OrderTotal: {
            currencyID: 'EUR',
            value: price},

    }
  end
end