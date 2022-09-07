class PrinterServicesController < ApplicationController
  require 'mailer.rb'
	before_filter :authorize_admin!
  before_action :set_printer_service, only: [:show, :edit, :update, :destroy]

  def index
    @page_title = "Listing Printer Services"
    @printer_services = PrinterService.all
  end

  def new
    @page_title = "New Printer Service"
    @printer_service = PrinterService.new
    @printer = Printer.find(params[:printer_id])
    @user = User.find_by(user: session[:usuario].to_s.downcase)
    @states = State.all
    @typeservices = TypeService.all
  end

  def create
    @printer_service = PrinterService.new(printer_service_params)
    @printer_service.user_id = User.find_by(user: session[:usuario].to_s).id
    @printer_service.solution_user_id = @printer_service.user_id if @printer_service.state_id != 1 # estado abierto
    
    if @printer_service.save

      @evento = " Nuevo"
      @service = @printer_service
      envio(@service,@evento)
      
      respond_to do |format|
        format.html { redirect_to @printer_service, notice: 'Service was successfully created.' }
        format.js { flash[:notice] = 'Service was successfully created.'}
      end
    else
      @printer = Printer.find(params[:printer_id])
      @states = State.all
      @typeservices = TypeService.all
      render 'new'
    end
  end

  def show
  end

  def edit
  	@page_title = "Edit Service"
    @user = User.find(@printer_service.user_id)
    @usersol = User.find(@printer_service.solution_user_id) if @printer_service.solution_user_id
    @printer = Printer.find(@printer_service.printer_id)
    @states = State.all
    @typeservices = TypeService.all
  end

  def update
    @printer_service.solution_user_id = User.find_by(user: session[:usuario].to_s).id if params[:state_id] != 1 # estado abierto
		if @printer_service.update(printer_service_params)

      @evento = " Actualizacion de"
      @service = @printer_service
      envio(@service,@evento)

			respond_to do |format|
				format.html { redirect_to @printer_service, notice: 'Service was successfully updated.' }
				format.js { flash[:notice] = 'Service was successfully updated.'}
      end
    else
      render 'edit'
    end
  end

  def destroy
		@printer_service.destroy
    respond_to do |format|
      format.html { redirect_to printer_services_url, notice: 'Service was successfully destroyed.' }
      format.js { flash[:alert] = 'Service was successfully destroyed.'}
    end
  end

  def view
    @printer_services = PrinterService.find_by(printer_id: params[:id])
    @printer = Printer.find(params[:id])
    @page_title = 'Printer service list for ' + @printer.name
  end

  def set_printer_service
    @printer_service = PrinterService.find(params[:id])
  end

  def printer_service_params
  	params.require(:printer_service).permit(:title, :state_id, :creation_date, :solution_date, :problem, :solution, :user_id, :solution_user_id, :printer_id, :typeservice_id)
  end
end
