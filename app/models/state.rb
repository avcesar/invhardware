class State < ActiveRecord::Base
	has_many :cabinet_services
	has_many :printer_services
end
