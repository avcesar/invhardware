class CabinetService < ActiveRecord::Base
	belongs_to :cabinet
	belongs_to :typeservice
	belongs_to :state
	belongs_to :user
	validates :title, :creation_date, :problem, presence: true
	accepts_nested_attributes_for :typeservice, :state, :cabinet
end
