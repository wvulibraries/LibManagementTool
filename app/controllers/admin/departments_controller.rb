# Department Controller
# ==================================================
# AUTHORS : David J. Davis
# Description:
# All interactions of controllers and permissions per page view
class Admin::DepartmentsController < AdminController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :allow_admin_only, only:[:create, :new, :destroy]
  before_action :users_can_edit_dept, only:[:show, :edit, :update]

  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.all.joins(:library).order('libraries.name')
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, success: 'Department was successfully created.' }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, success: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, success: 'Department was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
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

    # users_can_edit_dept
    # ==================================================
    # Name : David J. Davis
    # Date : 2/10/2017
    #
    # Modified : Tracy A. McCormick
    # Date : 3/09/2017
    #
    # Description:
    # If the user is not an admin, the next check sees if they have been given
    # permission to edit the details of the department.

    def users_can_edit_dept
      if (@user_depts != nil && (@user_depts.include? params[:id].to_s)) || check_is_admin
        true
      else
        redirect_to departments_url, error: 'You do not have permission to access this department.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :description, :library_id)
    end
end
