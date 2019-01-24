include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	// The text to display
	local text = "Kleiderschrank"

	// The position. We use model bounds to make the text appear just above the model. Customize this to your liking.
	local mins, maxs = self:GetModelBounds()
	local pos = self:GetPos() + Vector( 0, 0, maxs.z + 20 )

	// The angle
	local ang = Angle( 0, self:GetAngles().y+90, 90 ) --SysTime() * 100 % 360

	// Draw front
	cam.Start3D2D( pos, ang, 0.2 )
		// Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "BFHUD.Size50", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

	// Flip the angle 180 degress around the UP axis
	ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )

	// Draw back
	cam.Start3D2D( pos, ang, 0.2 )
		// Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "BFHUD.Size50", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end
