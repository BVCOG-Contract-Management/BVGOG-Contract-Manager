class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update redirect destroy ]

  # GET /users or /users.json
  def index
    add_breadcrumb "Users", users_path

    # Sort users
    @users = sort_users().page params[:page]
    # Search users
    @users = search_users(@users) if params[:search].present?
  end

  # GET /users/1 or /users/1.json
  def show
    add_breadcrumb "Users", users_path
    add_breadcrumb @user.full_name, user_path(@user)
  end

  # GET /users/new
  def new
    add_breadcrumb "Users", users_path
    add_breadcrumb "Invite User", new_user_path

    @user = User.new
  end

  # GET /users/1/edit
  def edit
    add_breadcrumb "Users", users_path
    add_breadcrumb @user.full_name, user_path(@user)
    add_breadcrumb "Edit", edit_user_path(@user)
  end

  # GET /users/1/redirect
  def redirect
    add_breadcrumb "Users", users_path
    add_breadcrumb @user.full_name, user_path(@user)
    add_breadcrumb "Redirect", redirect_user_path(@user)

    @users = User.where.not(id: @user.id).where(is_active: true)
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    add_breadcrumb "Users", users_path
    add_breadcrumb @user.full_name, user_path(@user)
    add_breadcrumb "Edit", edit_user_path(@user)

    respond_to do |format|
      begin
        OSO.authorize(current_user, 'edit', @user)
        if @user.update(user_params)
          if user_params[:redirect_user_id].present?
            @user.update(redirect_user_id: user_params[:redirect_user_id], is_active: false)
            format.html { redirect_to user_url(@user), notice: "User was successfully redirected." }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
            format.json { render :show, status: :ok, location: @user }
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      rescue Oso::Error => e
        format.html { redirect_to user_url(@user), alert: "You are not authorized to modify users." }
        format.json { render json: { error: e.message }, status: :forbidden }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :level, :is_program_manager, :program_id, :redirect_user_id, :is_active, :entity_ids => [])
  end

  def sort_users
    # Sorts by the query string parameter "sort"
    # Since some columns are combinations or associations, we need to handle them separately
    asc = params[:order] ? params[:order] : "asc"
    users = case params[:sort]
      when "program"
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
    users
  end

  def search_users(users)
    # Search by the query string parameter "search"
    # Search in "first_name", "last_name"
    users.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
  end
end
