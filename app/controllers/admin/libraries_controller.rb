# Library Controller
# ==================================================
# AUTHORS : David J. Davis
# Description:
# All interactions of controllers and permissions per page view

class Admin::LibrariesController < AdminController
  # Before action fires the method assigned to it before
  # other methods are called acting as a filter in some cases
  # or to apply data in a dry aspect in other cases
  before_action :set_library, only: [:show, :edit, :update, :destroy]
  before_action :allow_admin_only, only:[:create, :new, :destroy]
  before_action :users_can_edit_library, only:[:show,:edit,:update]

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
        format.html { redirect_to @library, success: 'Library was successfully created.' }
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
        format.html { redirect_to @library, success: 'Library was successfully updated.' }
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
      format.html { redirect_to libraries_url, success: 'Library was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find(params[:id])
    end

    # allow_admin_only
    # ==================================================
    # Name : David J. Davis
    # Date : 2/10/2017
    #
    # Description:
    # Users the admin controller to check if the user is an admin.
    # if not a flash message is added to the UI and the user is re-directed.

    def allow_admin_only
      if !check_is_admin
        redirect_to libraries_url, error: 'You do not have admin access to create or delete libraries.'
      else
        true
      end
    end

    # users_can_edit_library
    # ==================================================
    # Name : David J. Davis
    # Date : 2/10/2017
    #
    # Modified : Tracy A. McCormick
    # Date : 2/22/2017
    #
    # Description:
    # If the user is not an admin, the next check sees if they have been given
    # permission to edit the details of the library.
    def users_can_edit_library
      if @user_libs.to_a.include? params[:id].to_s || check_is_admin
        true
      else
        redirect_to libraries_url, error: 'You do not have permission to access this library.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_params
      params.require(:library).permit(:name, :description)
    end
end
