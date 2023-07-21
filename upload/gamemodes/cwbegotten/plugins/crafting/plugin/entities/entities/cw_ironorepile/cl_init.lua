--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	y = Clockwork.kernel:DrawInfo("An exposed pile of iron ore. If broken up, its contents could be used as a crafting material.", x, y, Clockwork.option:GetColor("white"), alpha);
end;