--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when Clockwork has loaded all of the entities.
function cwSaveItems:ClockworkInitPostEntity()
	self:LoadShipments() self:LoadItems()
end

-- Called just after data should be saved.
function cwSaveItems:PostSaveData()
	self:SaveShipments() self:SaveItems()
end