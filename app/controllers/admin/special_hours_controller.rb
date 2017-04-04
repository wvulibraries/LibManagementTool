# Department Controller
# ==================================================
# AUTHORS : David J. Davis, Tracy A. McCormick
# Description:
# All interactions of controllers and permissions per page view

class Admin::SpecialHoursController < AdminController
  require 'time'
  before_action :set_special_hour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rights, only: [:show, :edit, :update, :destroy]

  # validate start_date and end_date
  before_action :check_date_range, only: [:create, :update]
  before_action :check_start_date, only: [:create, :update]
  before_action :check_end_date, only: [:create, :update]

  # GET /special_hours
  # GET /special_hours.json
  def index
    @special_hours = SpecialHour.all
  end

  # GET /special_hours/1
  # GET /special_hours/1.json
  def show
  end

  # GET /special_hours/new
  def new
    @special_hour = SpecialHour.new
  end

  # GET /special_hours/1/edit
  def edit
  end

  # POST /special_hours
  # POST /special_hours.json
  def create
    @special_hour = SpecialHour.new(special_hour_params)

    respond_to do |format|
      if @special_hour.save
        format.html { redirect_to @special_hour, notice: 'Special hour was successfully created.' }
        format.json { render :show, status: :created, location: @special_hour }
      else
        format.html { render :new }
        format.json { render json: @special_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /special_hours/1
  # PATCH/PUT /special_hours/1.json
  def update
    respond_to do |format|
      if check_params
        if @special_hour.update(special_hour_params)
          format.html { redirect_to @special_hour, notice: 'Special hour was successfully updated.' }
          format.json { render :show, status: :ok, location: @special_hour }
        else
          format.html { render :edit }
          format.json { render json: @special_hour.errors, status: :unprocessable_entity }
        end
      else
         format.html { redirect_back(fallback_location: special_hours_url, error: "Error: Access to this department or library has been denied.") }
         format.json { render json: @special_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_hours/1
  # DELETE /special_hours/1.json
  def destroy
    @special_hour.destroy
    respond_to do |format|
      format.html { redirect_to special_hours_url, notice: 'Special hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_hour
      @special_hour = SpecialHour.find(params[:id])
    end

    # check_date_range
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 4/4/2017
    #
    # Description:
    # Throws an error if the end_date is before start_date.
    def check_date_range
      if !(Time.parse(params[:special_hour][:start_date]) <= Time.parse(params[:special_hour][:end_date]))
        redirect_back(fallback_location: special_hours_url, error: "End Date Cannot be before Start Date")
      end
    end

    # check_date_range
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 4/4/2017
    #
    # Description:
    # returns true if date_to_check is found in any set special_hour
    def check_date(date_to_check)
      start_date = Time.parse(date_to_check)
      SpecialHour.where('special_id = ?', params[:special_hour][:special_id]).where('special_type = ?', params[:special_hour][:special_type]).where('start_date <= ?', start_date).where('end_date >= ?', start_date).exists?
    end

    # check_end_date
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 3/30/2017
    #
    # Description:
    # Throws an error if the end_date is already set in another special_hour for this resource.
    def check_start_date
      if check_date(params[:special_hour][:start_date])
        redirect_back(fallback_location: special_hours_url, error: "Start Date overlaps currently set special hour.")
      end
    end

    # check_end_date
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 3/30/2017
    #
    # Description:
    # Throws an error if the end_date is already set in another special_hour for this resource.
    def check_end_date
      if check_date(params[:special_hour][:end_date])
        redirect_back(fallback_location: special_hours_url, error: "End Date overlaps currently set special hour.")
      end
    end

    # user_has_access
    # ==================================================
    # Name : Tracy A. McCormick
    # Date : 2/22/2017
    #
    # Description:
    # Checks to see if the user has access to the library or department.
    def user_has_access
      if !check_is_admin && !@special_hour.nil?
        CheckAccess.initialize(@user_depts, @user_libs)
        CheckAccess.check(@special_hour.special_type.to_s, @special_hour.special_id.to_s)
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
      if !check_is_admin && params[:special_hour].present?
        CheckAccess.initialize(@user_depts, @user_libs)
        CheckAccess.check(params[:special_hour][:special_type], params[:special_hour][:special_id])
      else
        true
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
        redirect_back(fallback_location: special_hours_url, error: "You do not have permission to access this resource.")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_hour_params
      params.require(:special_hour).permit(:start_date, :end_date, :name, :open_time, :close_time, :open_24, :no_close_time, :no_open_time, :special_type, :special_id)
    end
end
