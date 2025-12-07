class PlantLogsController < ApplicationController
  before_action :set_plant_log, only: %i[ show edit update destroy ]

  # GET /plant_logs or /plant_logs.json
  def index
    @plant_logs = PlantLog.all
  end

  # GET /plant_logs/1 or /plant_logs/1.json
  def show
  end

  # GET /plant_logs/new
  def new
    @plant_log = PlantLog.new
  end

  # GET /plant_logs/1/edit
  def edit
  end

  # POST /plant_logs or /plant_logs.json
  def create
    @plant_log = PlantLog.new(plant_log_params)

    respond_to do |format|
      if @plant_log.save
        format.html { redirect_to @plant_log, notice: "Plant log was successfully created." }
        format.json { render :show, status: :created, location: @plant_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plant_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plant_logs/1 or /plant_logs/1.json
  def update
    respond_to do |format|
      if @plant_log.update(plant_log_params)
        format.html { redirect_to @plant_log, notice: "Plant log was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @plant_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plant_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plant_logs/1 or /plant_logs/1.json
  def destroy
    @plant_log.destroy!

    respond_to do |format|
      format.html { redirect_to plant_logs_path, notice: "Plant log was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant_log
      @plant_log = PlantLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def plant_log_params
      params.expect(plant_log: [ :plant_id, :watered, :image ])
    end
end
