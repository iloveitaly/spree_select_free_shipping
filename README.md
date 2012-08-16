SpreeSelectFreeShipping
=======================

The default free shipping calculator in spree allows the customers to choose whatever shipping option
and available and the shipping amount for that shipping method is added as a promotional adjustment.

This does not allow to store owner to restrict the free shipping to a specific zone and does not let
the store owner restrict the shipping methods either.

This extension takes a different approach:  

* The shipping amount is not added as an promotional adjustment
* The owner adds "Free Shipping (selection)" as a action in the promotion
* A free shipping option is presented to the user at checkout with $0.0 cost

The promotional system in spree is very flexible, [but has some limitations](https://github.com/spree/spree/issues/1616). You can't stack promotions, and you can't stack actions on a single promotion.


Example
=======

Create 48 states zone:  

	fourty_eight_states = Spree::Zone.find_or_initialize_by_name '48 Contiguous States' do |z|
	  country_id = Spree::Country.find_by_iso('US').id
	  member_list = Spree::State.find(:all, :conditions => ["abbr not in ('AK', 'HI') and country_id = ?", country_id])
	  
	  member_list.each do |member|
	    z.zone_members.build :zoneable_type => 'Spree::State', :zoneable_id => member.id
	  end
	
	  z.description = 'US States Excluding Alaska and Hawaii'
	  z.save!
	end

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2012 Michael Bianco, released under the New BSD License
