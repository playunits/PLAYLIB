if !PLAYLIB then return end

PLAYLIB.lockdown = PLAYLIB.lockdown or {}

PLAYLIB.lockdown.panel = nil


if SERVER then -- Serverside Code here
	util.AddNetworkString("PLAYLIB::StartLockdown")
	util.AddNetworkString("PLAYLIB::EndLockdown")

	function PLAYLIB.lockdown.isValid(ply) 
		local cR = false
		local cT = false

		for index,team in pairs(PLAYLIB.lockdown.AllowedTeams) do
			if team == ply:Team() then
				cT = true
				break
			end
		end

		for index,rank in pairs(PLAYLIB.lockdown.AllowedRanks) do
			if rank == ply:GetUserGroup() then
				cR = true
				break
			end
		end

		if PLAYLIB.lockdown.StrictHandling then
			if cR and cT then
				return true
			end
			PLAYLIB.misc.notify(ply,PLAYLIB.lockdown.NotAllowed,NOTIFY_ERROR,5)
			return false
		else
			if cR or cT then
				return true
			end
			PLAYLIB.misc.notify(ply,PLAYLIB.lockdown.NotAllowed,NOTIFY_ERROR,5)
			return false
		end
	end

	function PLAYLIB.lockdown.startLockdown(ply)
		if PLAYLIB.lockdown.isValid(ply) then
			net.Start("PLAYLIB::StartLockdown")
			net.Broadcast()
		end
	end

	function PLAYLIB.lockdown.stopLockdown(ply)
		if PLAYLIB.lockdown.isValid(ply) then
			net.Start("PLAYLIB::EndLockdown")
			net.Broadcast()
		end
	end

	hook.Add("PlayerSay","PLAYLIB::LockdownCheck",function(sender,text,teamChat) 
		if text == PLAYLIB.lockdown.StartLockdownCommand then
			PLAYLIB.lockdown.startLockdown(sender)
			return ""
		elseif text == PLAYLIB.lockdown.EndLockdownCommand then
			PLAYLIB.lockdown.stopLockdown(sender)
			return ""
		end
	end)
	
elseif CLIENT then -- Clientside Code here
	PLAYLIB.lockdown.panel = nil

	function PLAYLIB.lockdown.createLockdownPanel()
		if IsValid(PLAYLIB.lockdown.panel) then PLAYLIB.lockdown.panel:Remove() end

		local p = vgui.Create("DShape")
		p:SetSize(400,50+(#PLAYLIB.lockdown.PanelText*30))

		local px,py = p:GetSize()
		p:SetPos((ScrW()/2)-(px/2),50)
		p.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,PLAYLIB.lockdown.BasePanelColor)
			draw.DrawText(PLAYLIB.lockdown.PanelTitle,"CloseCaption_Bold",200,17,PLAYLIB.lockdown.HiglightColor,TEXT_ALIGN_CENTER)
			for i=1,#PLAYLIB.lockdown.PanelText do
				draw.DrawText(PLAYLIB.lockdown.PanelText[i],"Default",200,17+(i*30),PLAYLIB.lockdown.HiglightColor,TEXT_ALIGN_CENTER)
			end
		end

		PLAYLIB.lockdown.panel = p
		chat.AddText(Color(255,255,255),"[",PLAYLIB.lockdown.PrefixColor,PLAYLIB.lockdown.prefix,Color(255,255,255),"] - "..PLAYLIB.lockdown.BeginChatText)
		surface.PlaySound( PLAYLIB.lockdown.BeginSound )
	end
	
	function PLAYLIB.lockdown.removeLockdownPanel()
		if IsValid(PLAYLIB.lockdown.panel) then PLAYLIB.lockdown.panel:Remove() end
		PLAYLIB.lockdown.panel = nil
		chat.AddText(Color(255,255,255),"[",PLAYLIB.lockdown.PrefixColor,PLAYLIB.lockdown.prefix,Color(255,255,255),"] - "..PLAYLIB.lockdown.EndChatText)
		RunConsoleCommand("stopsound")
	end

	net.Receive("PLAYLIB::StartLockdown",function() 
		PLAYLIB.lockdown.createLockdownPanel()
	end)

	net.Receive("PLAYLIB::EndLockdown",function() 
		PLAYLIB.lockdown.removeLockdownPanel()
	end)
end