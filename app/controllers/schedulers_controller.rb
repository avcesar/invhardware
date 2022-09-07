class SchedulersController < ApplicationController
	before_filter :authorize_admin!
  before_action :set_scheduler, only: [:show, :edit, :update, :destroy]

	def index
		@page_title = "Scheduler Listing"
		@schedulers = Scheduler.all
	end

	def edit
		@page_title = "Scheduler editing"
		@scheduler = Scheduler.find(params[:id])
	end

	def update
		if @scheduler.update(scheduler_params)
			respond_to do |format|
				format.html { redirect_to @scheduler, notice: 'Scheduler was successfully updated.' }
				format.js { flash[:notice] = 'Scheduler was successfully updated.'}
      end
    else
      render 'edit'
    end
	end

	def set_scheduler
		@scheduler = Scheduler.find(params[:id])
	end

    # Never trust parameters from the scary internet, only allow the white list through.
	def scheduler_params
		params.require(:scheduler).permit(:next_service_date, :cabinet_id, :frecuency)
	end
end
