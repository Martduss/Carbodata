class DemoSessionsController < ApplicationController
  # Signs the visitor in as the fixed demo user, with no credentials involved.
  # `sign_in` is the same Warden/Devise helper the real login form calls after
  # checking a password — here we just skip that check for one hardcoded,
  # non-privileged account. No user/email is ever read from params, so this
  # can never be used to authenticate as an arbitrary account.
  def create
    demo_user = User.demo.first

    if demo_user
      sign_in(demo_user)
      redirect_to feed_path, notice: "Welcome! You're exploring Carbodata as our demo user."
    else
      redirect_to root_path, alert: "Demo access isn't available right now."
    end
  end

  # The demo account's dedicated exit: the generic Devise logout route stays
  # blocked (see ApplicationController#prevent_demo_account_changes) so no
  # ordinary-looking "log out" button appears anywhere in the app, but this
  # is the one deliberate way to end the demo session, so the visitor isn't
  # stuck permanently signed in with no way to sign up or log in for real.
  def destroy
    sign_out(current_user) if current_user&.demo?
    redirect_to home_path
  end
end
