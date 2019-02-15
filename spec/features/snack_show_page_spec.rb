require 'rails_helper'

RSpec.describe 'When I visit a snack show page' do
  it 'I see the name of the snack and its price' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")

    turing = owner.machines.create(location: "Turing Basement")
    bank = owner.machines.create(location: "Global Bank")

    doritos = Snack.create(name:"Doritos", price: 1.50, machines:[dons,turing,bank])

    visit snack_path(doritos)
    expect(page).to have_content(doritos.name)
  end

  it 'the list of locations ' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")

    turing = owner.machines.create(location: "Turing Basement")
    bank = owner.machines.create(location: "Global Bank")
    no_doritos = owner.machines.create(location: "Lame Place")
    no_doritos.snacks.create(name:"Cheetos", price: 2)

    doritos = Snack.create(name:"Doritos", price: 1.50, machines:[dons,turing,bank])

    visit snack_path(doritos)

    within ".locations" do
      expect(page).to have_content(turing.location)
      expect(page).to have_content(bank.location)
      expect(page).to have_content(dons.location)
      expect(page).to_not have_content(no_doritos.location)
    end

  end

  it 'and a count of the different kinds of items in that machine and their average price' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")
    dons.snacks.create(name:"Snack1", price: 2)
    dons.snacks.create(name:"Snack2", price: 1.50)

    turing = owner.machines.create(location: "Turing Basement")
    turing.snacks.create(name:"Turing snack1", price: 3)

    bank = owner.machines.create(location: "Global Bank")
    no_doritos = owner.machines.create(location: "Lame Place")
    no_doritos.snacks.create(name:"Cheetos", price: 2)

    doritos = Snack.create(name:"Doritos", price: 1.25, machines:[dons,turing,bank])

    visit snack_path(doritos)

    within "#machine-#{dons.id}" do
      expect(page).to have_content("3 kinds of snacks, average price of $1.58")
    end

    within "#machine-#{turing.id}" do
      expect(page).to have_content("2 kinds of snacks, average price of $1.42")
    end

    within "#machine-#{no_doritos.id}" do
      expect(page).to have_content("1 kinds of snacks, average price of $2")
    end

  end



end
