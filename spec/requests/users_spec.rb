require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",               :with => ""
          fill_in "Email",              :with => ""
          fill_in "Password",           :with => ""
          fill_in "Password Confirmation",       :with => ""
          click_button

          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",               :with => "Harvey Birdman"
          fill_in "Email",              :with => "harvey.birdman@example.com"
          fill_in "Password",           :with => "ill take the case"
          fill_in "Password Confirmation",       :with => "ill take the case"
          click_button

          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end

  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should not sign a user in and out" do
        integration_sign_in(Factory(:user))
        controller.should be_signed_in

        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe "User deletion" do
    it "should not display delete links for a regular user" do
      @user = Factory(:user)
      integration_sign_in(@user)
      controller.should be_signed_in

      visit users_path
      response.should_not have_selector("a", :content => "delete")
    end

    it "should display delete links for an admin user" do
      @admin = Factory(:user, :email => "admin@example.com", :admin => true)
      integration_sign_in(@admin)
      controller.should be_signed_in

      visit users_path
      response.should have_selector("a", :content => "delete")
    end
  end
  
  describe "Micropost deletion" do
    it "should not display delete links for another user" do
      @user = Factory(:user)
      @other_user = Factory(:user, :email => "bar@example.com")

      integration_sign_in(@user)
      controller.should be_signed_in

      visit users_path(@other_user)
      response.should_not have_selector("a", :content => "delete")
    end
  end
end

