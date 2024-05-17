class ItemsController < ApplicationController
  def results
    @items = policy_scope(Item)
    respond_to do |format|
      format.html
      format.text { render partial: 'items/results', locals: { items: @items }, formats: [:html] }
    end
  end
end
