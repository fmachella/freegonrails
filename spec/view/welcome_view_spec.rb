require 'rails_helper'

RSpec.describe 'welcome/index', :type => :view do
  it 'it should render welcome page' do
    render
    # expect(rendered).to 200
    expect(rendered).to match /li voglio/
  end
end