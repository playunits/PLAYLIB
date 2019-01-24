if !PLAYLIB then return end

PLAYLIB.uptime = PLAYLIB.uptime or {}

PLAYLIB.uptime.onlineTime = 0

if SERVER then

	function PLAYLIB.uptime.getTime()
		local time = math.floor(CurTime())
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
