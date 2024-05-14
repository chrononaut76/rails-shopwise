class StoresController < ApplicationController
  def results
    # @stores = Store.where(?)
    authorize @stores
  end
end
