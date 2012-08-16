require_dependency 'spree/calculator'

module Spree
  class Calculator::FreeShippingDelivery < Calculator::FlatRate
    def self.description
      I18n.t(:free_shipping_delivery)
    end

    def compute(object=nil)
      0.0
    end

    def available?(order)
      # we don't scope eligible because all $0 promotions are eligible = false
      # because the free shipping adjustment enables the free shipping delivery method
      # it does not have a cost associated with it
      return false if order.adjustments.promotion.blank?

      # check to see if the promotion attached to this order has the free shipping selection calculation in its actions
      exists = false

      # exception occurs when a promotion was modified or deleted, but the adjustment
      # associated with that promotion is still attached to the order
      # begin
        order.adjustments.promotion.each do |promotion|
          # a promotion which has expired (start_at, end_at) can still be attached to an order
          # we should 'recheck' the promotion status here
          if promotion.eligible or promotion.originator.promotion.eligible?(order)
            promotion.originator.promotion.actions.each do |action|
              exists = true if action.calculator.class == Spree::Calculator::FreeShippingSelection
            end
          end
        end        
      # rescue
      #   return false
      # end

      return false unless exists

      # we can't stack promotions yet (https://github.com/spree/spree/issues/1616)
      # can't stack actions on a single promotion either (only the first promotional action is applied for a promotion)
      # we wan't to be able to limit the free shipping to an order above a specific number

      (order.item_total - order.adjustments.promotion.eligible.map(&:amount).sum) > 0.0
    end
  end
end