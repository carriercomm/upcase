require "rails_helper"

describe "users/edit.html.erb" do
  it "includes an invoice link" do
    setup_user_with_deactivated_subscription

    render template: "users/edit"

    expect(rendered).to include("View all invoices")
  end

  def setup_user_with_deactivated_subscription
    subscription = build_stubbed(:team_subscription, deactivated_on: 1.day.ago)
    user = build_stubbed(:user, subscriptions: [subscription])
    view_stubs(:current_user).and_return(user)
    view_stubs(:current_team).and_return(user.team)
  end
end
