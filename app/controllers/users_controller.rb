# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update redirect destroy redirect]

  # GET /users or /users.json
  def index
    add_breadcrumb 'Users', users_path

    # Sort users
    @users = sort_users.page params[:page]
    # Search users
    @users = search_users(@users) if params[:search].present?
  end

  # GET /users/1 or /users/1.json
  def show
    add_breadcrumb 'Users', users_path
    add_breadcrumb @user.full_name, user_path(@user)
  end

  # GET /users/new
  def new
    # Redirect to index, this page is not used
    redirect_to users_path, alert: 'You do not have permission to access this page.'
  end

  # GET /users/1/edit
  def edit
    if current_user.level != UserLevel::ONE
      redirect_to root_path, alert: 'You do not have permission to access this page.'
    end
    add_breadcrumb 'Users', users_path
    add_breadcrumb @user.full_name, user_path(@user)
    add_breadcrumb 'Edit', edit_user_path(@user)
  end

  # POST /users or /users.json
  # def create
  #  @user = User.new(user_params)
  #
  #  respond_to do |format|
  #    if @user.save
  #      format.html { redirect_to user_url(@user), notice: "User was successfully created." }
  #      format.json { render :show, status: :created, location: @user }
  #    else
  #      format.html { render :new, status: :unprocessable_entity }
  #      format.json { render json: @user.errors, status: :unprocessable_entity }
  #    end
  #  end
  # end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    add_breadcrumb 'Users', users_path
    add_breadcrumb @user.full_name, user_path(@user)
    add_breadcrumb 'Edit', edit_user_path(@user)

    respond_to do |format|
      OSO.authorize(current_user, 'edit', @user)
      # is_active passed as a string, this is why we check for "true" or "false"
      if current_user.id == @user.id && user_params[:is_active].present? && user_params[:is_active] == 'false'
        format.html { redirect_to user_url(@user), alert: 'You cannot deactivate yourself.' }
        format.json { render json: { error: 'You cannot deactivate yourself.' }, status: :unprocessable_entity }
      elsif @user.update(user_params)
        if user_params[:is_active].present? && user_params[:is_active] == 'true'
          # Remove redirect_user_id if user is being activated
          @user.update(redirect_user_id: nil)
        end
        if user_params[:redirect_user_id].present?
          @user.update(redirect_user_id: user_params[:redirect_user_id], is_active: false)
          format.html { redirect_to user_url(@user), notice: 'User was successfully redirected.' }
        else
          format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    rescue Oso::Error => e
      format.html { redirect_to user_url(@user), alert: 'You are not authorized to modify users.' }
      format.json { render json: { error: e.message }, status: :forbidden }
    end
  end

  # PUT /users/1/redirect
  def redirect
    respond_to do |format|
      OSO.authorize(current_user, 'edit', @user)
      # Cannot redirect active user
      if @user.is_active
        format.html { redirect_to user_url(@user), alert: 'User is active and cannot be redirected.' }
        format.json do
          render json: { error: 'User is active and cannot be redirected.' }, status: :unprocessable_entity
        end

      # Cannot redirect to self
      elsif @user.id == user_params[:redirect_user_id].to_i
        format.html { redirect_to user_url(@user), alert: 'User cannot be redirected to themselves.' }
        format.json do
          render json: { error: 'User cannot be redirected to themselves.' }, status: :unprocessable_entity
        end

      # Cannot redirect an already redirected user
      elsif @user.redirect_user_id.present?
        format.html { redirect_to user_url(@user), alert: 'User is already redirected.' }
        format.json { render json: { error: 'User is already redirected.' }, status: :unprocessable_entity }

      # Cannot redirect to a user that is already redirected
      elsif User.find(user_params[:redirect_user_id]).redirect_user_id.present?
        format.html { redirect_to user_url(@user), alert: 'User being redirected to is already redirected.' }
        format.json do
          render json: { error: 'User being redirected to is already redirected.' }, status: :unprocessable_entity
        end

      # Cannot redirect yourself
      elsif @user.id == current_user.id
        format.html { redirect_to user_url(@user), alert: 'You cannot redirect yourself.' }
        format.json { render json: { error: 'You cannot redirect yourself.' }, status: :unprocessable_entity }
      else
        # If no errors, redirect the user
        # Change point of contact for all of user's contracts to new user
        user_contracts = Contract.where(point_of_contact_id: @user.id)
        user_contracts.each do |contract|
          contract.update(point_of_contact_id: user_params[:redirect_user_id])
        end
        # Change user's redirect_user_id to new user
        @user.update(redirect_user_id: user_params[:redirect_user_id])

        format.html { redirect_to user_url(@user), notice: 'User was successfully redirected.' }
        format.json { render :show, status: :ok, location: @user }
      end
    rescue Oso::Error => e
      format.html { redirect_to user_url(@user), alert: 'You are not authorized to modify users.' }
      format.json { render json: { error: e.message }, status: :forbidden }
    end
  end

  # DELETE /users/1 or /users/1.json
  # def destroy
  #  @user.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to users_url, notice: "User was successfully destroyed." }
  #    format.json { head :no_content }
  #  end
  # end

  def reinvite
    @user = User.find(params[:id])
    if !@user.is_active
      redirect_to user_url(@user), alert: 'User is not active and cannot be re-invited.'
    else
      @user.invite!
      redirect_to user_url(@user), notice: 'User was successfully re-invited.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :level, :is_program_manager, :program_id,
                                 :redirect_user_id, :is_active, entity_ids: [])
  end

  def sort_users
    # Sorts by the query string parameter "sort"
    # Since some columns are combinations or associations, we need to handle them separately
    asc = params[:order] || 'asc'
    case params[:sort]
    when 'program'
      # Sort by the name of the program
      User.joins(:program).order("name #{asc}")
    else
      begin
        # Sort by the specified column and direction
        params[:sort] ? User.order(params[:sort] => asc.to_sym) : User.order(created_at: :asc)
      rescue ActiveRecord::StatementInvalid
        # Otherwise, sort by title
        # TODO: should we reconsider this?
        User.order(title: :asc)
      end
    end

    # Returns the sorted users
  end

  def search_users(users)
    # Search by the query string parameter "search"
    # Search in "first_name", "last_name"
    users.where('first_name LIKE ? OR last_name LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
  end
end
