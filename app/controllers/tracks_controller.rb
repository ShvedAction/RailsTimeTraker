class TracksController < ApplicationController
  before_action :set_track, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /users/1/tracks
  # GET /users/1/tracks.json
  def index
    @tracks = @user.tracks.all
  end

  # GET /users/1/tracks/1
  # GET /users/1/tracks/1.json
  def show
  end

  # GET /users/1/tracks/new
  def new
    @track = Track.new
  end

  # GET /users/1/tracks/1/edit
  def edit
  end

  # POST /users/1/tracks
  # POST /users/1/tracks.json
  def create
    @track = @user.tracks.new(track_params)

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render :show, status: :created, location: @track }
      else
        format.html { render :new }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1/tracks/1
  # PATCH/PUT /users/1/tracks/1.json
  def update
    respond_to do |format|
      if @track.update(track_params)
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { render :show, status: :ok, location: @track }
      else
        format.html { render :edit }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1/tracks/1
  # DELETE /users/1/tracks/1.json
  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to user_tracks_url @user, notice: 'Track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def track_url track
    user_tracks_url track.user
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end
    
    def set_user
      @user = User.find params[:user_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:start_time, :end_time, :total_time, :tag, :work_type, :user_id)
    end
end
