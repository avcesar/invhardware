require 'rubygems'
require 'net-ldap'
require 'active_record'

	#  conversion de timestam a time de AD
	AD_EPOCH      = 116_444_736_000_000_000
	AD_MULTIPLIER = 10_000_000

  SERVER = '192.168.120.17'
  PORT = 389
  BASE = 'DC=central,DC=loteria,DC=gba,DC=gov,DC=ar'
  DOMAIN = 'central.loteria.gba.gov.ar'
  login = "registro"
  pass = "registro" 
  
# Conexion BBDD OSC
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

class User < ActiveRecord::Base
  
end


	# convert a Time object to AD's epoch
	def time2ad(time)
	  (time.to_i * AD_MULTIPLIER) + AD_EPOCH
	end

	# convert from AD's time string to a Time object
	def ad2time(time)
		Time.at((time.to_i - AD_EPOCH) / AD_MULTIPLIER)
	end
          
	conn = Net::LDAP.new :host => SERVER,
                       :port => PORT,
                       :base => BASE,
                       :auth => { :username => "#{login}@#{DOMAIN}",
                                  :password => pass,
                                  :method => :simple }

  cantidad = 0
  if conn.bind
    # filter = Net::LDAP::Filter.eq("samaccountname", "*")
    # filter2 = Net::LDAP::Filter.eq("objectCategory", "organizationalPerson")
    # filter3 = Net::LDAP::Filter.eq("objectclass", "User")
    # filter4 = ~Net::LDAP::Filter.eq("userAccountControl:1.2.840.113556.1.4.803:","2")
   
    #filtro para obtener los usuarios con cuenta hailitada
    filter = "(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"
    #(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))
    #filter = "(&(&(|(&(objectCategory=person)(objectSid=*)(!samAccountType:1.2.840.113556.1.4.804:=3))(&(objectCategory=person)(!objectSid=*))(&(objectCategory=group)(groupType:1.2.840.113556.1.4.804:=14)))(&(mailnickname=*)(|(&(objectCategory=person)(objectClass=user)(|(homeMDB=*)(msExchHomeServerName=*)))))))"   
    conn.search(:base => BASE, :filter => filter) do |entry|
    	cantidad = cantidad + 1  
      begin
      	str = ad2time(entry.lastlogon.to_s) if entry.lastlogon.to_s != '0'
      rescue
      	str = nil
      end	

      begin
      	name = entry.displayname
      rescue
      	name = entry.name
      end	
			
			if str
				lastlogon = str.year.to_s + '/' + str.month.to_s + '/' + str.day.to_s 
			else
				lastlogon = '0'
			end

      #puts entry.samaccountname.to_s + '| '+ name.to_s + '| ' + lastlogon 
       #usuario = User.find_or_create_by(user: entry.samaccountname.to_s)
       #usuario.user = entry.samaccountname.join
       #usuario.name = name.join
       #usuario.save if usuario
       puts name.join
    end 
  end  
	
	puts cantidad


