if !PLAYLIB then return end

if SERVER then
	
	hook.Add("CanPlayerSuicide","DisableSuicide",function(ply)
		return false 
	end)

elseif CLIENT then
	
end