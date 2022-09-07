class UsersController < ApplicationController
	before_filter :authorize_admin!, :except => [:login, :autenticar]
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def login
  	reset_session
  	@user = User.new
    respond_to do |format|
	    format.html # show.html.erb
	    format.xml  { render :xml => @user }
  	end
  end	

  def autenticar
  	@user = User.new
  	if @user.validar(params[:user][:user],params[:user][:password])
  		session[:usuario] = @user.nombre
  		session[:grupo] = @user.grupo
  		redirect_to :controller => 'cabinets', :action => 'index'
  	else
  		flash[:error] = 'Ohhh Noooo! Usuario y/o clave invalidos'
  		#redirect_to :controller => 'users', :action => 'login'
      render :template => 'users/login'
  	end	
  end

  def index
    @page_title = 'User Listing'
    @users = User.all
  end

  def show
    
  end

  def new
  	@user = User.new
  end

  def edit
    
  end

  def create
  	@user = User.new(user_params) 
  	if @user.save
  		respond_to do |format|
  			format.html { redirect_to @user, notice: 'User was successfully created.'}
  			format.js { render 'create', status: :created, user: @user }
  		end
  	else
  		render 'new'
  	end
  end

  def update
  	if @user.update(user_params)
  		respond_to do |format|
  			format.html { redirect_to user_path, notice: 'User was successfully updated.'}
  			format.js { render 'update', status: :updated, user: @user }
  		end
  	else
  		render 'edit'
  	end
  end

  def destroy
  	@user.destroy
    respond_to do |format|
    	format.js #-> loads /users/destroy.js.erb
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
    
  end


def userpdf
  @users = User.find_by_sql(query_user)

    pdf = Prawn::Document.new

    items = @users.map do |user|
      [
        user.user,
        user.lastname,
        user.name,
        user.smtp,
        user.pop3,
        user.password
      ]
    end
    pdf.text "User Listing", :size => 20, :style => :bold, :align => :center
    pdf.table [["User","Lastname","Name","SMTP","POP3","Password"]], :column_widths => 85
    pdf.table items, :column_widths => 85, :cell_style => { size: 9}

    send_data pdf.render, :type => "application/pdf", :disposition => "inline"
  
end

private
  def query_user
    return "SELECT us.user, us.lastname,us.name, us.smtp,us.pop3, us.password
              FROM invhardware_development.users us
              order by us.lastname"
    end
	
	def set_user
		@user = User.find(params[:id])
	end
  
  def user_params
      params.require(:user).permit(:user, :name, :lastname, :smtp, :pop3, :password)
  end
  
end
