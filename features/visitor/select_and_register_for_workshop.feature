Feature: Selecting a workshop and registering for it

  @selenium @allow-rescue
  Scenario: Visitor registers for a section
    Given an audience exists with a name of "Developers"
    And the following workshop exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 10000000         |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then I should see "Complete your purchase of Test-Driven Haskell"
    And I should see "$10,000,000"
    When I fill in all of the workshop registration fields for "carlos@santana.com"
    And I choose to pay with Paypal
    And I press "Proceed to Checkout"
    And I submit the Paypal form
    Then carlos@santana.com is registered for the Test-Driven Haskell workshop
    Then "carlos@santana.com" opens the email with subject "You're registered for Test-Driven Haskell"
    And they should see "You can also create a user account" in the email body

  @selenium @allow-rescue
  Scenario: A visitor signs up for an account during registration
    Given the following workshop exists:
      | name                |
      | Test-Driven Haskell |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    And I follow "Sign in."
    And I follow "Sign up"
    And I sign up with the following:
      | first_name      | Carlos             |
      | last_name       | Santana            |
      | email           | carlos@santana.com |
      | password        | mypass             |
    Then I should see "Complete your purchase of Test-Driven Haskell"
    And "Email" should be filled in with "carlos@santana.com"
    And "Name" should be filled in with "Carlos Santana"
    When I fill in all of the workshop registration fields for "carlos@santana.com"
    And I choose to pay with Paypal
    And I press "Proceed to Checkout"
    And I submit the Paypal form
    Then carlos@santana.com is registered for the Test-Driven Haskell workshop
    Then "carlos@santana.com" opens the email with subject "You're registered for Test-Driven Haskell"
    And they should not see "You can also create a user account" in the email body

  @selenium @allow-rescue
  Scenario: Visitor registers for a section with an invalid e-mail
    Given an audience exists with a name of "Developers"
    And the following workshop exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 10000000         |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then I should see "Complete your purchase of Test-Driven Haskell"
    And I should see "$10,000,000"
    When I fill in all of the workshop registration fields for "carlos@blah"
    And I press "Submit Payment"
    Then I should see that the email is invalid

  @selenium
  Scenario: Visitor registers with a valid coupon
    Given an audience exists with a name of "Developers"
    And the following coupon exists:
      | code       | discount_type | amount |
      | VALENTINES | percentage    | 10     |
    And the following workshop exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 10000            |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then I should see "$10,000"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$9,000.00 (10% off)"
    And the coupon form should be hidden
    And the coupon form link should be hidden
    When I fill in all of the workshop registration fields for "carlos@santana.com"
    And I choose to pay with Paypal
    And I press "Proceed to Checkout"
    And I submit the Paypal form
    Then carlos@santana.com is registered for the Test-Driven Haskell workshop

  @selenium
  Scenario: Visitor registers with a valid coupon which brings the price to 0
    Given an audience exists with a name of "Developers"
    And the following coupon exists:
      | code       | amount | discount_type |
      | VALENTINES | 100    | percentage    |
    And the following workshop exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 10000            |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then I should see "Complete your purchase of Test-Driven Haskell"
    And I should see "$10,000"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    When I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$0"
    And the coupon form should be hidden
    And the coupon form link should be hidden
    When I fill in the required workshop registration fields for "carlos@santana.com"
    And I press "Submit Payment"
    Then carlos@santana.com is registered for the Test-Driven Haskell workshop

  @selenium
  Scenario: Visitor registers with an invalid coupon
    Given an audience exists with a name of "Developers"
    And the following coupon exists:
      | code       | discount_type | amount | active |
      | VALENTINES | percentage    | 10     | false  |
    And the following workshop exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 100              |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then I should see "Complete your purchase of Test-Driven Haskell"
    And I should see "$100"
    When I follow "Have a coupon code?"
    Then the coupon form should be visible
    And I fill in "Code" with "VALENTINES"
    And I press "Apply Coupon"
    Then I should see "$100"
    And I should see "The coupon code you supplied is not valid"
    And the coupon form should be visible

  Scenario: Visitor views a workshop with an external registration url
    Given an audience exists with a name of "Developers"
    And the following workshop exists:
      | name                | audience         | external_registration_url |
      | Test-Driven Haskell | name: Developers | http://engineyard.com     |
    And the following future section exists:
      | workshop                    |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I view all products
    And I follow "Test-Driven Haskell"
    Then the registration button should link to "http://engineyard.com"

  @selenium
  Scenario: Visitor registers for a free section
    Given an audience exists with a name of "Developers"
    And the following workshop exists:
      | name                | audience         | individual_price |
      | Test-Driven Haskell | name: Developers | 0                |
    And the following future section exists:
      | workshop                  |
      | name: Test-Driven Haskell |
    When I go to the home page
    And I follow "Test-Driven Haskell"
    And I follow "Register for this Workshop"
    Then I should see "$0"
    When I fill in the required workshop registration fields for "carlos@santana.com"
    And I press "Submit Payment"
    Then carlos@santana.com is registered for the Test-Driven Haskell workshop