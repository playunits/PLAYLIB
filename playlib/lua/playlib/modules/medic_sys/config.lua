
if !PLAYLIB then return end

PLAYLIB.medic_sys = PLAYLIB.medic_sys or {}

if SERVER then
	PLAYLIB.medic_sys.Prefix = "PLAYLIB"
	PLAYLIB.medic_sys.PrefixColor = Color(250,128,114)

	PLAYLIB.medic.debug = false

	PLAYLIB.medic.deleteRanks = {
		["superadmin"] = true,
		["supporter"] = true,
	}

	PLAYLIB.medic.deleteJobs = {
		[TEAM_CITIZEN] = true,
	}

	PLAYLIB.medic.strict = false


elseif CLIENT then

	
end