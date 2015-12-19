class PagesController < ApplicationController
  def main
    @link = Link.new
    @links = Link.all.order('created_at DESC')
  end
end
