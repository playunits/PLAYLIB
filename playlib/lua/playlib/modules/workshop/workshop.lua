if !PLAYLIB then return end

PLAYLIB.workshop = PLAYLIB.workshop or {}


PLAYLIB.workshop.workshopCVar = CreateClientConVar("cl_workshop_dl",1,FCVAR_ARCHIVE)

if SERVER then -- Serverside Code here
	util.AddNetworkString("PLAYLIB::WorkshopDL")

	function PLAYLIB.workshop.showWorkshopPanel(ply,checkconvar)
		net.Start("PLAYLIB::WorkshopDL")
			net.WriteBool(checkconvar)
		net.Send(ply)
	end

	hook.Add("PlayerInitialSpawn","PLAYLIB::Workshop",function(ply)
		timer.Simple(2,function()
			PLAYLIB.workshop.showWorkshopPanel(ply,true)
		end)
		
	end)
elseif CLIENT then -- Clientside Code here
	net.Receive("PLAYLIB::WorkshopDL",function()
		local b = net.ReadBool()
		if b then 
			if PLAYLIB.workshop.workshopCVar:GetBool() then
				PLAYLIB.workshop.openWorkshopPanel()
			end
		else
			PLAYLIB.workshop.openWorkshopPanel()
		end 
		
	end)

	local workshopUI
	function PLAYLIB.workshop.openWorkshopPanel()
		
			if IsValid(workshopUI) then return end
			PLAYLIB.vgui.ynDerma(PLAYLIB.workshop.PanelTitle,string.Replace(PLAYLIB.workshop.PanelText,"%pname",LocalPlayer():Name()),
				PLAYLIB.workshop.YesButton,function(self)
					surface.PlaySound("ui/buttonclick.wav")
					RunConsoleCommand("cl_workshop_dl",0)
					gui.EnableScreenClicker(false)
					gui.OpenURL(PLAYLIB.workshop.workshopPage)
				end,
				PLAYLIB.workshop.NoButton,function(self)
					surface.PlaySound("ui/buttonclick.wav")
					RunConsoleCommand("cl_workshop_dl", 0)
					gui.EnableScreenClicker(false)
				end,true)
		
	end

	hook.Add("OnPlayerChat", "PLAYLIB::WorkshopChatCommand", function(ply, text)
		if (string.lower(text) == "!workshop") then
			if ply != LocalPlayer() then return true end
			RunConsoleCommand(PLAYLIB.workshop.conCommandName)
			return true
		end
	end)

	concommand.Add(PLAYLIB.workshop.conCommandName, function()
		gui.OpenURL(PLAYLIB.workshop.workshopPage)
	end)
	
end