/*
	@Author: Playunits  https://steamcommunity.com/id/playunits/
*/

PLAYLIB = {}


PLAYLIB.FileExtensionsList = {
    ".png",
    ".vmt"
}


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

        for index,file in pairs(file.Find(sdir.."/*.lua","LUA")) do
            local lua = sdir.."/"..file
            self:LoadFile(lua,"module")
            
        end
            
           
    end
end

function PLAYLIB:AutoLoadFunctions()
    for index,file in pairs(file.Find("playlib/functions/*.lua","LUA"),true) do
        local lua = "playlib/functions/"..file
            self:LoadFile(lua,"function")
            
    end
end

function PLAYLIB:AutoLoadExternalBases()
    for index,file in pairs(file.Find("playlib/ex_bases/*.lua","LUA"),true) do
        local lua = "playlib/ex_bases/"..file
            self:LoadFile(lua,"ex_base")
    end
end

function PLAYLIB:AutoLoadCore()
    for index,file in pairs(file.Find("playlib/core/*.lua","LUA"),true) do
        local lua = "playlib/core/"..file
            self:LoadFile(lua,"core")
           
    end
end

function PLAYLIB:StartAutoLoading()
    --self:AutoLoadCore()
    self:AutoLoadFunctions()
    self:AutoLoadExternalBases()
    self:AutoLoadModules()
end

function PLAYLIB:CreateDataPath()
    if !file.Exists("playlib","DATA") then
        file.CreateDir("playlib")
    end
end

if CLIENT then
        for i=10, 100 do 
        surface.CreateFont( "BFHUD.Outlined.Size"..i, {
            font = "BFHUD", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = true,
            size = i,
            weight = 500,
            blursize = 0, 
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false, 
            strikeout = true,
            symbol = false,
            rotary = false,
            shadow = false, 
            additive = false,
            outline = true, 
        } ) 
        surface.CreateFont( "BFHUD.Blurred.Size"..i, {
            font = "BFHUD", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = false,
            size = i,
            weight = 500,
            blursize = 4, 
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false, 
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = true,
        } )
        surface.CreateFont( "BFHUD.Size"..i, {
            font = "BFHUD", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = false,
            size = i,
            weight = 500,
            blursize = 0,
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false, 
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = false,
        } )
    end
end

PLAYLIB:StartAutoLoading()
PLAYLIB:CreateDataPath()