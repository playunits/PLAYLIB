if !PLAYLIB then return end

PLAYLIB.workshop = PLAYLIB.workshop or {}

PLAYLIB.workshop.workshopPage = "https://google.de"
PLAYLIB.workshop.workshopCVar = CreateClientConVar("cl_workshop_dl",1,FCVAR_ARCHIVE)
if SERVER then -- Serverside Code here
	util.AddNetworkString("PLAYLIB::WorkshopDL")

	function PLAYLIB.workshop.showWorkshopPanel(ply)
		net.Start("PLAYLIB::WorkshopDL")
		net.Send(ply)
	end

	hook.Add("PlayerInitialSpawn","PLAYLIB::Workshop",function(ply)
		timer.Simple(2,function()
			PLAYLIB.workshop.showWorkshopPanel(ply)
		end)
		
	end)
elseif CLIENT then -- Clientside Code here
	net.Receive("PLAYLIB::WorkshopDL",function() 
		PLAYLIB.workshop.openWorkshopPanel()
	end)

	local workshopUI
	function PLAYLIB.workshop.openWorkshopPanel()
		if PLAYLIB.workshop.workshopCVar:GetBool() then
			if IsValid(workshopUI) then return end
			PLAYLIB.vgui.ynDerma("Workshop Inhalte downloaden?","Wie gehts "..LocalPlayer():Name().."?\n Sieht so aus als wärst du das erste mal bei uns.\n Möchtest du unsere Workshop Inhalte herunterladen?",
				"Ja",function(self)
					surface.PlaySound("ui/buttonclick.wav")
					RunConsoleCommand("cl_workshop_dl",0)
					gui.EnableScreenClicker(false)
					gui.OpenURL(PLAYLIB.workshop.workshopPage)
				end,
				"Nichtmehr anzeigen",function(self)
					surface.PlaySound("ui/buttonclick.wav")
					RunConsoleCommand("cl_workshop_dl", 0)
					gui.EnableScreenClicker(false)
				end,true)
		end
	end

	hook.Add("OnPlayerChat", "PLAYLIB::WorkshopChatCommand", function(ply, text)
		if (string.lower(text) == "!workshop") then
			if ply != LocalPlayer() then return true end
			RunConsoleCommand("workshop")
			return true
		end
	end)

	concommand.Add("workshop", function()
		gui.OpenURL(PLAYLIB.workshop.workshopPage)
	end)
	
end