if !PLAYLIB then return end

if SERVER then
	
elseif CLIENT then
	
end

hook.Add("GravGunPunt","DisableGravGunShooting",function(ply,ent)
	return false 
end)