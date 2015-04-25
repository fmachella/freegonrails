require 'rails_helper'

feature 'Widget management' do
  scenario 'User press preorder button' do
    visit '/'

    # fill_in 'Name', :with => 'My Widget'
    click_button 'Prenota'

    expect(page).to have_text('Grazie per aver prenotato')
  end
end