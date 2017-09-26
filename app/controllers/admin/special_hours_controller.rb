# Special Hours
# @author David J. Davis
# @author Tracy McCormick
# Sets data for views, sets redirects, sets errors

class Admin::SpecialHoursController < AdminController
  before_action :set_special_hour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rights, only: [:show, :edit, :update, :destroy]
  before_action :check_param_resource_access, only: [:create]

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
        success_str = 'Special hour was successfully created.'
        format.html { redirect_to @special_hour, success: success_str }
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
      if check_param_resource_access
        if @special_hour.update(special_hour_params)
          success_str = 'Special hour was successfully updated.'
          format.html { redirect_to @special_hour, success: success_str }
          format.json { render :show, status: :ok, location: @special_hour }
        else
          format.html { render :edit }
          format.json { render json: @special_hour.errors, status: :unprocessable_entity }
        end
      else
        error_str = 'Error: Access to this department or library has been denied.'
        format.html { redirect_back(fallback_location: special_hours_url, error: error_str) }
        format.json { render json: @special_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_hours/1
  # DELETE /special_hours/1.json
  def destroy
    @special_hour.destroy
    respond_to do |format|
      success_str = 'Special hour was successfully destroyed.'
      format.html { redirect_to special_hours_url, success: success_str }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_special_hour
    @special_hour = SpecialHour.find(params[:id])
  end

  # check_date_range
  # @author : Tracy A. McCormick
  # @date 4/4/2017
  #
  # @description
  # Throws an error if the end_date is before start_date.
  def check_date_range
    if params[:special_hour][:start_date].present? && params[:special_hour][:end_date].present?
      if !(Date.parse(params[:special_hour][:start_date]) <= Date.parse(params[:special_hour][:end_date]))
        error_str = 'End Date Cannot be before Start Date'
        redirect_back(fallback_location: special_hours_url, error: error_str)
      end
    else
      false
    end
  end

  # check_date
  # @author : Tracy A. McCormick
  # @date 4/4/2017
  #
  # @description
  # returns true if date_to_check is found in any set special_hour
  def check_date(date_to_check)
    if !date_to_check.nil?
      check = Date.parse(date_to_check)
      SpecialHour.where.not(id: params[:id]).where('special_id = ?', params[:special_hour][:special_id]).where('special_type = ?', params[:special_hour][:special_type]).where('start_date <= ?', check).where('end_date >= ?', check).exists?
    else
      false
    end
  end

  # check_start_date
  # @author : Tracy A. McCormick
  # @date 3/30/2017
  #
  # @description
  # Throws an error if the end_date is already set in another special_hour
  # for this resource.
  def check_start_date
      error_str = 'Start Date overlaps currently set special hour.'
      redirect_back(fallback_location: special_hours_url, error: error_str) unless check_date(params[:special_hour][:start_date])
  end

  # check_end_date
  # @author : Tracy A. McCormick
  # @date 3/30/2017
  #
  # @description
  # Throws an error if the end_date is already set in another special_hour for
  # this resource.
  def check_end_date
    error_str = 'End Date overlaps currently set special hour.'
    redirect_back(fallback_location: special_hours_url, error: error_str) unless check_date(params[:special_hour][:end_date])
  end

  # check_param_resource_access
  # @author : Tracy A. McCormick
  # @date 2/28/2017
  #
  # @description
  # Checks params to see if user has access to the library or department they
  # are trying to set
  def check_param_resource_access
    type = params[:special_hour][:special_type]
    id = params[:special_hour][:special_id]
    check_resource_access = @check_access.granular_permission? type,id 
    error_st = "You do not have permission to modify these special hours."
    redirect_back fallback_location: special_hours_url, error: error_str unless check_resource_access
  end

  # authenticate_rights
  # @author : Tracy A. McCormick
  # @date 2/22/2017
  #
  # @description
  # Calls user_has_access to see if they have access to the library or
  # department. Also checks to see if they are admin. If neither of these are
  # true it redirects them back to there previous page and shows them an error.
  def authenticate_rights
    check_resources_access = @check_access.granular_permission? @special_hour.special_type, @special_hour.special_id
    error_str = 'You do not have permission update these special hours.'
    redirect_back fallback_location: special_hours_url, error: error_str unless check_resource_access
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def special_hour_params
    params.require(:special_hour).permit(:start_date, :end_date, :name, :open_time, :close_time, :open_24, :no_close_time, :no_open_time, :special_type, :special_id)
  end
end
