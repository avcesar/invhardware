class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :set_locale
  protect_from_forgery with: :exception

	def set_locale
	  I18n.locale = params[:locale].to_sym
	end

	def authorize_admin!
		@user = User.new
		if session[:grupo] != 'GComputos'
			flash[:error] = 'No ha ingresado como usuario administrador'
			render :template => 'users/login'
		end	
	end

	def loglist
    render :template => 'shared/log'
  end

	def logclear
		File.open('app\controllers\wmilog.txt', "w")
  	render :template => 'shared/log'
	end
end
