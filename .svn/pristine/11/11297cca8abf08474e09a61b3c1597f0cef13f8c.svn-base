require_relative 'chasis'
require 'resolv'
#encapsular en un metodo el llamado a cada metodo del wmi algo asi como explorar
#escribir un metodo que dado una Ip verifique que la informacion obtenida por el wmi existe en la base de datos con el fin de actualizar host faltantes o tributos nuevos

redes  = Network.where(:active => true)

redes.each do |red|
	
	res = Resolv::DNS.new(:nameserver => [red.nameserver], :search => [red.domain], :ndots => 1)

	(44..44).each do |i|
		host = Chasis.new(red.net + i.to_s,red.domain + '\\' + red.user,red.password)
		#consulto al DNS para obtener el nombre de host correspondiente a la IP dada.
		begin
			hostname = res.getname(host.ip)
		rescue
			hostname = nil
		end

		if host.ping
			if host.rcp_up?
			  puts "entro a mapear"
        if host.mapdrive(host.ip,host.user,host.passwd)
					if ARGV[0] == '-e' # indicando el parametro -e se eliminan las archivos id's de los hosts indicados
			      if host.eliminar_ID(DRIVE + FILE)
			      	host.log("#{host.ip}, #{hostname} Archivo Id Eliminado #{Time.now}")
			      else
			      	host.log("#{host.ip}, #{hostname} Archivo No encontrado #{Time.now}")
			      end
			    else
						if !host.leer_ID(DRIVE + FILE)
							host.log("#{host.ip}, #{hostname}, explorado #{Time.now}")
							host.explorar(host,red.domain)
						else
							host.log("#{host.ip}, #{hostname}, chasisid.inf encontrado #{Time.now}")
	          end
		      end
				host.unmapdrive
	      else
	      	host.log("#{host.ip}, El host #{hostname} no tiene el shareo C$ #{Time.now}")
	      end
			else
				host.log("#{host.ip}, Servidor RCP no disponible #{Time.now}")
			end
		else
			host.log("#{host.ip}, El host #{hostname} no responde #{Time.now}") if hostname
		end
	end
end