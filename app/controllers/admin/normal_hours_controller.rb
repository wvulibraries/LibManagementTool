# Department Controller
# ==================================================
# AUTHORS : David J. Davis, Tracy A. McCormick
# Description:
# All interactions of controllers and permissions per page view

class Admin::NormalHoursController < AdminController

  #include ActiveModel::Validations

  before_action :set_normal_hour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rights, only: [:show, :edit, :update, :destroy]
  #validate :validate_params, on: :save

  # GET /admin/normal_hours
  # GET /admin/normal_hours.json
  def index
    @normal_hours = NormalHour.all
  end

  # GET /admin/normal_hours/1
  # GET /admin/normal_hours/1.json
  def show
  end

  # GET /admin/normal_hours/new
  def new
    @normal_hour = NormalHour.new
  end

  # GET /admin/normal_hours/1/edit
  def edit
  end

  # POST /admin/normal_hours
  # POST /admin/normal_hours.json
  def create
    @normal_hour = NormalHour.new(normal_hour_params)

    respond_to do |format|
      if @normal_hour.save
        format.html { redirect_to @normal_hour, notice: 'Normal hour was successfully created.' }
        format.json { render :show, status: :created, location: @normal_hour }
      else
        format.html { render :new }
        format.json { render json: @normal_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/normal_hours/1
  # PATCH/PUT /admin/normal_hours/1.json
  def update
    respond_to do |format|
      if check_params
        if @normal_hour.update(normal_hour_params)
          format.html { redirect_to @normal_hour, notice: 'Normal hour was successfully updated.' }
          format.json { render :show, status: :ok, location: @normal_hour }
        else
          format.html { render :edit }
          format.json { render json: @normal_hour.errors, status: :unprocessable_entity }
        end
      else
         format.html { redirect_back(fallback_location: normal_hours_url, error: "Error: Acccess to this department or library has been denied.") }
         format.json { render json: @normal_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/normal_hours/1
  # DELETE /admin/normal_hours/1.json
  def destroy
    @normal_hour.destroy
    respond_to do |format|
      format.html { redirect_to normal_hours_url, notice: 'Normal hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_normal_hour
      @normal_hour = NormalHour.find(params[:id])
    end

    # user_has_access
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 2/22/2017
    #
    # Description:
    # Checks to see if the user has access to the library or department.
    def user_has_access
      if !check_is_admin
        if !@normal_hour.nil?
          if (@normal_hour.resource_type === 'library')
           @user_libs.include? @normal_hour.resource_id.to_s
          elsif (@normal_hour.resource_type === 'department')
            @user_depts.include? @normal_hour.resource_id.to_s
          else
            false
          end
        end
      else
        true
      end
    end

    # check_params
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 2/28/2017
    #
    # Description:
    # Checks params to see if user has access to the library or department they are trying to set
    def check_params
      if (params[:resource_type] === 'library')
        @user_libs.include? params[:resource_id].to_s
      elsif (params[:resource_type] === 'department')
        @user_depts.include? params[:resource_id].to_s
      else
        false
      end
    end

    # authenticate_rights
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 2/22/2017
    #
    # Description:
    # Calls user_has_access to see if they have access to the library or department. Also checks to see if they are admin.
    # If neither of these are true it redirects them back to there previous page and shows them an error.
    def authenticate_rights
      if user_has_access
        true
      else
        redirect_back(fallback_location: normal_hours_url, error: "You do not have permission to access this resource.")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def normal_hour_params
       params.require(:normal_hour).permit(:resource_type, :resource_id, :day_of_week, :open_time, :close_time)
    end
end
