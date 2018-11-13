if !PLAYLIB then return end

PLAYLIB.debug = PLAYLIB.debug or {}

PLAYLIB.debug.printToConsoleKey = KEY_R

PLAYLIB.debug.drawingRange = 300 -- Range in Which the Entities should have their Display drawn.

PLAYLIB.debug.drawDebugCrosshair = false -- Should the Debug Crosshair be drawn or not?

PLAYLIB.debug.nodraw = {"gmod_hands","physgun_beam","class C_BaseFlex", "manipulate_bone","prop_dynamic","viewmodel"} -- Every Classname that should not be drawn

PLAYLIB.debug.InfoSpacing = { -- X and Y Spacing of the Trace Hit Entity and the Player Information, relative to the Screen Center
	["X"] = 200,
	["Y"] = -100
}
/*
Adding 'Information Functions' that should be used to display Debug Information.

@UsableParams tent The Target Entity that is choosen to Draw
@UsableParams lent The LocalPlayer

@Params A function that needs to return a String
@Params A Table with all Categories it should be drawn for. Available Categories: "Player","Ent"
*/
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