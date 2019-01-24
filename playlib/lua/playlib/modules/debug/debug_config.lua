if !PLAYLIB then return end

PLAYLIB.debug = PLAYLIB.debug or {}

--[[
	The Key to press in order to print Details of the Eye Trace Entity into the Console.
	Key Enumerations: https://wiki.garrysmod.com/page/Enums/KEY
]]--
PLAYLIB.debug.printToConsoleKey = KEY_R

--[[
	The Range in which to show the Panel displayed on Enitites.
	Number is in Units.
	For Reference: 53 Units are approximately 1 Meter.
]]--
PLAYLIB.debug.drawingRange = 300

--[[
	Should a simple Crosshair be drawn?
]]--
PLAYLIB.debug.drawDebugCrosshair = false

--[[
	A Table with the Classname of Enities that should not get a Panel.
]]--
PLAYLIB.debug.nodraw = {
	"gmod_hands",
	"physgun_beam",
	"class C_BaseFlex",
	"manipulate_bone",
	"prop_dynamic",
	"viewmodel"
}

--[[
	The Spacing of the Information relative to the Screen Center.
	These Values are inversed for the Trace Hit Entity Information
]]--
PLAYLIB.debug.InfoSpacing = {
	["X"] = 200,
	["Y"] = -100
}

PLAYLIB.debug.Prefix = "PLAYLIB"
PLAYLIB.debug.PrefixColor = Color(250,128,114)
PLAYLIB.debug.PrintToConsoleMessage = "Die Entity Informationen wurden in deine Konsole geschrieben!"

--[[
	Adding Informations to the Entity Panels:

	PLAYLIB.debug.addDebugFunction(func,Categories)
		func = Parameters:
					1. Target Entity
					2. Local Entity
		Categories = Table
			Table with the Categories that the Function should draw on.
				Categories = "Player","Ent"
	The function should return some Kind of string in order to display something.
]]--
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Name: "..tent:Name().." | UserID: "..tent:UserID() end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "SteamID: "..tent:SteamID().." | SteamID64: "..tent:SteamID64() end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Health: "..tent:Health().." | Armor: "..tent:Armor() end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "X: "..math.Round(tent:GetPos().x,2).." Y: "..math.Round(tent:GetPos().y,2).." Z: "..math.Round(tent:GetPos().z,2) end,{"Player","Ent"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return 'Distance: '..math.Round(lent:GetPos():Distance(tent:GetPos()),2) end,{"Player","Ent"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Model: "..tent:GetModel() end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return 'Class: '..tent:GetClass() end,{"Ent"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Money: "..tent:getDarkRPVar('money') end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Team: "..team.GetName(tent:Team()) end,{"Player"})
--PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Rank: "..tent:GetJobRank().." | Rank Name: "..tent:GetJobRankName() end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent)
	if IsValid(tent:GetActiveWeapon()) then
		return "Weapon Name: "..tent:GetActiveWeapon():GetPrintName().." | Weapon Class: "..tent:GetActiveWeapon():GetClass()
	else
		return "Weapon Name: None | Weapon Class: None"
	end
end,{"Player"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Pitch: "..math.Round( tent:GetAngles().p, 2 ).." Yaw: "..math.Round( tent:GetAngles().y, 2 ).." Roll: "..math.Round( tent:GetAngles().r, 2 ) end,{"Ent"})
PLAYLIB.debug.addDebugFunction(function(tent,lent) return "Velocity: "..math.Round(PLAYLIB.speed.unitConversion(tent:GetVelocity():Length(),"kmh"),2).." km/h - "..math.Round(tent:GetVelocity():Length(),2).." units/sec"end,{"Player","Ent"})
