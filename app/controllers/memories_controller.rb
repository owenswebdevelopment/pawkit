class MemoriesController < ApplicationController
  def index
    @family = Family.find(params[:family_id])
    @memory = Memory.new
    @memories = @family.memories
    @memories = @family.memories.includes(:user).order(created_at: :asc)
    #@memory = current_user.family
    #@memories = current_user.memories
  end

  def create
    @family = Family.find(params[:family_id])
    @memory = Memory.new(message_params)
    @memory.family = @family
    @memory.user = current_user
    if @memory.save!
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:memories, partial: "memories/memory",
            target: "memories",
            locals: { memory: @memory })
        end
        format.html { redirect_to family_memories_path(@family) }
      end
    else
      render "", status: :unprocessable_entity
    end
  end

private

def message_params
  params.require(:memory).permit(:text, media: [])
end
end
