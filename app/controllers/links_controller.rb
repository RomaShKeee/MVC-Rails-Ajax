class LinksController < ApplicationController
  def index
  end

  def new
    @link = LineItem.new
  end

  def create
    @link = Link.new(link_params)
    respond_to do |format|
      if @link.save
        format.html { redirect_to root_path }
        format.js { @link }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render root_path }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
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

    def link_params
        params.require(:link).permit(:url)
    end

end
