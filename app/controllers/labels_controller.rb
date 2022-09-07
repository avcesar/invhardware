class LabelsController < ApplicationController
	require 'prawn'
	require 'barby'
	require 'barby/barcode/qr_code'
	require 'barby/barcode/code_128'
	require 'barby/outputter/png_outputter'


	def index
		@cabinets = Cabinet.all
		@cabinet = Cabinet.new
		@page_title = "Select records for print label"
	end

	def print
		
		pdf = Prawn::Document.new
		row = 0

		@cabinets = Cabinet.find(params[:cabinet_ids])
		
		pdf.define_grid(:columns => 4, :rows => 7)

		@cabinets.each do |cabinet|
			@barcode_value = nil
			
			if !cabinet.serial_number.blank?
				@barcode_value = cabinet.serial_number
				@type_number = "Nro Serie"
			end
			
			if !cabinet.inventory_number.blank?
				@barcode_value = cabinet.inventory_number
				@type_number = "Nro Inv."
			end
			
			if !cabinet.serial_number.blank? || !cabinet.inventory_number.blank? 
				path_barcode = "#{Rails.root}/public/Image_codes/bc_#{@barcode_value}.png"
				barcode = Barby::Code128.new(@barcode_value)
				File.open(path_barcode, 'wb'){|f| f.write barcode.to_png(:margin => 3, :xdim => 2, :height => 55)}
			end

			@qrcode_value = "http://192.168.120.43:3000/cabinets/#{cabinet.id}"
			path_qr = "#{Rails.root}/public/Image_codes/qr_#{cabinet.id}.png"
			qrcode = Barby::QrCode.new(@qrcode_value, level: :q)
			File.open(path_qr, 'wb'){|f| f.write qrcode.to_png(:margin => 3, :xdim => 3)}

# compongo la version de PDF		
			#pdf.start_new_page if row % 7 == 0
			# pdf.grid([row,0],[row,3]).bounding_box do
			# 	pdf.stroke_bounds
			# end
			
			pdf.grid(row,0).bounding_box do
				pdf.image  path_qr, :width => 75, :height => 75
			end	

			pdf.grid([row,1],[row,2]).bounding_box do
				pdf.text 	"Nombre : " + cabinet.computersystem.name
				pdf.text 	@type_number +": "+@barcode_value
				pdf.text	"Este bien pertenece al Instituto Provincia de "
				pdf.text 	"Loterias y Casinos de la Provincia de Buenos Aires.-"

			end	
			
			pdf.grid(row,3).bounding_box do
				pdf.image  path_barcode , :width => 150, :height => 75
			end
			
			#pdf.grid([row,0], [row,3]).show
			row += 1

			if row % 7 == 0
				pdf.start_new_page
				row = 0
			end

		end
		send_data pdf.render, :type => "application/pdf", :disposition => "inline"
	end
end
