require 'rubygems'
require 'ruby-wmi'
require 'win32ole'
require 'active_record'
require 'json'

DRIVE = "P:"
FILE = '\chasisid.inf'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql2",
  :encoding => "utf8",
  :reconnect => false,
  :database => "invhardware_development",
  :pool => 5,
  :username => "root",
  :password => "espermatozoide",
  :host => "192.168.120.14"
  )

ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
	inflect.irregular 'diskdrive', 'diskdrives'
	inflect.irregular 'cdromdrive', 'cdromdrives'
	inflect.irregular 'bios', 'bios'
end

#primero tengo que levantar las redes a explorar
class Network < ActiveRecord::Base
end

class Cabinet < ActiveRecord::Base
	has_many :baseboards
	has_many :bios
	has_many :operatingsystems
	has_many :cdromdrives
	has_many :computersystems
	has_many :desktopmonitors
	has_many :diskdrives
	has_many :networkadapters
	has_many :physicalmemories
	has_many :printers
	has_many :processors
	has_many :videocontrollers
end

class Baseboard < ActiveRecord::Base
	belongs_to :cabinets
end

class Bios < ActiveRecord::Base
	belongs_to :cabinets
end

class Cdromdrive < ActiveRecord::Base
	belongs_to :cabinets
end

class Computersystem < ActiveRecord::Base
	belongs_to :cabinets
end

class Desktopmonitor < ActiveRecord::Base
	belongs_to :cabinets
end

class Diskdrive < ActiveRecord::Base
	belongs_to :cabinets
end

class Networkadapter < ActiveRecord::Base
	belongs_to :cabinets
end

class Operatingsystem < ActiveRecord::Base
	belongs_to :cabinets
end

class Physicalmemory < ActiveRecord::Base
	belongs_to :cabinets
end

class Printer < ActiveRecord::Base
	belongs_to :cabinets
end

class Processor < ActiveRecord::Base
	belongs_to :cabinets
end

class Videocontroller < ActiveRecord::Base
	belongs_to :cabinets
end


class Chasis

	def initialize(host, name, user, passwd)
		@host = host
		@user = user
		@passwd = passwd
		@name = name.to_s[0,name.to_s.index('.')].upcase if name
	end

	def ip
		return @host
	end

	def name
		return @name
	end

	def user
		return @user
	end

	def passwd
		return @passwd
	end

	def ping
		return system("ping -n 1 #{self.ip}")
	end

	def rpc_up?
		puts "Entro a rpc_up"
		begin
			wmi = WIN32OLE.new("WbemScripting.SwbemLocator")
			conn = wmi.ConnectServer(self.ip,"root\\cimv2",self.user,self.passwd)
	 		return true if conn
		rescue
	 		return false
		end
	end

	def explorar(host,domain)
		puts "Entro a Explorar"
		cabinet = Cabinet.new
		cabinet.active = 1
		cabinet.save

		computersystems = host.wmi_query(['name','model','manufacturer','domain','totalphysicalmemory']) {WMI::Win32_Computersystem.find(:all, {:host => host.ip, :user => host.user, :password => host.passwd})}
		computersystems.each do |computersystem|
			cs = Computersystem.new(computersystem)
			cs.cabinet_id = cabinet.id
		 	cs.ip = host.ip
		 	#grabar_ID(DRIVE + FILE ,{'id' => cabinet.id, 'date' => Time.now,'host' => cs.name, 'domain' => domain, 'ip' => cs.ip})
		 	cs.save
		end

		baseboards = host.wmi_query(['product','manufacturer','serialnumber']) {WMI::Win32_BaseBoard.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		baseboards.each do |baseboard|
			bb = Baseboard.new(baseboard)
			bb.cabinet_id = cabinet.id
			bb.save
		end

		bios = host.wmi_query(['name','manufacturer','version','serialnumber']) {WMI::Win32_Bios.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		bios.each do |bio|
			bi = Bios.new(bio)
		  bi.cabinet_id = cabinet.id
		 	bi.save
		end

		cdromdrives = host.wmi_query(['name','drive']) {WMI::Win32_CDROMDrive.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		cdromdrives.each do |cdromdrive|
			cd = Cdromdrive.new(cdromdrive)
		 	cd.cabinet_id = cabinet.id
		 	cd.save
		end

 	 	desktopmonitors = host.wmi_query(['caption','monitormanufacturer','screenheight','screenwidth']) {WMI::Win32_desktopmonitor.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		desktopmonitors.each do |desktopmonitor|
			dm = Desktopmonitor.new(desktopmonitor)
		  dm.cabinet_id = cabinet.id
		 	dm.save
		end

		diskdrives = host.wmi_query(['model','size','partitions']) {WMI::Win32_diskdrive.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		diskdrives.each do |diskdrive|
			dd = Diskdrive.new(diskdrive)
		  dd.cabinet_id = cabinet.id
		 	dd.save
		end

		networkadapters = host.wmi_query(['adaptertype','name','macaddress','speed']) {WMI::Win32_NetworkAdapter.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		networkadapters.each do |networkadapter|
			na = Networkadapter.new(networkadapter)
			na.cabinet_id = cabinet.id
			na.save
		end

		operatingsystems = host.wmi_query(['caption','csdversion','countrycode','currenttimezone','version']) {WMI::Win32_operatingsystem.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		operatingsystems.each do |operatingsystem|
			os = Operatingsystem.new(operatingsystem)
		  os.cabinet_id = cabinet.id
		 	os.save
		end

		physicalmemories = host.wmi_query(['capacity','speed']) {WMI::Win32_physicalmemory.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		physicalmemories.each do |physicalmemory|
			pm = Physicalmemory.new(physicalmemory)
			pm.cabinet_id = cabinet.id
		 	pm.save
		end

		processors = host.wmi_query(['name','caption','manufacturer','currentclockspeed']) {WMI::Win32_Processor.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		processors.each do |processor|
			pr = Processor.new(processor)
		  pr.cabinet_id = cabinet.id
		 	pr.save
		end

		videocontrollers = host.wmi_query(['caption','adapterram','infsection']) {WMI::Win32_videocontroller.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		videocontrollers.each do |videocontroller|
			vc = Videocontroller.new(videocontroller)
			vc.cabinet_id = cabinet.id
			vc.save
		end
		return cabinet.id
	end

	def wmi_query(*args,&block)
		list = block.call
		resultado = Array.new
		i = 0
		list.each do |item|
			resultado[i] = Hash.new
			args[0].each do |p|
				resultado[i][p] = eval("item." + p).to_s
			end
			i += 1
		end
		return resultado
	end

	def actualizar(host,net, id)
		clase = Hash.new
		puts "Entro a Actualizar! #{host.name} #{host.user}  #{host.passwd}"
		clase["computersystem"] = host.wmi_query(['name','model','manufacturer','domain','totalphysicalmemory']) {WMI::Win32_Computersystem.find(:all, {:host => host.name, :user => host.user, :password => host.passwd})}
		comparo(clase,"computersystem",id)
		clase["networkadapter"] = host.wmi_query(['adaptertype','name','macaddress','speed']) {WMI::Win32_NetworkAdapter.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"networkadapter",id)
		clase["baseboard"] = host.wmi_query(['product','manufacturer','serialnumber']) {WMI::Win32_BaseBoard.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"baseboard",id)
		clase["bios"] = host.wmi_query(['name','manufacturer','version','serialnumber']) {WMI::Win32_Bios.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"bios",id)
		clase["cdromdrive"] = host.wmi_query(['name','drive']) {WMI::Win32_CDROMDrive.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"cdromdrive",id)
		clase["desktopmonitor"] = host.wmi_query(['caption','monitormanufacturer','screenheight','screenwidth']) {WMI::Win32_desktopmonitor.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"desktopmonitor",id)
		clase["diskdrive"] = host.wmi_query(['model','size','partitions']) {WMI::Win32_diskdrive.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"diskdrive",id)
		clase["operatingsystem"] = host.wmi_query(['caption','csdversion','countrycode','currenttimezone','version']) {WMI::Win32_operatingsystem.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"operatingsystem",id)
		clase["physicalmemory"] = host.wmi_query(['capacity','speed']) {WMI::Win32_physicalmemory.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"physicalmemory",id)
		clase["processor"] = host.wmi_query(['name','caption','manufacturer','currentclockspeed']) {WMI::Win32_Processor.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"processor",id)
		clase["videocontroller"] = host.wmi_query(['caption','adapterram','infsection']) {WMI::Win32_videocontroller.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
		comparo(clase,"videocontroller",id)
		actualizar_ip(host.wmi_query(['ipaddress']) {WMI::Win32_NetworkAdapterConfiguration.find(:all, :host => host.name, :user => host.user, :password => host.passwd)},id,net)
		puts "Salgo de Actualizar!"	
	end

  
  def actualizar_ip(netconfig,host_id,net)
    ip4_regex = /(?:[0-9]{1,3}\.){3}[0-9]{1,3}/
    bbdd = Cabinet.find(host_id)
    bbdd.active = true if !bbdd.active
    
    netconfig.each do |nc|
      @ip = nc["ipaddress"].to_s[ip4_regex] if (nc["ipaddress"] !="") && (nc["ipaddress"].to_s.include? net.net)
    end
    if bbdd.computersystems[0].ip != @ip
       bbdd.computersystems[0].ip = @ip
       bbdd.computersystems[0].save
    end
    bbdd.save
  end

  def actualizar_macaddress(host)
  	clase = Hash.new
  	host_id = host.leer_ID(DRIVE + FILE)
  	if host_id
	  	clase["networkadapter"] = host.wmi_query(['adaptertype','name','macaddress','speed']) {WMI::Win32_NetworkAdapter.find(:all, :host => host.name, :user => host.user, :password => host.passwd)}
	    comparo(clase,"networkadapter",host_id["id"])
	   end
  end

  def chasis_id(host)
  	puts "Entro en Chasis ID"
  	networkadapters = host.wmi_query(['macaddress','adaptertype','pnpdeviceid']) {WMI::Win32_NetworkAdapter.find(:all, :host => host.ip, :user => host.user, :password => host.passwd)}
		networkadapters.each do |na|
			if (na['pnpdeviceid'].include? 'PCI') && (na['adaptertype'].include? 'Ethernet') && (!na['macaddress'].empty?)
				@id = Networkadapter.find_by(:macaddress => na["macaddress"])
			end
		end
		return @id != nil ? @id.cabinet_id : nil 
  end


  def compare_idfile_with_host(host)
  	puts "Entro a compare_idfile_with_host"
		idfile = host.leer_ID(DRIVE + FILE)
		computersystem = host.wmi_query(['name','model','manufacturer','domain','totalphysicalmemory']) {WMI::Win32_Computersystem.find(:all, {:host => host.name, :user => host.user, :password => host.passwd})}
		
		if idfile["host"] == computersystem[0]["name"]
			return true
		else
			return false
		end
		puts "Salgo de compare_idfile_with_host"
  end

  def compare_idfile_with_bbdd(host)
		puts "Entro a compare_idfile_with_bbdd"
		idfile = host.leer_ID(DRIVE + FILE)
		cabinet = Cabinet.find(idfile["id"])

		if (idfile["host"].upcase == cabinet.computersystems[0].name.upcase) && (idfile["ip"] == cabinet.computersystems[0].ip)
			return true
		else
			return false
		end
  end

  def mapdrive(host,user,passwd)
    system "net use #{DRIVE} \\\\#{host}\\c$ #{passwd} /user:#{user}"
  end

  def unmapdrive
    system "net use #{DRIVE}  /delete"
  end


  #lee el archivo chasisid.inf y retorna un json con los datos encontrados

	def leer_ID(archivo)
		puts "Entro a leer_ID"
		begin
			cadena = File.open(archivo, "r"){ |ar| ar.read }
			return JSON.parse(cadena)
		rescue
			puts "Salgo de leer_ID con FALSE"
			return nil
		end
	end

	#elimina el archivo chasisid.inf

	def eliminar_ID(archivo)
		File.delete(archivo) if File.file?(archivo)
	end

	#envia a un archivo de log en mensaje enviado
	def log(msg)
		open('wmilog.txt','a') do |f|
			f.puts msg
		end
	end

	#genera un archivo chasisid.inf en la raiz de la unidad C guardabndo un hash con los datos del host
	def grabar_ID(archivo,hash)
		puts "Entro a grabar_ID"
		File.open(archivo, "w"){ |ar| ar.puts hash.to_json}
  end

private
	#compara cada elemento de la consulta wmi contra la BBDD y actualiza en la BBDD las diferencias
  def comparo(clase,metodo,host_id)
    bbdd = Cabinet.find(host_id)
    len_bbdd = bbdd.send(metodo.pluralize).length
    len_clase = clase[metodo].length
    if len_bbdd == 0
      for i in 0..clase[metodo].length-1
        cl = Object.const_get(metodo.camelcase).new
        clase[metodo][i].each do |k,v|
          cl[k] = v
        end
        cl.cabinet_id = bbdd.id
        cl.save
      end
    else
      if len_clase > len_bbdd
        for i in 0..len_clase -1
          if i <= len_bbdd -1
            clase[metodo][i].each do |k,v|
              if bbdd.send(metodo.pluralize)[i][k] != clase[metodo][i][k]
                bbdd.send(metodo.pluralize)[i][k] = clase[metodo][i][k]
                bbdd.send(metodo.pluralize)[i].save
              end
            end
          else
            cl = Object.const_get(metodo.camelcase).new
            clase[metodo][i].each do |k,v|
              cl[k] = v
            end
            cl.cabinet_id = bbdd.id
            cl.save
          end
        end
        elsif len_clase < len_bbdd
          for i in 0..len_bbdd -1
            if i <= len_clase -1
            clase[metodo][i].each do |k,v|
              if bbdd.send(metodo.pluralize)[i][k] != clase[metodo][i][k]
                bbdd.send(metodo.pluralize)[i][k] = clase[metodo][i][k]
                bbdd.send(metodo.pluralize)[i].save
              end
            end
            else
              bbdd.send(metodo.pluralize)[i].destroy
            end
          end
      else
        for i in 0..len_clase -1
          clase[metodo][i].each do |k,v|
            if bbdd.send(metodo.pluralize)[i][k] != clase[metodo][i][k]
              bbdd.send(metodo.pluralize)[i][k] = clase[metodo][i][k]
              bbdd.send(metodo.pluralize)[i].save
            end
          end
        end
      end
    end
  end
end