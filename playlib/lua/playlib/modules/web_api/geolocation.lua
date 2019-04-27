if !PLAYLIB then return end

PLAYLIB.Geolocation = PLAYLIB.Geolocation or {}

PLAYLIB.Geolocation.Config = {
    message = {Color(255,255,255,255),"Willkommen ",Color(0,255,0,255),"{name} ",Color(255,255,255,255),"auf unserem Server. Wir haben erkannt, dass du aus ",Color(0,255,0,255),"{country} ",Color(255,255,255,255),"kommst."},
    data = {Color(255,255,255,255),"Deine Daten:",Color(0,255,0,255),"{continent}, ",Color(0,255,0,255),"{country}, ",Color(0,255,0,255),"{region}",Color(0,255,0,255),"{lat}, ",Color(0,255,0,255),"{long}",Color(0,255,0,255),"{currency}"},
}

function PLAYLIB.Geolocation:Message(ply)
    local message = table.Copy(PLAYLIB.Geolocation.Config.message)
    PLAYLIB.Web_API.Geolocation(ply:IPAddress(),function(tbl) 
        for key, val in pairs(message) do
            if type(val) == "string" then
                message[key] = string.multiReplace(val,{"{name}",ply:Name(),"{country}",PLAYLIB.Data.Countries:CodeToName(tbl.geoplugin_countryCode)})
            end
        end

        PLAYLIB.misc.chatNotify(ply,message)
    end)
end

hook.Add("PlayerInitialSpawn","PLAYLIB.Geolocation:Greet",function(ply) 
    PLAYLIB.Geolocation:Message(ply)
end)

hook.Add("PlayerConnect","PLAYLIB.Geolocation:LoacteJoins",function(name,ip) 
    
    PLAYLIB.Web_API.Geolocation(ip,function(tbl) 
        MsgC(Color(0,0,255,255),"[PLAYLIB]",Color(255,255,255,255)," - "..name.." ("..ip..") ("..PLAYLIB.Data.Countries:GetNameByCode(tbl.geoplugin_countryCode)..") ist dem Server beigetreten.")
    end)
end)