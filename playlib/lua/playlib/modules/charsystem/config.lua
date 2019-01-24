if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

PLAYLIB.charsystem.MaxNameLength = 40
PLAYLIB.charsystem.StartMoney  = 100
PLAYLIB.charsystem.StandardTeam = "Citizen"
PLAYLIB.charsystem.StandardCharSlots = 1
PLAYLIB.charsystem.UsergroupSettings={
	["superadmin"] = 3,
	["donator"] = 3,
}

PLAYLIB.charsystem.Prefix = "PLAYLIB"
PLAYLIB.charsystem.PrefixColor = Color(250,128,114)

PLAYLIB.charsystem.MainHighlightWindowColor = Color(250,128,114)
PLAYLIB.charsystem.MainBaseWindowColor = Color(255,250,240)

PLAYLIB.charsystem.getWhitelistJobFuncs = function(ply)
	local data = {}
	bWhitelist:GetPlayerWhitelists(ply,function(tbl) data = tbl end)
	return tbl
end
