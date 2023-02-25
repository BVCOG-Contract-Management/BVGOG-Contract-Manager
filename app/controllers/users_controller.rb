class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    add_breadcrumb "Users", users_path

    @users = User.all
    # Order by "sort" parameter in the query string
    if params[:sort]
      sort_users
    end
  end

  # GET /users/1 or /users/1.json
  def show
    add_breadcrumb "Users", users_path
    add_breadcrumb @user.first_name + " " + @user.last_name, user_path(@user)
  end

  # GET /users/new
  def new
    add_breadcrumb "Users", users_path
    add_breadcrumb "New User", new_user_path

    @user = User.new
  end

  # GET /users/1/edit
  def edit
    add_breadcrumb "Users", users_path
    add_breadcrumb @user.first_name + " " + @user.last_name, user_path(@user)
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
      params.fetch(:user, {})
    end

    def sort_users
      # Sorts by the query string parameter "sort"
      # Since some columns are combinations or associations, we need to handle them separately
      asc = session[:users_sort_by] == params[:sort] && session[:users_sort_order] == "asc" ? "desc" : "asc"
      @users = User.order(params[:sort] => asc.to_sym)
  
      # Reverses the order if the user clicked the same column again
      if params[:sort] == @sort_by
        @users = @users.reverse_order
      end
  
      # Stores the current sort order
      session[:users_sort_by] = params[:sort]
      session[:users_sort_order] = asc
    end
end
