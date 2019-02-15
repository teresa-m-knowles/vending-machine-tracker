require 'rails_helper'

describe Machine, type: :model do
  describe 'validations' do
    it { should validate_presence_of :location }
    it { should belong_to :owner }
    it {should have_many :snacks}
  end

  describe 'class method' do
    it 'average_price' do
      owner = Owner.create(name: "Sam's Snacks")
      dons  = owner.machines.create(location: "Don's Mixed Drinks")
      doritos = dons.snacks.create(name:"Doritos", price: 1)
      snickers = dons.snacks.create(name:"Snickers", price: 1.25)
      mms = dons.snacks.create(name:"M&Ms", price: 1.75)

      average = dons.average_price_of_snacks

      expect(average).to eq(1.33)

    end
  end
end
