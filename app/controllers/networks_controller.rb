class NetworksController < ApplicationController
  before_filter :authorize_admin!
  before_action :set_network, only: [:show, :edit, :update, :destroy]

  # GET /networks
  # GET /networks.json
  def index
    @page_title = 'Listing networks'
    @networks = Network.all
  end

  # GET /networks/1
  # GET /networks/1.json
  def show
  end

  # GET /networks/new
  def new
    @network = Network.new
  end

  # GET /networks/1/edit
  def edit
  end

  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(network_params)
    if @network.save
    	respond_to do |format|
        format.html { redirect_to @network, notice: 'Network was successfully created.' }
        format.js { render 'create', status: :created, network: @network }
      end
    else
        render 'new'
    end
  end

  # PATCH/PUT /networks/1
  # PATCH/PUT /networks/1.json
  def update
		if @network.update(network_params)
			respond_to do |format|
        format.html { redirect_to network_path, notice: 'Network was successfully updated.' }
        format.js { render 'update', status: :updated, network: @network }
      end
    else
			render 'edit'    
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.json
  def destroy
    @network.destroy
    respond_to do |format|
    	format.js #-> loads /networks/destroy.js.erb
      format.html { redirect_to networks_url, notice: 'Network was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network
      @network = Network.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def network_params
      params.require(:network).permit(:net, :nameserver, :domain, :user, :password, :active)
    end
end
