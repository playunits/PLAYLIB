if !PLAYLIB then return end

PLAYLIB.uptime = PLAYLIB.uptime or {}

PLAYLIB.uptime.onlineTime = 0 

if SERVER then

	

	hook.Add("Initialize","PLAYLIB::StartOnlineTimer",function()
		PLAYLIB.uptime.onlineTime = 0 
		timer.Create("PLAYLIB::ServerOnlineTimer",1,0,function() 
			PLAYLIB.uptime.incrementOnlineTime()
		end)
	end)

	hook.Add("ShutDown","PLAYLIB::RemoveOnlineTimer",function() 
		timer.Remove("PLAYLIB::ServerOnlineTimer")
		timer.Remove("PLAYLIB::ServerOnlineMessageTimer")
		PLAYLIB.uptime.onlineTime = 0 
	end)

	function PLAYLIB.uptime.startMessageTimer()
		timer.Create("PLAYLIB::ServerOnlineMessageTimer",PLAYLIB.uptime.messageInterval,0,function() 
			PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.style.MainHighlightWindowColor,PLAYLIB.chatcommand.Prefix,Color(255,255,255),"] - "..string.Replace(PLAYLIB.uptime.Message,"%time",PLAYLIB.uptime.getTime())})
		end)
	end

	function PLAYLIB.uptime.incrementOnlineTime()
		PLAYLIB.uptime.onlineTime = PLAYLIB.uptime.onlineTime + 1

		if PLAYLIB.uptime.onlineTime >= PLAYLIB.uptime.timeBeforeMessage then
			PLAYLIB.uptime.startMessageTimer()
		end
	end

	function PLAYLIB.uptime.getTime()
		local time = PLAYLIB.uptime.onlineTime
		if time > 3599 then
			local hh = "Stunden"
			local ss = "Sekunden"
			local mm = "Minuten"


			local h = math.floor(time / 3600)
			time = time - (h*3600)
			local m = math.floor(time/60)
			time = time -(m*60)
			local s = time

			if h < 2 then
				hh = "Stunde"
			end

			if s < 2 then
				ss = "Sekunde"
			end

			if m < 2 then
				mm = "Minute"
			end
			return h.." "..hh..", "..m.." "..mm..", "..s.." "..ss..""
		elseif time > 59 then
			local ss = "Sekunden"
			local mm = "Minuten"

			local m = math.floor(time/60)
			time = time - (m*60)
			local s = time

			if s < 2 then
				ss = "Sekunde"
			end

			if m < 2 then
				mm = "Minute"
			end

			return m.." "..mm..", "..s.." "..ss..""
		else
			local ss = "Sekunden"
			local s = time

			if s < 2 then
				ss = "Sekunde"
			end

			return s.." "..ss..""
		end
		
	end



elseif CLIENT then

end
	
			
			
	



