if !PLAYLIB then return end

PLAYLIB.hud = PLAYLIB.hud or {}

if SERVER then
	
elseif CLIENT then

	surface.CreateFont( "PLAYLIB::HUDFont", {
		font = "Exo", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = ScrH() / 60,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "PLAYLIB::HUDFontBold", {
		font = "Exo", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = ScrH() / 30,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	hook.Add("HUDPaint","PLAYLIB::HUD",function()
		surface.SetFont( "PLAYLIB::HUDFont" )
		surface.SetDrawColor(Color(30,30,30,230)) 
		surface.DrawRect(0,0,ScrW(),(ScrH()/21)/1.5) --Base Bar
		--surface.DrawRect(0,ScrH()-(ScrH()/10.8),ScrW()/6,ScrH()/21)
		--surface.DrawRect(ScrW()-(ScrW()/6),ScrH()-(ScrH()/10.8),ScrW()/6,ScrH()/21)

		local scale = (ScrH()/21) * 0.01
		--PLAYLIB.vgui.drawTriangle(ScrW()/6,ScrH()-(ScrH()/22),scale,Color(30,30,30,230),true)
		--PLAYLIB.vgui.drawTriangle(ScrW()-(ScrW()/6),ScrH()-(ScrH()/22),scale,Color(30,30,30,230),false)

		--[[
			Health Drawing
		]]--
		--surface.SetDrawColor(Color(10,10,10,230)) 
		--surface.DrawRect((ScrW()/50), ScrH() - (ScrH()/12),230,32)
		
		--surface.SetDrawColor(Color(255,0,0,255))
		--surface.DrawRect((ScrW()/50), ScrH() - (ScrH()/12),230 * math.Clamp((LocalPlayer():Health()/LocalPlayer():GetMaxHealth()),0,1),32)
		surface.SetDrawColor(Color(255,255,255,255)) 
		surface.SetMaterial(PLAYLIB.hud.health)
		surface.DrawTexturedRect((ScrW()/20),ScrH()/200,24,24)
		draw.DrawText(((LocalPlayer():Health()/LocalPlayer():GetMaxHealth())*100).." %"	,"PLAYLIB::HUDFont",(ScrW()/13),ScrH()/120,Color(255,255,255,255),TEXT_ALIGN_CENTER)


		--[[
			Armor Drawing
		]]--
		--surface.SetDrawColor(Color(10,10,10,230)) 
		--surface.DrawRect((ScrW()/50), ScrH() - (ScrH()/25),230,32)
		
		--surface.SetDrawColor(Color(0,0,255,255)) 
		--surface.DrawRect((ScrW()/50), ScrH() - (ScrH()/25),230 * math.Clamp(LocalPlayer():Armor()/100,0,1),32)
		surface.SetDrawColor(Color(255,255,255,255)) 
		surface.SetMaterial(PLAYLIB.hud.armor)
		surface.DrawTexturedRect((ScrW()/6),ScrH()/200,24,24)
		draw.DrawText(math.floor(((LocalPlayer():Armor()/255)*100)).." %","PLAYLIB::HUDFont",(ScrW()/5),ScrH()/120,Color(255,255,255,255),TEXT_ALIGN_CENTER)

		--[[
			Name Drawing
		]]--
		surface.SetDrawColor(Color(255,255,255,255)) 
		surface.SetMaterial(PLAYLIB.hud.name)
		surface.DrawTexturedRect((ScrW()/2.08),ScrH()/200,24,24)
		draw.DrawText(LocalPlayer():Name(),"PLAYLIB::HUDFont",(ScrW()/2),ScrH()/120,Color(255,255,255,255),TEXT_ALIGN_LEFT)

		--[[
			Money Drawing
		]]--
		surface.SetDrawColor(Color(255,255,255,255)) 
		surface.SetMaterial(PLAYLIB.hud.wallet)
		surface.DrawTexturedRect(ScrW() - (ScrW()/5),ScrH()/200,24,24)
		draw.DrawText(PLAYLIB.hud.moneyPrefix.." "..LocalPlayer():getDarkRPVar('money'),"PLAYLIB::HUDFont",ScrW() - (ScrW()/5),ScrH()/120,Color(255,255,255,255),TEXT_ALIGN_LEFT)

		--[[
			Team Drawing
		]]--
		draw.DrawText(PLAYLIB.hud.teamPrefix.." "..LocalPlayer():getDarkRPVar('job'),"PLAYLIB::HUDFont",ScrW() - (ScrW()/13),ScrH()/120,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	
		--[[
			Ammo Drawing
		]]--
		local wep = LocalPlayer():GetActiveWeapon()
		local clip = wep:Clip1()
		local ammo = wep:GetPrimaryAmmoType()

		if IsValid(wep) then
			if clip != -1 or ammo != -1 then
				draw.DrawText(wep:Clip1().." | "..LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType()),"PLAYLIB::HUDFontBold",ScrW()/2,ScrH() - (ScrH()/10),Color(255,255,255,255),TEXT_ALIGN_CENTER)
			end
		end
		
	end)
end