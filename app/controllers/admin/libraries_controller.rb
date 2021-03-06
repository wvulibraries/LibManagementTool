# Libraries Controller
# @author David J. Davis
# @author Tracy McCormick
# Sets data for views, sets redirects, sets errors

class Admin::LibrariesController < AdminController
  # Before action fires the method assigned to it before
  # other methods are called acting as a filter in some cases
  # or to apply data in a dry aspect in other cases
  before_action :set_library, only: [:show, :edit, :update, :destroy]
  before_action :allow_admin_only, only: [:create, :new, :destroy]
  before_action :users_can_edit_library, only: [:show,:edit,:update]

  # GET /libraries
  # GET /libraries.json
  def index
    @libraries = Library.all.order(:name)
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
  end

  # GET /libraries/new
  def new
    @library = Library.new
  end

  # GET /libraries/1/edit
  def edit
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        success_str = 'Library was successfully created.'
        format.html { redirect_to @library, success: success_str }
        format.json { render :show, status: :created, location: @library }
      else
        format.html { render :new }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libraries/1
  # PATCH/PUT /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        success_str = 'Library was successfully updated.'
        format.html { redirect_to @library, success: success_str }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.json
  def destroy
    @library.destroy
    respond_to do |format|
      success_str = 'Library was successfully destroyed.'
      format.html { redirect_to libraries_url, success: success_str }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find(params[:id])
    end

    # allow_admin_only
    # @author David J. Davis
    # @date 2/10/2017
    # @description
    # Users the admin controller to check if the user is an admin.
    # if not a flash message is added to the UI and the user is re-directed.
    def allow_admin_only
      error_string = 'You do not have admin access to edit, create, or delete users.'
      redirect_to libraries_path, error: error_string unless @check_access.admin?
    end

    # users_can_edit_library
    # @author David J. Davis
    # @date 9/26/2017
    # @description
    # checks if is admin or has granular permission 
    def users_can_edit_library
      error_str = 'You do not have permission to access this library.'
      redirect_to libraries_url, error: error_str unless @check_access.library_permission? params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_params
      params.require(:library).permit(:name, :description)
    end
end
