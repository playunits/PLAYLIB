if !PLAYLIB then return end

PLAYLIB.player = PLAYLIB.player or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

function PLAYLIB.player.imitate(ply,text)

	if !IsValid(ply) or !ply:IsAdmin() or text == "" then return end
	
	ply:ConCommand("say "..text)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:imitate(text)
	PLAYLIB.player.imitate(self,text)
end