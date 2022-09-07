require 'rubygems'
require 'net/smtp'
require 'date'

SMTP_SERVER = 'exchng2k10.central.loteria.gba.gov.ar'
  
DESTINATARIOS = 'estebces@central.loteria.gba.gov.ar '#,'avcesar@hotmail.com '
#DESTINATARIOS = 'estebces@central.loteria.gba.gov.ar ','dipaunor@central.loteria.gba.gov.ar ','toffedan@central.loteria.gba.gov.ar ','gaggiand@central.loteria.gba.gov.ar ','luaceseb@central.loteria.gba.gov.ar ','maldoemi@central.loteria.gba.gov.ar ',
#'recioadr@central.loteria.gba.gov.ar ','veccigon@central.loteria.gba.gov.ar ','panefra@central.loteria.gba.gov.ar '


def envio(*p)
    
	@html_style = '<span style="color: #8b8c8f; font-weight: boldt; text-decoration:underline";>'
    
  if @service.respond_to?(:cabinet_id) 
  	@equipo = @service.cabinet.computersystem.name 
  else
  	@equipo = @service.printer.name + " " + @service.printer.location
  end
	


message = <<MESSAGE_END
From: soportecasino <soportecasino@central.loteria.gba.gov.ar>
To: #{[DESTINATARIOS].to_s}
MIME-Version: 1.0
Content-type: text/html
Subject: OCSWEB# #{@service.id},#{@evento} servicio de soporte

<p><b>Descripcion de servicio</b></p>
#{@html_style} Titulo:</span>  #{@service.title.to_s}<br/> 
#{@html_style} Autor:</span>  #{@service.user.user.to_s}<br/>
#{@html_style} Fecha alta:</span>  #{@service.creation_date.to_s}<br/>
#{@html_style} Fecha cierre:</span>  #{@service.solution_date.to_s}<br/>
<p>#{@html_style} Solucionado por:</span>  #{User.find(@service.solution_user_id).user.to_s if @service.solution_user_id}<br/>
#{@html_style} Estado:</span>  #{@service.state.name.to_s}</p><br/>
#{@html_style} Equipo:</span>  #{@equipo}<br/>
#{@html_style} Descripcion:</span>  #{@service.problem.to_s }<br/>
#{@html_style} Solucion:</span>  #{@service.solution.to_s }<br/>

MESSAGE_END
    
	Net::SMTP.start(SMTP_SERVER, 25) do |smtp|
		smtp.open_message_stream('soportecasino@central.loteria.gba.gov.ar', [DESTINATARIOS]) do |f|
		f.puts message
		end
	end
end 