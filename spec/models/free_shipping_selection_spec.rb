require 'spec_helper'

describe Spree::Calculator::FreeShippingSelection do
	let(:order) { FactoryGirl.create(:order) }
	let(:free_shipping_delivery) { Spree::Calculator::FreeShippingDelivery.new }

  it "should not be available when no promotion exists" do
  	expect(free_shipping_delivery.available?(order)).to eq(false)
  end

  it "should be available when a promotion with the free shipping selection exists" do
  	promo = Spree::Promotion.create(:name => "free shipping")
  	Spree::Promotion::Actions::CreateAdjustment.create({
  		promotion: promo,
  		calculator: Spree::Calculator::FreeShippingSelection.new
  	}, without_protection: true)
  	promo.reload
  	promo.activate({ order: order })

  	expect(promo.actions).not_to be_empty
  	expect(order.adjustments.promotion).not_to be_empty

  	# not over 100 yet
  	expect(free_shipping_delivery.available?(order)).to be_false

  	variant = FactoryGirl.create(:variant, price: 51.00)
  	order.add_variant(variant, 2)
  	promo.activate({ order: order })

  	expect(free_shipping_delivery.available?(order)).to be_true
  end
end
