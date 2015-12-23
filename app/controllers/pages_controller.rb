class PagesController < ApplicationController
  def main
    @link = Link.new
    @links = Link.all.order('created_at DESC')
  end

  def status
    @status = { success: 200 }
    respond_to do |format|
      format.json { @status }
    end
  end
end
