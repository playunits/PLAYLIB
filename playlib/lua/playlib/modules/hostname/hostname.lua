if !PLAYLIB then return end

PLAYLIB.hostname = PLAYLIB.hostname or {}

if SERVER then -- Serverside Code here
    hook.Add("Initialize","PLAYLIB::AutoHostnameAdd",function() 
        PLAYLIB.hostname.AutoHostname(" | Developed by playunits")

        timer.Create("PLAYLIB::CheckHostName",60,0,function() PLAYLIB.hostname.AutoHostname(" | Developed by playunits") end)
    end)

    function PLAYLIB.hostname.AutoHostname(string)
        local oldname = GetHostName()
        local newname = oldname..string

        if not string.find(oldname," | Developed by playunits") then
            RunConsoleCommand("hostname",newname)
        end

    end


    
elseif CLIENT then -- Clientside Code here

end

--if not string.find(GetHostName()," | Developed by playunits") then RunConsoleCommand("hostname",GetHostName().." | Developed by playunits") print("DONE") end
            
        