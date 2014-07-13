# https://github.com/spree/spree/issues/1439
require_dependency 'spree/calculator'

# read documentation for why Calculator::FreeShipping won't suffice

module Spree
  class Calculator::FreeShippingSelection < Calculator
    def self.description
      I18n.t(:free_shipping_selection)
    end

    def compute(object)
      0.0
    end
  end
end
