require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

  end

  describe 'Prenotazione redirect a paypal' do

    it 'redirect to paypal on success' do
      post :prenota
      expect(response).to have_http_status(:found)
    end

    pending 'return expectation_failed on paypal setcheckout failed' do
      post :prenota
      expect(response).to have_http_status(:expectation_failed)
    end

  end

  describe 'Prenotazione callbacks' do
    let(:do_express_checkout_payment_response) { OpenStruct.new({Ack: 'Success'}) }

    it 'redirect to paypal' do
      post :prenota
      expect(response).to have_http_status(302)
    end

    let(:do_express_checkout_payment_response) { OpenStruct.new({Ack: 'Error', Errors: [OpenStruct.new({LongMessage: 'Questo è il messaggio di errore di paypal'})]}) }

    it 'Show error message on payment error callback' do
      get :conferma, token: 'anytoken', PayerID: 'anyid'
      expect(response).to render_template('welcome/errore')
      expect(do_express_checkout_payment_response.Ack).to eql 'Error'
    end

  end


end
