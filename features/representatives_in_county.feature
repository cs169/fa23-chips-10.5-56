Feature: display representatives when clicking on a county

  As a voter
  So that I can get all the representatives in the county
  I want to click on a county 

Background: Already on a state page

  Given initialized states as follows:
    | name       | symbol | fips_code | is_territory | lat_min     | lat_max     | long_min  | long_max    |
    | California | CA     | 06        | 0            | -124.409591 | -114.131211 | 32.534156 | -114.131211 |

  And create counties in CA with the following details:
    | name            | fips_code | fips_class |
    | Ventura County  | 111       | A          |
    | Yolo County     | 113       | B          |
    | Yuba County     | 115       | C          |


  And I am on the California state page

  Scenario: Search representatives in county
  And I follow "View"
  Then I should see "Donna Hillegass"
  And I should see "Yuba County Clerk-Recorder"