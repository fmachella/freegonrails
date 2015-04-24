require 'rails_helper'

RSpec.describe 'layouts/application', :type => :view do
  it 'it should render viewport header tag in header' do
    render
    expect(rendered).to match /<meta name="viewport" content="width=device-width, initial-scale=1">/
  end

  it 'it should render facebook ids' do
    render
    expect(rendered).to match /931884716842527/
    expect(rendered).to match /1620154158/
    expect(rendered).to match /593589551/
    expect(rendered).to match /1312414796/
  end

end