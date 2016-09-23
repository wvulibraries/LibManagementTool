class Admin::NormalHoursController < AdminController
  before_action :set_normal_hour, only: [:show, :edit, :update, :destroy]

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
      if @normal_hour.update(normal_hour_params)
        format.html { redirect_to @normal_hour, notice: 'Normal hour was successfully updated.' }
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
      format.html { redirect_to normal_hours_url, notice: 'Normal hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_normal_hour
      @normal_hour = NormalHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def normal_hour_params
      params.require(:normal_hour).permit(:resource_type, :resource_id, :day_of_week, :open_time, :close_time)
    end
end
