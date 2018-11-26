function ulx.impersonate(calling_ply, target_ply, text)
	if target_ply.DarkRPUnInitialized then return end
	if text == "" then ULib.tsayError("No Text specified!") end
	target_ply:imitate(text)
	ulx.fancyLogAdmin(calling_ply,true,"#A impersonated #B.",target_ply)
end
local impersonate = ulx.command("PLAYLIB - Player", "ulx impersonate", ulx.impersonate, "!impersonate")
impersonate:addParam{type=ULib.cmds.PlayerArg}
impersonate:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
impersonate:defaultAccess(ULib.ACCESS_ADMIN)
impersonate:help("Impersonates a Player.")