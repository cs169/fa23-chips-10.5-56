# frozen_string_literal: true

Given /the following representatives exist/ do |representatives_table|
  representatives_table.hashes.each do |rep|
    Representative.create!(rep)
  end
end

When /^I follow "Details" for "(.*?)"$/ do |name|
  representative = Representative.find_by(name: name)
  visit representative_path(representative)
end

# In features/step_definitions/profile_steps.rb

Then /^I should see "(.*?)"'s profile details$/ do |name|
  representative = Representative.find_by(name: name)
  expect(representative).not_to be_nil

  expect(page).to have_content(name)
  expect(page).to have_content(representative.title) if representative.title
  expect(page).to have_content(representative.party) if representative.party
  # Add more checks as necessary, e.g., address, photo URL, etc.
  # For the photo, you can check if the image URL is present on the page:
  expect(page).to have_xpath("//img[@src='#{representative.photo}']") if representative.photo
end
