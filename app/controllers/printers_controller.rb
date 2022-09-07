class PrintersController < ApplicationController
  before_filter :authorize_admin!
  before_action :set_printer, only: [:show, :edit, :update, :destroy]

  # GET /printers
  # GET /printers.json
  def index
    @printers = Printer.all
    @page_title = 'Listing Printers'
  end

  # GET /printers/1
  # GET /printers/1.json
  def show
  end

  # GET /printers/new
  def new
    @printer = Printer.new
    @hardware_states = HardwareState.all
    @page_title = "New Printer"
  end

  # GET /printers/1/edit
  def edit
    @hardware_states = HardwareState.all
    @page_title = "Edit Printer"
  end

  # POST /printers
  # POST /printers.json
  def create
    @printer = Printer.new(printer_params)

    if @printer.save
    	respond_to do |format|
      	format.html { redirect_to @printer, notice: 'Printer was successfully created.' }
      	format.js { flash[:notice] = 'Printer was successfully created.'}
      end
    else
      @hardware_states = HardwareState.all
      render 'new'
    end
  end

  # PATCH/PUT /printers/1
  # PATCH/PUT /printers/1.json
  def update
    @page_title = "Edit Printer"

    if @printer.update(printer_params)
    	respond_to do |format|
	      format.html { redirect_to @printer, notice: 'Printer was successfully updated.' }
	      format.js { flash[:notice] = 'Printer was successfully updated.' }
      end
    else
    	render 'edit'
    end
  end

  # DELETE /printers/1
  # DELETE /printers/1.json
  def destroy
    @printer.destroy
    respond_to do |format|
      format.html { redirect_to printers_url, notice: 'Printer was successfully destroyed.' }
      format.js { flash[:alert] = 'Printer was successfully destroyed.'}
    end
  end

  def printerpdf

    @printers = Printer.find_by_sql(query_printer)

    pdf = Prawn::Document.new

    items = @printers.map do |printer|
      [
        printer.name,
        printer.location,
        printer.serial_number,
        printer.inventory_number,
        printer.hs_name
      ]
    end
    pdf.text "Printer Listing", :size => 20, :style => :bold, :align => :center
    pdf.table [["Name","Location","Serial Number","Inventory Number","State"]], :column_widths => 100
    pdf.table items, :column_widths => 100

    send_data pdf.render, :type => "application/pdf", :disposition => "inline"
  end

  
  private
  
    def query_printer
    return "SELECT pr.name, pr.location,pr.serial_number, pr.inventory_number,hs.name as hs_name
              FROM invhardware_development.printers pr
              left JOIN invhardware_development.hardware_states hs ON hs.id = pr.hardware_state_id
              order by pr.name"
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_printer
      @printer = Printer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def printer_params
      params.require(:printer).permit(:name, :location, :portname, :serial_number, :inventory_number, :comment, :hardware_state_id)
    end
end
