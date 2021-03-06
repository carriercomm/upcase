require "rails_helper"

describe "plans/_plan.html" do
  context "grid partial" do
    it "renders the grid partial matching the plan" do
      the_weekly_iteration = build_plan
      stub_view

      render_plan(the_weekly_iteration)

      expect(view).to render_template("plans/_the_weekly_iteration")
    end
  end

  context "popular plan" do
    it "adds the 'popular' class to the plan designated as popular" do
      plan = build_plan
      allow(plan).to receive(:popular?).and_return(true)
      stub_view

      render_plan(plan)

      expect(rendered).to have_css(".popular")
    end

    it "does not add the 'popular' class to plans not designated as popular" do
      plan = build_plan
      stub_view

      render_plan(plan)

      expect(rendered).not_to have_css(".popular")
    end
  end

  context "plan link" do
    it "links to create a new plan if the user does not have a subscription" do
      plan = build_plan
      stub_view

      render_plan(plan)

      link = new_checkout_path(plan)
      expect(rendered).to have_css("a[href='#{link}']")
    end

    it "links to change existing plan when user has a subscription" do
      plan = build_plan
      user = double("user", plan: build_stubbed(:plan))
      view_stubs(:current_user).and_return(user)
      stub_view(active_subscription: true)

      render_plan(plan)

      link = subscription_path(plan_id: plan.sku)
      expect(rendered).to have_css("a[href='#{link}']")
    end
  end

  def stub_view(active_subscription: false)
    view_stubs(:current_user_has_active_subscription?).
      and_return(active_subscription)
  end

  def build_plan
    build_stubbed(:plan, sku: Plan::THE_WEEKLY_ITERATION_SKU).tap do |plan|
      allow(plan).to receive(:popular?).and_return(false)
    end
  end

  def render_plan(plan)
    render "plans/plan", plan: plan
  end
end
