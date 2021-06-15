# frozen_string_literal: true
class TourbooksController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :set_tourbook, except: [:new, :create, :user_tourbooks, :show]
  before_action :set_user

  def show
    set_sort_params

    @tourbook = Tourbook.friendly.find(params[:id])
    @tours = @tourbook.tours.includes(:photos, :countries, :tags, :user)

    if @sort.present?
      @tours = @tours.order(:name) if @sort[:tours] == 'name'
      @tours = @tours.order(tourbooks_count: :desc) if @sort[:tours] == 'tourbooks_count'
    end
    @tours = @tours.order(created_at: :desc)
  end

  def new
    @tourbook = Tourbook.new
  end

  def create
    @tourbook = current_user.tourbooks.build(tourbook_params)
    authorize @tourbook

    respond_to do |format|
      if @tourbook.save
        add_item
        flash[:success] = 'You Tourbook was created!'
        format.html { redirect_to user_tourbooks_path }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def edit
    authorize @tourbook
  end

  def update
    authorize @tourbook

    if @tourbook.update(tourbook_params)
      flash[:success] = 'You Tourbook was updated!'
      redirect_to user_tourbook_path(@tourbook.user, @tourbook)
    else
      flash[:error] = @tourbook.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    authorize @tourbook

    @tourbook.destroy

    flash[:success] = "Tourbook #{@tourbook.name} was destroyed"
    redirect_to user_tourbooks_path(current_user)
  end

  def add_item
    authorize @tourbook

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])

      begin
        @tourbook.tours << @tour
        flash.now[:notice] = "Tour was added to your Tourbook #{@tourbook.name}"
      rescue ActiveRecord::RecordInvalid => e
        flash.now[:error] = e.message
      end
    end
  end

  def remove_item
    authorize @tourbook

    if params[:item_id].present?
      @tour = Tour.find(params[:item_id])
      begin
        @tourbook.tours.delete(@tour)
        flash[:success] = "Tour \"#{@tour.name}\" was removed from this Tourbook"
      rescue => e
        flash[:error] = e.message
      end
    end
  end

  def user_tourbooks
    @tourbooks = @user.tourbooks.includes(tours: [:photos])
    @tourbooks = @tourbooks.page(params[:page]).per(Constants::WEB_ITEMS_PER_PAGE[:tourbooks])
    render 'index'
  end

  private

  def set_tourbook
    @tourbook = Tourbook.friendly.find(params[:id])
  end

  def tourbook_params
    params.require(:tourbook).permit(*permitted_params)
  end

  def permitted_params
    [
        :name,
        :description
    ]
  end

  def set_user
    @user = if params[:user_id]
              User.friendly.find(params[:user_id])
            elsif params[:user]
              User.friendly.find(params[:id])
            else
              current_user
            end
  end

  def set_sort_params
    @sort = sort_params[:sort]
  end

  def sort_params
    params.permit(sort: [:tours])
  end
end
