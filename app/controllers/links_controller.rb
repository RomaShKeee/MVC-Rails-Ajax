class LinksController < ApplicationController
  before_action :set_link_item, only: [:show, :destroy]
  def index
    @links = Link.all.order('created_at DESC')
    respond_to do |format|
      format.html { @links }
      format.json { @links }
    end
  end

  def new
    @link = LineItem.new
  end

  def show

  end

  def create
    @link = Link.new(link_params)
    url = @link.parse_url(@link.url)
    item = Link.find_by_url(url)
    item.destroy if item
    unless @link.save
      flash.now[:notice] = "Your link couldn't be saved: #{ @link.errors.full_messages.join(', ') }."
    end
    respond_to do |format|
      if @link.save
        format.html { redirect_to root_path }
        format.js { @link }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { redirect_to root_path, notice: "It's not a url"}
        format.js {}
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def clear_all
    Link.delete_all
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'All Links was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_link_item
      @link = Link.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:url)
    end

end
