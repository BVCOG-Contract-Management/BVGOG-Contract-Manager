class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  def sort_users
    # Sorts by the query string parameter "sort"
    asc = params[:order] ? params[:order] : "asc"
    users = params[:sort] ? User.order(params[:sort] => asc.to_sym) : User.order(created_at: :asc)
  end

  def search_users(users)
    # Search by the query string parameter "search"
    # Search in "first_name", "last_name"
    users.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
  end
end
