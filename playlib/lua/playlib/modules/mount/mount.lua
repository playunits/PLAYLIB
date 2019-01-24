if !PLAYLIB then return end

PLAYLIB.mount = PLAYLIB.mount or {}

PLAYLIB.mount.Prefix = "ACHTUNG"
PLAYLIB.mount.PrefixColor = Color(250,128,114)

if SERVER then -- Serverside Code here
	
elseif CLIENT then -- Clientside Code here
	hook.Add("InitPostEntity", "PLAYLIB::Mount", function()
		timer.Simple(60, function()
			if !IsMounted("cstrike") and !util.IsValidModel("models/props/cs_assault/money.mdl") then
				local color = Color(255, 78, 78)
				chat.AddText(Color(255,255,255),"[",PLAYLIB.mount.PrefixColor,PLAYLIB.mount.Prefix,Color(255,255,255),"] - Dir fehlen Inhalte um fehlerfrei hier spielen zu können!")
				chat.AddText(Color(255,255,255),"[",PLAYLIB.mount.PrefixColor,PLAYLIB.mount.Prefix,Color(255,255,255),"] - Benötigter Inhalt: Counter-Strike:Source")
			end
		end)
	end)
end