require 'rails_helper'

RSpec.describe 'welcome/errore', :type => :view do
  it 'it should errore page' do
    render
    expect(rendered).to match /errore nell'autorizzazione/
  end
end