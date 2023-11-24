# frozen_string_literal: true

Given /initialized states as follows/ do |state_definitions|
  state_definitions.hashes.each do |state_details|
    State.create!(name:         state_details['name'],
                  symbol:       state_details['symbol'],
                  fips_code:    state_details['fips_code'],
                  is_territory: state_details['is_territory'],
                  lat_min:      state_details['lat_min'],
                  lat_max:      state_details['lat_max'],
                  long_min:     state_details['long_min'],
                  long_max:     state_details['long_max'])
  end
end
