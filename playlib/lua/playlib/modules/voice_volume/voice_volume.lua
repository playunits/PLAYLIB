if !PLAYLIB then return end

PLAYLIB.voice_volume = PLAYLIB.voice_volume or {}
PLAYLIB.voice_volume.circleCVar = CreateClientConVar("cl_voice_volume_draw_circle",0,FCVAR_ARCHIVE)

if SERVER then -- Serverside Code here

	resource.AddFile( "materials/modules/voice_volume/fluestern.png" )
	resource.AddFile( "materials/modules/voice_volume/laut.png" )
	resource.AddFile( "materials/modules/voice_volume/leise.png" )
	resource.AddFile( "materials/modules/voice_volume/normal.png" )
	resource.AddFile( "resource/fonts/Exo-Bold.ttf")

	util.AddNetworkString("PLAYLIB::IncrementVolume")

	net.Receive("PLAYLIB::IncrementVolume",function(len,ply) 
		ply:incrementVolume()
		PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.voice_volume.PrefixColor,PLAYLIB.voice_volume.Prefix,Color(255,255,255),"] - "..string.Replace(PLAYLIB.voice_volume.changeMessage,"%volume",PLAYLIB.voice_volume.volumeSettings[ply:GetNWInt("PLAYLIB::VolumeDesc")][1])})
	end)
	--[[
		This is the Part that decides wether you can hear a Player or not.
	]]--
	hook.Add( "PlayerCanHearPlayersVoice", "PLAYLIB::CheckVoiceVolume", function( listener, talker )
		if listener == talker then return end
		local dist = talker:GetPos():Distance( listener:GetPos() )
		--talker:ChatPrint(dist)
		--talker:ChatPrint(talker:getVolume())

		if talker:getVolume() < dist then
			--talker:ChatPrint("Volume too low")
			return false,true
		else 
			--talker:ChatPrint("Volume good")
			return true,true
		end
	end )


elseif CLIENT then -- Clientside Code here

	timer.Create("PLAYLIB::RemoveTalkThingy",5,20,function()
	    hook.Remove("StartChat", "DarkRP_StartFindChatReceivers")
	    hook.Remove("PlayerStartVoice", "DarkRP_VoiceChatReceiverFinder")
	end)

	local NextButtonPress = 0
	--[[
		This Part represents the Keybind to Toggle through the Volumes
	]]--
	hook.Add("PlayerButtonDown","PLAYLIB::VolumeKeyCheck",function(ply,button)
		if not IsFirstTimePredicted() then return end
		if button ==  PLAYLIB.voice_volume.incrementKey and CurTime() > NextButtonPress then
			NextButtonPress = CurTime() + PLAYLIB.voice_volume.buttonPressDelay
			net.Start("PLAYLIB::IncrementVolume")
			net.SendToServer()
			--LocalPlayer():incrementVolume()
			
		end
	end)
	--[[
		This Part is for displaying the Icon in the Specified Corner
	]]--
	hook.Add("HUDPaint","PLAYLIB::DrawVolumeIcon",function()
		if not PLAYLIB.voice_volume.volumeSettings[LocalPlayer():GetNWInt("PLAYLIB::VolumeDesc",3)][3] then return end 
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(PLAYLIB.voice_volume.volumeSettings[LocalPlayer():GetNWInt("PLAYLIB::VolumeDesc",3)][3])
		surface.DrawTexturedRect(PLAYLIB.voice_volume.iconPos["X"],PLAYLIB.voice_volume.iconPos["Y"],PLAYLIB.voice_volume.iconSize["W"],PLAYLIB.voice_volume.iconSize["H"])

		if LocalPlayer():IsSpeaking() then
			PLAYLIB.vgui.drawFilledCircle(PLAYLIB.voice_volume.talkIndicatorPos["X"],PLAYLIB.voice_volume.talkIndicatorPos["Y"],20,Color(0,255,0,255))
		
		else
			if PLAYLIB.voice_volume.showCircleWhenNotTalking then
				PLAYLIB.vgui.drawFilledCircle(PLAYLIB.voice_volume.talkIndicatorPos["X"],PLAYLIB.voice_volume.talkIndicatorPos["Y"],20,Color(255,0,0,255))
			end
		end
	end)

	--[[
		This Part is only for drawing the Circle that represents the talking range.
	]]--
	hook.Add("PostPlayerDraw","PLAYLIB::ShowTalkCircle",function(ply) 
		if PLAYLIB.voice_volume.circleCVar:GetBool() then
			if ply != LocalPlayer() then return end
			cam.Start3D2D( ply:GetPos(), Angle(0, 0, 0), 1 )
					surface.DrawCircle(0,0,LocalPlayer():getVolume(),Color(255,0,0,255))

					local function PointOnCircle(ang,radius,offX,offY)
						ang = math.rad(ang)

						local x = math.cos(ang) * radius + offX
						local y = math.sin(ang) * radius + offY
						return x,y
					end

					local numSquares = 36

					local interval = 360/numSquares

					local centerX,centerY = 0,0
					local radius = LocalPlayer():getVolume()


					local verts= {}

					for degrees = 1,360, interval do 
						local x,y = PointOnCircle(degrees,radius,centerX,centerY)
						table.insert(verts, {x=x,y=y})
					end
					
					local circleColor= Color(200,200,200,150)

					surface.SetDrawColor(circleColor)
					draw.NoTexture()
					surface.DrawPoly(verts)

			cam.End3D2D()
		end
	end)

	hook.Add("HUDShouldDraw","PLAYLIB::DisableSandboxHUD",function(name) 
	    if name == "CHudHealth" or
	        name == "CHudBattery" or
	        name == "CHudSuitPower" or
	        name == "CHudAmmo" or 
	        name == "CHudSecondaryAmmo" then
	        	return false
	    end
	end)

end

function PLAYLIB.voice_volume.setVolume(ply,nr)
	if not PLAYLIB.voice_volume.volumeSettings[nr] then return end

	ply:SetNWInt("PLAYLIB::Volume",PLAYLIB.voice_volume.volumeSettings[nr][2])
	ply:SetNWInt("PLAYLIB::VolumeDesc",nr)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:setVolume(nr)

	PLAYLIB.voice_volume.setVolume(self,nr)
end

function PLAYER:getVolume()
	return self:GetNWInt("PLAYLIB::Volume",PLAYLIB.voice_volume.volumeSettings[self:GetNWInt("PLAYLIB::VolumeDesc",3)][2])
end

function PLAYER:getVolumeDesc()
	return PLAYLIB.voice_volume.volumeSettings[self:GetNWInt("PLAYLIB::VolumeDesc",PLAYLIB.voice_volume.standardVolume)]
end


--[[
	Increments the Volume by one. When it is at the Last Table segment (The one with the highest number) it goes back to the Segment with the Indicator 1.
]]--
function PLAYER:incrementVolume()
	if #PLAYLIB.voice_volume.volumeSettings == self:GetNWInt("PLAYLIB::VolumeDesc",PLAYLIB.voice_volume.standardVolume) then
		PLAYLIB.voice_volume.setVolume(self,1)
	else
		PLAYLIB.voice_volume.setVolume(self,self:GetNWInt("PLAYLIB::VolumeDesc",PLAYLIB.voice_volume.standardVolume)+1)
	end

end
--[[
	Decreases the Volume by one. When it is at the First Table segment (Indicator 1) it goes back to the Last Segment(Highest Number).
]]--
function PLAYER:decreaseVolume()
	if self:GetNWInt("PLAYLIB::VolumeDesc") == 1 then
		PLAYLIB.voice_volume.setVolume(self,#PLAYLIB.voice_volume.volumeSettings)
	else
		PLAYLIB.voice_volume.setVolume(self,self:GetNWInt("PLAYLIB::VolumeDesc")-1)
	end
	
end