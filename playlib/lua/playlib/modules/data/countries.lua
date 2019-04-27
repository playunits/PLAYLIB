if !PLAYLIB then return end

PLAYLIB.Data = PLAYLIB.Data or {}

PLAYLIB.Data.Countries = PLAYLIB.Data.Countries or {}

function PLAYLIB.Data.Countries:CodeToName(code)
    local path = "playlib/modules/data/countries.txt"
    if !file.Exists(path,"LUA") then return end
    for key,data in pairs(util.JSONToTable(file.Read(path,"LUA"))) do
        if string.lower(data.alpha2) == string.lower(code) or string.lower(data.alpha3) == string.lower(code) then
            return data.name
        end
    end

    return nil
end