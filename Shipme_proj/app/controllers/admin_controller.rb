class AdminController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def list
    @packages = Packages.view_shipments
  end

  def show
  end

  def delete
  end

  def destory
  end
end