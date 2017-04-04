class Admin::SpecialHoursController < AdminController
  before_action :set_special_hour, only: [:show, :edit, :update, :destroy]

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
        format.html { redirect_to @special_hour, success: 'Special hour was successfully created.' }
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
      if @special_hour.update(special_hour_params)
        format.html { redirect_to @special_hour, success: 'Special hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @special_hour }
      else
        format.html { render :edit }
        format.json { render json: @special_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_hours/1
  # DELETE /special_hours/1.json
  def destroy
    @special_hour.destroy
    respond_to do |format|
      format.html { redirect_to special_hours_url, success: 'Special hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_hour
      @special_hour = SpecialHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_hour_params
      params.require(:special_hour).permit(:start_date, :end_date, :name, :open_time, :close_time, :open_24, :no_close_time, :no_open_time, :special_type, :special_id)
    end
end
