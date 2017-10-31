# Normal Hours
# @author David J. Davis
# @author Tracy McCormick
# Sets data for views, sets redirects, sets errors

class Admin::NormalHoursController < AdminController

  before_action :set_normal_hour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rights, only: [:show, :edit, :update, :destroy]
  before_action :check_param_resource_access, only: [:create]

  # GET /admin/normal_hours
  # GET /admin/normal_hours.json
  def index
    @normal_hours = NormalHour.all
  end

  # GET /admin/normal_hours/1
  # GET /admin/normal_hours/1.json
  def show; end

  # GET /admin/normal_hours/new
  def new
    @normal_hour = NormalHour.new
  end

  # GET /admin/normal_hours/1/edit
  def edit; end

  # POST /admin/normal_hours
  # POST /admin/normal_hours.json
  def create
    @normal_hour = NormalHour.new(normal_hour_params)
    respond_to do |format|
      if @normal_hour.save
        notice_str = 'Normal hour was successfully created.'
        format.html { redirect_to @normal_hour, notice: notice_str }
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
      if @normal_hour.update(normal_hour_params)
        notice_str = 'Normal hour was successfully updated.'
        format.html { redirect_to @normal_hour, notice: notice_str }
        format.json { render :show, status: :ok, location: @normal_hour }
      else
        format.html { render :edit }
        format.json { render json: @normal_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/normal_hours/1
  # DELETE /admin/normal_hours/1.json
  def destroy
    @normal_hour.destroy
    respond_to do |format|
      notice_str = 'Normal hour was successfully destroyed.'
      format.html { redirect_to normal_hours_url, notice: notice_str }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_normal_hour
    @normal_hour = NormalHour.find(params[:id])
  end

  # check_param_resource_access
  # @author Tracy A. McCormick
  # @date 2/28/2017
  #
  # @description
  # Checks params to see if user has access to the library or department they
  # are trying to set
  def check_param_resource_access
    r_type = params[:normal_hour][:resource_type]
    r_id = params[:normal_hour][:resource_id]
    check_resource_access = (@check_access.granular_permission? r_type, r_id)
    error_str = 'You do not have permission to modify these normal hours.'
    redirect_to normal_hours_url, error: error_str unless check_resource_access
  end

  # authenticate_rights
  # @author David J. Davis
  # @date 10-20-2017
  # @description
  # check_access granular permissions check and error routing
  def authenticate_rights
    check_resource_access = (@check_access.granular_permission? @normal_hour.resource_type, @normal_hour.resource_id)
    error_str = 'You do not have permission create or modify these normal hours.'
    redirect_to normal_hours_url, error: error_str unless check_resource_access
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def normal_hour_params
    params.require(:normal_hour).permit(:resource_type, :resource_id, :day_of_week, :open_time, :close_time)
  end
end
