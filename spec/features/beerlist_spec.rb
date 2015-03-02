require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers ordered by name as default", :js => true do
    visit beerlist_path
    x = find('table').find('tr:nth-child(2)')
    expect(x).to have_content "Fastenbier"

    x2 = find('table').find('tr:nth-child(3)')
    expect(x2).to have_content "Lechte Weisse"

    x3 = find('table').find('tr:nth-child(4)')
    expect(x3).to have_content "Nikolai"
  end

  it "shows beers ordered by style correctly", :js => true do
    visit beerlist_path

    click_link('Style')
    save_and_open_page
    x = find('table').find('tr:nth-child(2)').click
    expect(x).to have_content "Nikolai"

    x2 = find('table').find('tr:nth-child(3)')
    expect(x2).to have_content "Fastenbier"

    x3 = find('table').find('tr:nth-child(4)')
    expect(x3).to have_content "Lehcte Weisse"
  end

  it "shows beers ordered by brewery correctly", :js => true do
    visit beerlist_path

    click_link('Brewery')
    x = find('table').find('tr:nth-child(2)').click
    expect(x).to have_content "Lechte Weisse"
    x2 = find('table').find('tr:nth-child(3)')
    expect(x2).to have_content "Nikolai"

    x3 = find('table').find('tr:nth-child(4)')
    expect(x3).to have_content "Fastenbier"
  end


end