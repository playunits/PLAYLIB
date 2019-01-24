
if !PLAYLIB then return end

PLAYLIB.medic_sys = PLAYLIB.medic_sys or {}

PLAYLIB.medic_sys.Prefix = "PLAYLIB"
PLAYLIB.medic_sys.PrefixColor = Color(250,128,114)

PLAYLIB.medic_sys.debug = false

if SERVER then
	
	PLAYLIB.medic_sys.viewRanks = {
		["netzwerkleiter"] = true,
		["communityleiter"] = true,
		["projektleiter"] = true,
		["serverleiter"] = true
	}

	PLAYLIB.medic_sys.viewJobs = { -- Enter Job command
		["KKMEDIC"] = true,
		["187THMEDIC"] = true,
		["41STMEDIC"] = true,
		["104THMEDIC"] = true,
		["501STMEDIC"] = true,
		["21STMEDIC"] = true,
		["STMEDIC"] = true,
		["FLOTTENADMIRAL"] = true,
		["ADMIRAL"] = true,
		["VIZEADMIRAL"] = true,
		["REARADMIRAL"] = true
	}

	PLAYLIB.medic_sys.strict = false


elseif CLIENT then

	
end