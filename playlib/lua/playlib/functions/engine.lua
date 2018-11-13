if !PLAYLIB then return end

PLAYLIB.engine = PLAYLIB.engine or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

function PLAYLIB.engine.getInfos()
    local retval = {}

    retval["games"]= engine.GetGames()
    retval["timescale"] = game.GetTimeScale()
    retval["maxplayers"] = game.MaxPlayers()
    retval["map"] = game.GetMap()
    retval["ip"] = game.GetIPAddress()
    retval["addons"] = engine.GetAddons()

    return retval
end

function PLAYLIB.engine.getAddons()
    return engine.GetAddons()
end