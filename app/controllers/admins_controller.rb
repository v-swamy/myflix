class AdminsController < ApplicationController
  before_action :require_user, :require_admin

  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You are not permitted to do that."
      redirect_to home_path
    end
  end
end

