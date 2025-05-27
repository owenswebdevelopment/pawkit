class FamiliesController < ApplicationController
  def index
    @family = Family.all
  end
end
