function ulx.debug(calling_ply)
	if calling_ply.DarkRPUnInitialized then return end
	if calling_ply:getDebugState() then
        calling_ply:setDebugState(false)
        ulx.fancyLogAdmin( calling_ply,true, "#A turned off Debug Mode.", calling_ply )
    else
        calling_ply:setDebugState(true)
        ulx.fancyLogAdmin( calling_ply,true, "#A turned on Debug Mode", calling_ply )
	end
end
local debug = ulx.command("PLAYLIB - Debug", "ulx debug", ulx.debug, "!debug",true)
debug:defaultAccess(ULib.ACCESS_ADMIN)
debug:help("Starts the Debug Mode.")

function ulx.stopsound(calling_ply)
	if !IsValid(calling_ply) then return end
	calling_ply:ConCommand( "stopsound" )
end
local stopsound = ulx.command("PLAYLIB - Debug", "ulx stopsound", ulx.stopsound, "!stopsound")
stopsound:defaultAccess(ULib.ACCESS_ADMIN)
stopsound:help("Stops the Sound.")