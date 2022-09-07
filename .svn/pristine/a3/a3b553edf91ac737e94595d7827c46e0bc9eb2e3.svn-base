class Cabinet < ActiveRecord::Base
	has_one :baseboard, dependent: :destroy    
	has_one :bios, dependent: :destroy    
	has_one :operatingsystem, dependent: :destroy    
	has_one :computersystem, dependent: :destroy    
	has_one :scheduler, dependent: :destroy
	has_many :cdromdrives, dependent: :destroy    
	has_many :desktopmonitors, dependent: :destroy    
	has_many :diskdrives, dependent: :destroy    
	has_many :networkadapters, dependent: :destroy    
	has_many :physicalmemories, dependent: :destroy    
	has_many :processors, dependent: :destroy    
	has_many :videocontrollers, dependent: :destroy 
	has_many :cabinet_services, dependent: :destroy
	accepts_nested_attributes_for :computersystem, :baseboard, :bios, :operatingsystem, :cdromdrives, :desktopmonitors, :diskdrives, :networkadapters, :physicalmemories, :processors, :videocontrollers, :cabinet_services, :reject_if => :all_blank, :allow_destroy => true
end
