if !PLAYLIB then return end

PLAYLIB.mount = PLAYLIB.mount or {}

if SERVER then -- Serverside Code here
	hook.Add("InitPostEntity", "PLAYLIB::Mount", function()
		timer.Simple(60, function()
			if !IsMounted("cstrike") and !util.IsValidModel("models/props/cs_assault/money.mdl") then
				local color = Color(255, 78, 78)
				chat.AddText(Color(255,0,0),"[",PLAYLIB.style.MainHighlightWindowColor,"ACHTUNG",Color(255,255,255),"] - Dir fehlen Inhalte um fehlerfrei hier spielen zu können!")
				chat.AddText(Color(255,0,0),"[",PLAYLIB.style.MainHighlightWindowColor,"ACHTUNG",Color(255,255,255),"] - Benötigter Inhalt: Counter-Strike:Source")
			end
		end)
	end)
elseif CLIENT then -- Clientside Code here
	
end