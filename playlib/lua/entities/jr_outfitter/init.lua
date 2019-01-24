AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel( "models/fyu/dezio/sith/armoire_sith.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics, -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )      -- Toolbox

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if SERVER then
		if not caller:GetJobRank() then return end
		if caller:GetJobRank() == 0 then
			net.Start("PLAYLIB.jr_outfitter:StandardModelChange")
			net.Send(caller)
			return
		end
		if not JobRanks[caller:Team()] then return end
		if not JobRanks[caller:Team()].Model then return end
		if not JobRanks[caller:Team()].Model[caller:GetJobRank()] then return end

		net.Start("PLAYLIB.jr_outfitter:OpenMenu")
			net.WriteTable(JobRanks[caller:Team()].Model[caller:GetJobRank()])
		net.Send(caller)
	end
end
