/*
	@Author: Playunits  https://steamcommunity.com/id/playunits/
*/

PLAYLIB = {}

function PLAYLIB:LoadFile(path,type, serverOnly, clientOnly)
    if not serverOnly then AddCSLuaFile(path) end

    if clientOnly and SERVER then return end
    if serverOnly and CLIENT then return end


    include(path)
    if type == "core" then
        print("[PLAYLIB] [CORE] Loaded file: "..path)  
    elseif type == "module" then
        print("[PLAYLIB] [MODULE] Loaded file: "..path)  
    elseif type == "ex_base" then
        print("[PLAYLIB] [EXTERNAL BASE] Loaded file: "..path)  
    elseif type == "function" then
        print("[PLAYLIB] [FUNCTION] Loaded file: "..path)  
    else
        print("[PLAYLIB] [NOT DEFINED] Loaded file: "..path)  
    end

    
end

function PLAYLIB:AutoLoadModules()
    local files,dir = file.Find("playlib/modules/*","LUA")

    for index,dir2 in pairs(dir,true) do

        local sdir = "playlib/modules/"..dir2

        for index,file in pairs(file.Find(sdir.."/*","LUA")) do
            local lua = sdir.."/"..file

            if not string.find(file,"txt") == nil then continue end 
            self:LoadFile(lua,"module")
        end
            
           
    end
end

function PLAYLIB:AutoLoadFunctions()
    for index,file in pairs(file.Find("playlib/functions/*","LUA"),true) do
        local lua = "playlib/functions/"..file
            
            if not string.find(file,"txt") == nil then continue end 
            self:LoadFile(lua,"function")
            
    end
end

function PLAYLIB:AutoLoadExternalBases()
    for index,file in pairs(file.Find("playlib/ex_bases/*","LUA"),true) do
        local lua = "playlib/ex_bases/"..file
            if not string.find(file,"txt") == nil then continue end 
            self:LoadFile(lua,"ex_base")
    end
end

function PLAYLIB:AutoLoadCore()
    for index,file in pairs(file.Find("playlib/core/*","LUA"),true) do
        local lua = "playlib/core/"..file
            if not string.find(file,"txt") == nil then continue end 
            self:LoadFile(lua,"core")
           
    end
end

function PLAYLIB:StartAutoLoading()
    self:AutoLoadCore()
    self:AutoLoadFunctions()
    self:AutoLoadExternalBases()
    self:AutoLoadModules()
end

PLAYLIB:StartAutoLoading()