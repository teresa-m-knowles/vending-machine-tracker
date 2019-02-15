require 'rails_helper'

feature 'When a user visits a vending machine show page' do
  scenario 'they see the location of that machine' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")

    visit machine_path(dons)

    expect(page).to have_content("Don's Mixed Drinks Vending Machine")
  end

  scenario 'they see a list of all snacks and their price' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")
    doritos = dons.snacks.create(name:"Doritos", price: 1)
    snickers = dons.snacks.create(name:"Snickers", price: 1.25)
    mms = dons.snacks.create(name:"M&Ms", price: 0.75)

    dons_2 = owner.machines.create(location: "Don's Mixed Drinks 2")
    cheetos = dons_2.snacks.create(name:"Cheetos", price: 2.30)

    visit machine_path(dons)
    within "#snack-#{doritos.id}" do
      expect(page).to have_content(doritos.name)
      expect(page).to have_content(doritos.price)
    end

    within "#snack-#{snickers.id}" do
      expect(page).to have_content(snickers.name)
      expect(page).to have_content(snickers.price)
    end

    within "#snack-#{mms.id}" do
      expect(page).to have_content(mms.name)
      expect(page).to have_content(mms.price)
    end

    expect(page).to_not have_content(cheetos.name)
  end

  scenario 'they see an average price for all snacks' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")
    doritos = dons.snacks.create(name:"Doritos", price: 1)
    snickers = dons.snacks.create(name:"Snickers", price: 1.25)
    mms = dons.snacks.create(name:"M&Ms", price: 1.75)

    dons_2 = owner.machines.create(location: "Don's Mixed Drinks 2")
    cheetos = dons_2.snacks.create(name:"Cheetos", price: 2.30)

    visit machine_path(dons)

    expect(page).to have_content("Average price: $1.33")
  end
end
