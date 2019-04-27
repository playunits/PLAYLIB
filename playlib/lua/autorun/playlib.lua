	/*
	Author: Playunits  https://steamcommunity.com/id/playunits/
*/

PLAYLIB = {}
if SERVER then
  AddCSLuaFile("playlib/functions/fileloading.lua")
end

include("playlib/functions/fileloading.lua")

function PLAYLIB:CreateDataPath()
    if !file.Exists("playlib","DATA") then
        file.CreateDir("playlib")
    end
end

if CLIENT then
        for i=10, 100 do
        surface.CreateFont( "BFHUD.Outlined.Size"..i, {
            font = "BFHud", -- Use the font+name which is shown to you by your operating system Font Viewer, not the file name
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
            font = "BFHud", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
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
            font = "BFHud", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
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

PLAYLIB.FS:Startup()
