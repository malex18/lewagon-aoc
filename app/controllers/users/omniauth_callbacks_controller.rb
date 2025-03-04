# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def kitt
      @user = User.from_kitt(request.env["omniauth.auth"])
      @contact_me = view_context.link_to(
        "contact Pilou",
        "slack://user?team=T02NE0241&id=URZ0F4TEF",
        class: "underline"
      )

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        flash.notice = "Successfully signed in with Kitt!"
      else
        redirect_to root_path
        flash.alert = "For an unknown reason, we couldn't store your information in our database. Please #{@contact_me}."
      end

      def failure
        reason = request.env["omniauth.auth"]&.error_description
        redirect_to root_path
        flash.alert = "Failed to sign in with Kitt (Reason: #{reason || 'Unknown'}). If it persists, please #{@contact_me}."
      end
    end
  end
end
