if !PLAYLIB then return end

PLAYLIB.debug = PLAYLIB.debug or {}

local PLAYER = FindMetaTable("Player")

--[[Config Part Start]]--
/*
local nodraw = {"gmod_hands","physgun_beam","class C_BaseFlex", "manipulate_bone","prop_dynamic","viewmodel"} -- Every Classname that should not be drawn

PLAYLIB.debug.InfoSpacing = {
	["X"] = 200,
	["Y"] = -100
}
*/
/*
PLAYLIB.debug.functions = {
	[#PLAYLIB.debug.functions+1] = function(tent,lent) return "Name: "..tent:Name().." | UserID: "..tent:UserID() end,
	[#PLAYLIB.debug.functions+1] = function(tent,lent) return "SteamID: "..tent:SteamID().." | SteamID64: "..tent:SteamID64() end,
	[#PLAYLIB.debug.functions+1] = function(tent,lent) return "Health: "..tent:Health().." | Armor: "..tent:Armor() end,
	[#PLAYLIB.debug.functions+1] = function(tent,lent) return "X: "..math.Round(tent:GetPos().x,2).." Y: "..math.Round(tent:GetPos().y,2).." Z: "..math.Round(tent:GetPos().z,2) end,
	[#PLAYLIB.debug.functions+1] = function(tent,lent) return 'Distance: '..math.Round(lent:GetPos():Distance(tent:GetPos()),2) end,
	[#PLAYLIB.debug.functions+1] = function(tent,lent) return "Model: "..tent:GetModel() end,
}
*/

function PLAYLIB.debug.addDebugFunction(func,tbl)
	if not PLAYLIB.debug.functions then
		PLAYLIB.debug.functions = {}
	end

	for index,t in pairs(tbl) do
		if PLAYLIB.debug.functions[t] then
			continue
		else
			PLAYLIB.debug.functions[t] = {}
		end
	end

	for index,t in pairs(tbl) do
		table.insert(PLAYLIB.debug.functions[t],func)
	end
end


/*
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
*/	
--[[Config Part End]]--



function PLAYLIB.debug.getDebugInfo(ply)
    local _t = {}
    local _tr = {}
    local gos

    if system.IsWindows() then
    	gos = "Windows"
    elseif system.IsOSX() then
    	gos = "OSX"
    elseif system.IsLinux() then
    	gos = "Linux"
    else
		gos = "N/A"
    end

    local ts = os.time()
    local h = os.date("%H:%M:%S",ts)
    local d = os.date("%d/%m/%Y",ts)
    _t[1] = "Time: "..h.." | Date: "..d.." | Country: "..system.GetCountry().." | OS: "..gos
    _t[2] = "Windowed: "..tostring(system.IsWindowed())
    _t[3] = "IP: "..game.GetIPAddress()
    _t[4] = "Map: "..game.GetMap()
    _t[5] = "Gamemode: "..engine.ActiveGamemode()
    _t[6] = "Players: "..#player.GetAll().."/"..game.MaxPlayers()
    _t[7] = "X: "..math.Round( ply:GetPos().x, 2 ).." Y: "..math.Round( ply:GetPos().y, 2 ).." Z: "..math.Round( ply:GetPos().z, 2 )
    _t[8] = "Pitch: "..math.Round( ply:GetAngles().p, 2 ).." Yaw: "..math.Round( ply:GetAngles().y, 2 ).." Roll: "..math.Round( ply:GetAngles().r, 2 )
    _t[9] = "Velocity: "..math.Round(PLAYLIB.speed.unitConversion(ply:GetVelocity():Length(),"kmh"),2).." km/h - "..math.Round(ply:GetVelocity():Length(),2).." units/sec"

    if IsValid(ply:GetEyeTrace().Entity) then
    	_tr[1] = "Eye Trace Ent: "..ply:GetEyeTrace().Entity:GetClass()
    	_tr[2] = "X: "..math.Round( ply:GetEyeTrace().Entity:GetPos().x, 2 ).." Y: "..math.Round( ply:GetEyeTrace().Entity:GetPos().y, 2 ).." Z: "..math.Round( ply:GetEyeTrace().Entity:GetPos().z, 2 )
    	_tr[3] = "Velocity: "..math.Round(PLAYLIB.speed.unitConversion(ply:GetEyeTrace().Entity:GetVelocity():Length(),"kmh"),2).." km/h - "..math.Round(ply:GetEyeTrace().Entity:GetVelocity():Length(),2).." units/sec"
    end
    	
    return _t,_tr
end

function PLAYER:setDebugState(state)
	self:SetNWBool("debug",state)
end

function PLAYER:getDebugState()
	return self:GetNWBool("debug",false)
end

if SERVER then
	hook.Add("PlayerInitialSpawn","PLAYLIB::SetDebugDefault",function(ply) 
	    ply:setDebugState(false)
	end)
elseif CLIENT then
	surface.CreateFont( "DebugHUDFont", {
		font = "Default",
		extended = false,
		size = ScreenScale(5),
		weight = 100,
		blursize = 0,
		scanlines = 1,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	hook.Add("HUDPaint","PLAYLIB.DEBUGHUD",function()
		if LocalPlayer():getDebugState() then -- Check if the Player is in debug Mode

			/*
				Defining the Standard Surface Variables
			*/
			surface.SetDrawColor(255,255,255,255)
			surface.SetFont("DebugHUDFont")
			surface.SetTextColor( 255,255,255,255 )

			if PLAYLIB.debug.drawDebugCrosshair then
				surface.DrawLine((ScrW()/2)-50,ScrH()/2,(ScrW()/2)+50,ScrH()/2)
				surface.DrawLine(ScrW()/2,(ScrH()/2)-50,ScrW()/2,(ScrH()/2)+50)
			end
		
			
			-- Relative positioning of the drawn Text
			local pInfo = {}
			pInfo.x = (ScrW()/2)
			pInfo.y = (ScrH()/2)



			local t,tr = PLAYLIB.debug.getDebugInfo(LocalPlayer()) -- Retrieving the Player and Eye Trace Hit Entity Information


			/*
				Drawing the Player Information with Screen Relative Positioning and the defined Spacing
			*/
			for index,info in pairs(t) do
				local x = 20*index
				surface.SetTextPos((pInfo.x+PLAYLIB.debug.InfoSpacing["X"]),(pInfo.y+PLAYLIB.debug.InfoSpacing["Y"])+x)
				surface.DrawText(info)
			end


			/*
				Drawing the Eye Trace Hit Entity Information with Screen Relative Positionings and the Defined Spacing 
			*/
			for index,info in pairs(tr) do
				local x = 20*index
				surface.SetTextPos(pInfo.x+(PLAYLIB.debug.InfoSpacing["X"]*-1),(pInfo.y+PLAYLIB.debug.InfoSpacing["Y"])+x)
				surface.DrawText(info)
			end

			for index,ent in pairs(ents.FindInSphere( LocalPlayer():GetPos(), PLAYLIB.debug.drawingRange )) do

				if !IsValid(ent) then continue end -- Entity Validity Check
				if ent:IsWorld() then continue end -- Entity World Check
				if table.HasValue(PLAYLIB.debug.nodraw,ent:GetClass()) then continue end -- Entity NoDraw Check
				
				
				/*
					3D Positioning od the Text/UI
				*/
				local pos = ent:GetPos()+Vector(0,0,30)
				pos.z = pos.z
				pos = pos:ToScreen()

				/*
					Creating Y Position Table for the Player Drawn Information
				*/	
				local tpos = {}
				local x = -115
				for i=1,#PLAYLIB.debug.functions["Player"] do
					tpos[i] = x+(20*(i-1))
				end

				/*
					Creating Y Position Table for the Entity Drawn Information
				*/		
				local tpos2 = {}
				local x2= -60
				for i=1,#PLAYLIB.debug.functions["Ent"] do
					tpos2[i] = x2+(20*(i-1))
				end			

				if ent:IsPlayer() then --  Check if Entity is Player
					if ent:IsBot() then return end -- Check if Entity is Bot
					if ent == LocalPlayer() then continue end -- Check if Entity is LocalPlayer

					/*
						Relative Drawing of the Rounded Box based on the amount of 'Player Information Functions'
					*/
					draw.RoundedBox(16, pos.x-200, pos.y-120, 400, #PLAYLIB.debug.functions["Player"]*20, Color(150,150,150,100) )

					/*
						Relative Drawing of the 'Player Information Functions' based on the Y Position Table and the 3D Positioning
					*/
					for index2,func in pairs(PLAYLIB.debug.functions["Player"]) do
						draw.DrawText(func(ent,LocalPlayer()), "DebugHUDFont", pos.x, pos.y +tpos[index2], Color(255,255,255,200), 1)
					end
					
				elseif ent:IsWeapon() then --Check if Entity is Weapon
					continue
				else -- Every Entity that is not a Player or a Weapon

					/*
						Relative Drawing of the Rounded Box based on the amount of 'Entity Information Functions'
					*/
					draw.RoundedBox(16, pos.x-100, pos.y-60, 200, #PLAYLIB.debug.functions["Ent"]*20, Color(150,150,150,100) )

					/*
						Relative Drawing of the 'Enity Information Functions' based on the Y Position Table and the 3D Positioning
					*/
					for index2,func in pairs(PLAYLIB.debug.functions["Ent"]) do
						draw.DrawText(func(ent,LocalPlayer()), "DebugHUDFont", pos.x, pos.y +tpos2[index2], Color(255,255,255,200), 1)
					end

				end
			end
		end
	end)
end

hook.Add("PlayerButtonDown","PLAYLIB::DebugPrint",function(ply,btn)
	if not IsFirstTimePredicted() then return end 
	if ply:getDebugState() then
		if btn == PLAYLIB.debug.printToConsoleKey then
			if CLIENT then
				local ent = ply:GetEyeTrace().Entity
				if table.HasValue(PLAYLIB.debug.nodraw,ent:GetClass()) then return end
				if ent:IsPlayer() then
					if ent:IsBot() then return end -- Check if Entity is Bot
					if ent == LocalPlayer() then return end -- Check if Entity is LocalPlayer
					print("***** Debug Info *****")
					for index2,func in pairs(PLAYLIB.debug.functions["Player"]) do
						print(func(ent,LocalPlayer()))
					end
					print("*****    ENDE    *****")

				elseif ent:IsWeapon() then 
					return
				else
					print("***** Debug Info *****")
					for index2,func in pairs(PLAYLIB.debug.functions["Ent"]) do
						print(func(ent,LocalPlayer()))
					end
					print("*****    ENDE    *****")
				end				
			end
		end
	end
end)