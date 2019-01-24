if !PLAYLIB then return end

PLAYLIB.holo = PLAYLIB.holo or {}

if SERVER then
	util.AddNetworkString("PLAYLIB::RequestHolo")
	util.AddNetworkString("PLAYLIB::RejectHolo")
	util.AddNetworkString("PLAYLIB::AcceptHolo")
	util.AddNetworkString("PLAYLIB::StartHolo")
	PLAYLIB.chatcommand.addCommand("!holo",function(ply,cmd,text) PLAYLIB.holo.chatCheck(ply,cmd,text) end)
	PLAYLIB.chatcommand.addCommand("!stopholo",function(ply,cmd,text) ply:SetHolo(false) end)


	function PLAYLIB.holo.chatCheck(sendingply,cmd,text)
		if text == cmd then
			PLAYLIB.misc.chatNotify(sendingply,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - Du musst einen Spieler angeben mit dem du in den Holofunk möchtest"})
			return
		end
		sendingply:ChatPrint("CMD: '"..cmd.."' text: '"..text.."'")
		local expectedname = string.Replace(text,cmd.." ","")
		sendingply:ChatPrint(expectedname)
		local res = PLAYLIB.player.getEntByName(expectedname)
		PrintTable(res)

		if #res < 1 then
			PLAYLIB.misc.chatNotify(sendingply,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - Der Spieler mit dem Namen: "..expectedname.." konnte nicht gefunden werden!"})
		elseif #res >1 then
			local pString = ""
			for i=1,#res do
				if i==#res then
					pString = pString..res[i]:Name()
				else
					pString = pString..res[i]:Name()..","
				end
			end
			PLAYLIB.misc.chatNotify(sendingply,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - Es wurden mehrere Spieler unter: "..expectedname.." gefunden - "..pString})
		else
			if res[1]:GetHolo() then
				PLAYLIB.misc.chatNotify(sendingply,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - "..res[1]:Name().." ist bereits in einem Hologespräch!"})
			else
				sendingply:ChatPrint("SUCCESS")
				net.Start("PLAYLIB::RequestHolo")
					net.WriteEntity(sendingply)
				net.Send(res[1])
			end
			
		end
	end

	hook.Add("PlayerSpawn","PLAYLIB::NormalizeHolo",function(ply) 
		ply:SetHolo(false)
	end)

	net.Receive("PLAYLIB::RejectHolo",function(len,ply) 
		local rejected = net.ReadEntity()
		PLAYLIB.misc.chatNotify(rejected,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - Deine Holo Anfrage an "..ply:Name().." wurde abgelehnt!"})

	end)

	net.Receive("PLAYLIB::AcceptHolo",function(len,ply)
		local requester = net.ReadEntity()
		local accepter = ply 
		PLAYLIB.misc.chatNotify(requester,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - Du startest ein Hologespräch mit "..accepter:Name().."!"})
		PLAYLIB.misc.chatNotify(accepter,{Color(255,255,255),"[",PLAYLIB.holo.PrefixColor,PLAYLIB.holo.Prefix,Color(255,255,255),"] - Du startest ein Hologespräch mit "..requester:Name().."!"})

		requester:SetHolo(true)
		accepter:SetHolo(true)

		net.Start("PLAYLIB::StartHolo")
			net.WriteEntity(accepter)
		net.Send(requester)

		net.Start("PLAYLIB::StartHolo")
			net.WriteEntity(requester)
		net.Send(accepter)
	end)


elseif CLIENT then

	PLAYLIB.holo.modelPanel = nil



	net.Receive("PLAYLIB::RequestHolo",function(len) 
		local sender = net.ReadEntity()

		PLAYLIB.vgui.ynDerma("Hologespräch",sender:Name().." möchte ein Hologespräch mit dir starten!",
			"Annehmen",function()
				net.Start("PLAYLIB::AcceptHolo")
					net.WriteEntity(sender)
				net.SendToServer()
			end,
			"Ablehnen",function()
				net.Start("PLAYLIB::RejectHolo")
					net.WriteEntity(sender)
				net.SendToServer()
			end,
			false)
	end)

	net.Receive("PLAYLIB::StartHolo",function(len)
		local holoPartner = net.ReadEntity() 
		PLAYLIB.holo.startHolo(holoParnter)
	end)

	function PLAYLIB.holo.stopHolo()
		if PLAYLIB.holo.modelPanel then
			PLAYLIB.holo.modelPanel:Remove()
		end
	end

	function PLAYLIB.holo.startHolo(drawEnt)
		timer.Create("PLAYLIB::DrawHoloModel",1/30,0,function() 
			if LocalPlayer():GetHolo() and drawEnt:GetHolo() then
				PLAYLIB.holo.drawHolo(drawEnt)
			else
				timer.Pause("PLAYLIB::DrawHoloModel")
				timer.Remove("PLAYLIB::DrawHoloModel")
				PLAYLIB.holo.stopHolo()
			end
		end)
	end

	function PLAYLIB.holo.drawHolo(ent)
		if IsValid(PLAYLIB.holo.modelPanel) then PLAYLIB.holo.modelPanel:Remove() end
		
		local modelPanel = vgui.Create("DModelPanel")
		modelPanel:SetSize(400,400)
		modelPanel:SetPos(100,100)
		modelPanel:SetModel(ent:GetModel())

		PLAYLIB.holo.copyBonePosToEnt(ent,modelPanel.Entity)
		PLAYLIB.holo.modelPanel = modelPanel
	end

	function PLAYLIB.holo.copyBonePosToEnt(sourceEntity,targetEntity)

		for index,boneString in pairs(PLAYLIB.holo.BoneList) do
			local v,a = sourceEntity:GetBonePosition(sourceEntity:LookupBone(boneString))
			targetEntity:SetBonePosition(sourceEntity:LookupBone(boneString),v,a)
		end 

	end



end

	local PLAYER = FindMetaTable("Player")

	function PLAYER:SetHolo(bool)
		self:SetNWBool("PLAYLIB::InHolo",bool)
	end

	function PLAYER:GetHolo()
		return self:GetNWBool("PLAYLIB::InHolo",false)
	end
