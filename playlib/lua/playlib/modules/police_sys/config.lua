
if !PLAYLIB then return end

PLAYLIB.police_sys = PLAYLIB.police_sys or {}

PLAYLIB.police_sys.Prefix = "PLAYLIB"
PLAYLIB.police_sys.PrefixColor = Color(250,128,114)

PLAYLIB.police_sys.debug = false

if SERVER then
	
	PLAYLIB.police_sys.viewRanks = {
		["netzwerkleiter"] = true,
		["communityleiter"] = true,
		["projektleiter"] = true,
		["serverleiter"] = true
	}

	PLAYLIB.police_sys.viewJobs = { -- Enter Job command
		["STCDRFOX"] = true,
		["STCDRTHORN"] = true,
		["STmajor"] = true,
		["STcaptain"] = true,
		["STlieutenant"] = true,
		["STsergeant"] = true,
		["STcorporal"] = true,
		["STprivate"] = true,
		["STMEDIC"] = true,
		["STK9"] = true,
		["STRIOT"] = true,
		["FLOTTENADMIRAL"] = true,
		["ADMIRAL"] = true,
		["VIZEADMIRAL"] = true,
		["REARADMIRAL"] = true
	} 

	PLAYLIB.police_sys.strict = false


elseif CLIENT then

	
end