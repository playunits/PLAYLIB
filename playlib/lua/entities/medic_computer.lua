
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Medic Computer"
ENT.Author = "playunits"
ENT.Category = "CubeGeneration"

ENT.Spawnable = true


-- This is the spawn function. It's called when a client calls the entity to be spawned.
-- If you want to make your SENT spawnable you need one of these functions to properly create the entity
--
-- ply is the name of the player that is spawning it
-- tr is the trace from the player's eyes
--
function ENT:Initialize()

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
 
	self:SetModel( "models/lt_c/holo_laptop.mdl" )
	self:SetSkin( 5 )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end



function ENT:Use( activator, caller )

	if !IsFirstTimePredicted then return end
	if CLIENT then return end
	if SERVER then
		local ply = caller
		if IsValid(ply) and ply:Alive() then
			PLAYLIB.medic_sys.openUI(ply)
		end
	end

end

if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER

function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    self:DrawModel()       -- Draw the model.

    // The text to display
	local text = "Medic Computer"

	// The position. We use model bounds to make the text appear just above the model. Customize this to your liking.
	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 10 )

	// The angle
	local ang = Angle( 0, self:GetAngles().y, 90 ) --SysTime() * 100 % 360

	// Draw front
	cam.Start3D2D( pos, ang, 0.2 )
		// Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "BFHUD.Size25", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

	// Flip the angle 180 degress around the UP axis
	ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )

	// Draw back
	cam.Start3D2D( pos, ang, 0.2 )
		// Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "BFHUD.Size25", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

end
