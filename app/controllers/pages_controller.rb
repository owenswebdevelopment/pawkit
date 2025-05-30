class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    # if user_signed_in?
    #   if current_user.families.empty?
    #     redirect_to new_family_path
    #   else
    #     redirect_to families_path
    #   end
    # end
  end
end
