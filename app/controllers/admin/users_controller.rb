# Users
# @author David J. Davis
# Sets data for views, sets redirects, sets errors
class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :allow_admin_only, only: [:create, :new, :show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        success_str = 'User was successfully created.'
        format.html { redirect_to @user, success: success_str}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        success_str = 'User was successfully updated.'
        format.html { redirect_to @user, success: success_str }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      success_str = 'User was successfully destroyed.'
      format.html { redirect_to users_url, success: success_str }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def allow_admin_only
    error_string = 'You do not have admin access to edit, create, or delete users.'
    redirect_to users_path, error: error_string unless @check_access.admin?
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :admin)
  end
end
