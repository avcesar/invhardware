#1 dada una ip tomar la entrada inversa del dns para obtener el nombre del host (hostname)
#2 verficar que

require_relative 'chasis'
require 'resolv'

redes  = Network.where(:active => true)

redes.each do |red|
  res = Resolv::DNS.new(:nameserver => [red.nameserver], :search => [red.domain], :ndots => 1)
  (1..254).each do |i|

    cambio_ip = false
    cambio_hostname = false

    host = Chasis.new(red.net + i.to_s,red.user,red.password)

    begin
      hostname = res.getname(host.ip)
    rescue
      hostname = nil
    end

    if host.ping
      if host.rcp_up?
        host.mapdrive(host)
        cahsisinf = host.leer_ID(DRIVE + FILE) if host.leer_ID(DRIVE + FILE)
        host.unmapdrive
        cambio_ip = true if chasisinf["ip"] != host.ip
        cambio_hostname = true if chasisinf["host"] != hostname

      else
        host.log("#{host.ip}, Servidor RCP no disponible #{Time.now}")
      end
    else
      host.log("#{host.ip}, El host #{hostname} no responde #{Time.now}") if hostname
    end
  end
end