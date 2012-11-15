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
      order.adjustments.promotion.each do |promotion|
        # a promotion which has expired (start_at, end_at) can still be attached to an order
        # this has to do with some of the issues discussed here: https://github.com/spree/spree/pull/1984
        
        if promotion.eligible or promotion.originator.promotion.eligible?(order)
          # UPGRADE_CHECK the issue below is fixed here https://github.com/spree/spree/pull/2000
          
          # the promotion scope does a SQL 'LIKE' on the label field on the adjustments
          # if a promotion is entered in through the admin with 'promotion' in the title
          # it will *not* have an originator and trigger an exception here

          next if promotion.originator.blank?

          promotion.originator.promotion.actions.each do |action|
            exists = true if action.calculator.class == Spree::Calculator::FreeShippingSelection
          end
        end
      end        

      return false unless exists

      # we can't stack promotions yet (https://github.com/spree/spree/issues/1616)
      # can't stack actions on a single promotion either (only the first promotional action is applied for a promotion)
      # we wan't to be able to limit the free shipping to an order above a specific number

      # TODO the > $100 should be dynamic
      (order.item_total + order.adjustments.promotion.eligible.map(&:amount).sum) > 100.0
    end
  end
end