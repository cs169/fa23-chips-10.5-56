# frozen_string_literal: true

Given /create counties in (.*) with the following details/ do |state_abbr, county_definitions|
  target_state = State.find_by(symbol: state_abbr)
  county_definitions.hashes.each do |county_detail|
    target_state.counties.create!(name:       county_detail['name'],
                                  fips_code:  county_detail['fips_code'],
                                  fips_class: county_detail['fips_class'])
  end
end
