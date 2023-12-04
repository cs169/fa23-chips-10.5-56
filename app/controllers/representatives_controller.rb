# frozen_string_literal: true

class RepresentativesController < ApplicationController
  def index
    @representatives = Representative.all
  end

  def show
    @representative = Representative.find(params[:id])
    render :show
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The representative can\'t be found'
    redirect_to representatives_path
  end
end
