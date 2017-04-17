# User Permissions
# @author David J. Davis
# Sets data for views, sets redirects, sets errors
class Admin::UserPermissionsController < AdminController
  before_action :set_admin_user_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_option_groups, only:[:edit, :create, :new]
  before_action :allow_admin_only, only: [:create, :new, :show, :edit, :update, :destroy]


  # GET /admin/user_permissions
  # GET /admin/user_permissions.json
  def index
    @admin_user_permissions = UserPermission.all
  end

  # GET /admin/user_permissions/1
  # GET /admin/user_permissions/1.json
  def show
  end

  # GET /admin/user_permissions/new
  def new
    @admin_user_permission = UserPermission.new
  end

  # GET /admin/user_permissions/1/edit
  def edit
    @users = User.all
  end

  # POST /admin/user_permissions
  # POST /admin/user_permissions.json
  def create
    @admin_user_permission = UserPermission.new(admin_user_permission_params)

    respond_to do |format|
      if @admin_user_permission.save
        format.html { redirect_to @admin_user_permission, success: 'User permission was successfully created.' }
        format.json { render :show, status: :created, location: @admin_user_permission }
      else
        format.html { render :new, error: 'User permissions has errors, please correct them.' }
        format.json { render json: @admin_user_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/user_permissions/1
  # PATCH/PUT /admin/user_permissions/1.json
  def update
    respond_to do |format|
      if @admin_user_permission.update(admin_user_permission_params)
        format.html { redirect_to @admin_user_permission, notice: 'User permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_user_permission }
      else
        format.html { render :edit, error: 'User permission form has errors, please correct them.' }
        format.json { render json: @admin_user_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/user_permissions/1
  # DELETE /admin/user_permissions/1.json
  def destroy
    @admin_user_permission.destroy
    respond_to do |format|
      format.html { redirect_to user_permissions_url, success: 'User permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_user_permission
    @admin_user_permission = UserPermission.find(params[:id])
  end

  # set_option_groups
  # @author David J. Davis
  # @return hash of libraries from by library id
  # @description used to create option groups in lists or multi-selects
  def set_option_groups
    @libraries = Library.joins(:departments).group('libraries.id').having( 'count( library_id ) >= 1')
  end

  # allow_admin_only 
  # @author David J. Davis
  # @return boolean
  def allow_admin_only
    if !check_is_admin
      redirect_to users_path, error: 'You do not have admin access to edit, create, or delete user permissions in this application.'
    else
      true
    end
  end

  # set_option_groups
  # @author David J. Davis
  # @description only allows certain permaters in the controller for security stuff
  def admin_user_permission_params
    params.require(:user_permission).permit(:username, libraries: [], departments: [])
  end
end
