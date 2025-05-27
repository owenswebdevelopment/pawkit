class MemoriesController < ApplicationController

  def index
   @memories = Memory.all
  #  @memories = current_user.memories
  end

# def create

# end
end
