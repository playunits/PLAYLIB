if !PLAYLIB then return end

PLAYLIB.captcha = PLAYLIB.captcha or {}

PLAYLIB.captcha.captchaCVar = CreateClientConVar("cl_captcha",1,FCVAR_ARCHIVE)

if SERVER then
		util.AddNetworkString("PLAYLIB::OpenCaptcha")

		hook.Add("PlayerInitialSpawn","PLAYLIB::ShowCaptcha",function(ply) 
			net.Start("PLAYLIB::OpenCaptcha")
				net.WriteString(tostring(PLAYLIB.captcha.startTries))
			net.Send(ply)
		end)
		
		
elseif CLIENT then
	PLAYLIB.captcha.panel = nil

	net.Receive("PLAYLIB::OpenCaptcha",function() 
		PLAYLIB.captcha.openCaptcha(tonumber(net.ReadString()))
	end)

	

	function PLAYLIB.captcha.openCaptcha(tries)
		if not PLAYLIB.captcha.captchaCVar:GetBool() then return end
		if IsValid(PLAYLIB.captcha.panel) then PLAYLIB.captcha.panel:Remove() end
		local randnr = math.random(#PLAYLIB.captcha.questions)
		PLAYLIB.captcha.panel = PLAYLIB.vgui.valueDerma(string.Replace(PLAYLIB.captcha.PanelTitle,"%tries",tries),PLAYLIB.captcha.questions[randnr][1],
			PLAYLIB.captcha.SubmitText,function(btn,val)
				if string.lower(val) == string.lower(PLAYLIB.captcha.questions[randnr][2]) then
					chat.AddText(Color(255,255,255),"[",PLAYLIB.captcha.PrefixColor,PLAYLIB.captcha.Prefix,Color(255,255,255),"] - "..PLAYLIB.captcha.CaptchaSuccess)
					RunConsoleCommand("cl_captcha",0)
				else

						--net.Start("PLAYLIB::InvalidCaptcha")
						--net.SendToServer()
						if tries <= 1 then
							RunConsoleCommand("disconnect")
							return
						end

						PLAYLIB.captcha.openCaptcha(tries-1)
				end
			end,
			PLAYLIB.captcha.DisconnectText,function(btn) RunConsoleCommand("disconnect") end,true)
	end
end