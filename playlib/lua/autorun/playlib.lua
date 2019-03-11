	/*
	Author: Playunits  https://steamcommunity.com/id/playunits/
*/

PLAYLIB = {}
PLAYLIB.Loading = {}

PLAYLIB.PreLoadModules = {
  "chat_commands",
  "logger",
  "play_derma",
}

PLAYLIB.IgnoreModules = {
  "debug",
  "multilang_textscreens",
}


PLAYLIB.FileExtensionsList = {
    ".png",
    ".vmt"
}

function PLAYLIB.Loading:LoadFile(path,client,server)
  if not server then AddCSLuaFile(path) end

  if client and SERVER then return end
  if server and CLIENT then return end

  include(path)

end

function PLAYLIB.Loading:RegisterAllModules()
  if not PLAYLIB.Modules then PLAYLIB.Modules = {} end

  local _,dirs = file.Find("playlib/modules/*","LUA")

  for index, dir in pairs(dirs) do

    local dir_path = "playlib/modules/"..dir

    if PLAYLIB.Modules[dir] then // Check for doubling entries IDK why

    else
      PLAYLIB.Modules[dir] = {}
      PLAYLIB.Modules[dir]["name"] = dir
      PLAYLIB.Modules[dir]["path"] = dir_path
      PLAYLIB.Modules[dir]["loaded"] = false

      local module_files,_ = file.Find(dir_path.."/*.lua","LUA")

      for index,file in pairs(module_files) do // Config Loading Iteration

        if string.find(string.lower(file), "config") then // Load Configs First
          PLAYLIB.Modules[dir][string.Replace(file,".lua","")] = {["name"]=file,["path"]=dir_path.."/"..file}
          table.remove(module_files,index) // No Double Loading :)
        end

      end

      for index,file in pairs(module_files) do // Load regular files
        PLAYLIB.Modules[dir][string.Replace(file,".lua","")] = {["name"]=file,["path"]=dir_path.."/"..file}
      end

    end

  end
end

function PLAYLIB.Loading:RegisterAllFunctions()
  if not PLAYLIB.Functions then PLAYLIB.Functions = {} end

  local files,_ = file.Find("playlib/functions/*.lua","LUA")

  for index,file in pairs(files) do
    PLAYLIB.Functions[string.Replace(file,".lua","")] = {["name"]=file,["path"]="playlib/functions/"..file}
  end
end

function PLAYLIB.Loading:RegisterAllLibraries()
  if not PLAYLIB.Libraries then PLAYLIB.Libraries = {} end

  local files,_ = file.Find("playlib/libraries/*.lua","LUA")

  for index,file in pairs(files) do
    PLAYLIB.Libraries[string.Replace(file,".lua","")] = {["name"]=file,["path"]="playlib/libraries/"..file}
  end
end

function PLAYLIB.Loading:ReloadModule(string)
  if not PLAYLIB.Modules then return end
  if not PLAYLIB.Modules[string] then return end

  local copy = PLAYLIB.Modules[string]
  local configs = {}

  for index,file in pairs(copy) do
    if not istable(file) then table.RemoveByValue(copy,index) continue end
    if string.find(string.lower(file["name"]), "config") or string.find(string.lower(file["name"]), "cfg") then
      table.insert(configs,file)

      copy[index] = nil
    end
  end

  for index, entry in pairs(configs) do
    if not istable(entry) then continue end

    if string.find(string.lower(entry.name), "cl") or string.find(string.lower(entry.name), "client") then
      self:LoadFile(entry.path,true,false)
      print("| MODULE | "..string.." | "..entry.name.." | "..entry.path.." | Clientside")
    elseif string.find(string.lower(entry.name), "sv") or string.find(string.lower(entry.name), "server") then
      self:LoadFile(entry.path,false,true)
      print("| MODULE | "..string.." | "..entry.name.." | "..entry.path.." | Serverside")
    elseif string.find(string.lower(entry.name), "sh") or string.find(string.lower(entry.name), "shared") then
      self:LoadFile(entry.path)
      print("| MODULE | "..string.." | "..entry.name.." |  "..entry.path.." | Shared")
    else
      self:LoadFile(entry.path)
      print("| MODULE | "..string.." | "..entry.name.." |  "..entry.path.." | Shared")
    end
  end

  for index,entry in pairs(copy) do // Load Configs
    if not istable(entry) then continue end

    if string.find(string.lower(entry.name), "cl") or string.find(string.lower(entry.name), "client") then
      self:LoadFile(entry.path,true,false)
      print("| MODULE | "..string.." | "..entry.name.." | "..entry.path.." | Clientside")
    elseif string.find(string.lower(entry.name), "sv") or string.find(string.lower(entry.name), "server") then
      self:LoadFile(entry.path,false,true)
      print("| MODULE | "..string.." | "..entry.name.." | "..entry.path.." | Serverside")
    elseif string.find(string.lower(entry.name), "sh") or string.find(string.lower(entry.name), "shared") then
      self:LoadFile(entry.path)
      print("| MODULE | "..string.." | "..entry.name.." | "..entry.path.." | Shared")
    else
      self:LoadFile(entry.path)
      print("| MODULE | "..string.." | "..entry.name.." | "..entry.path.." | Shared")
    end
  end
  PLAYLIB.Modules[string]["loaded"] = true
end

function PLAYLIB.Loading:ReloadFunction(string)
  if not PLAYLIB.Functions then return end
  if not PLAYLIB.Functions[string] then return end


  if string.find(string.lower(PLAYLIB.Functions[string].name), "cl") or string.find(string.lower(PLAYLIB.Functions[string].name), "client") then
    self:LoadFile(PLAYLIB.Functions[string].path,true,false)
    print("| FUNCTION | "..string.." | "..PLAYLIB.Functions[string].path.." | Clientside")
  elseif string.find(string.lower(PLAYLIB.Functions[string].name), "sv") or string.find(string.lower(PLAYLIB.Functions[string].name), "server") then
    self:LoadFile(PLAYLIB.Functions[string].path,false,true)
    print("| FUNCTION | "..string.." | "..PLAYLIB.Functions[string].path.." | Serverside")
  elseif string.find(string.lower(PLAYLIB.Functions[string].name), "sh") or string.find(string.lower(PLAYLIB.Functions[string].name), "shared") then
    self:LoadFile(PLAYLIB.Functions[string].path)
    print("| FUNCTION | "..string.." | "..PLAYLIB.Functions[string].path.." | Shared")
  else
    self:LoadFile(PLAYLIB.Functions[string].path)
    print("| FUNCTION | "..string.." | "..PLAYLIB.Functions[string].path.." | Shared")
  end

end

function PLAYLIB.Loading:ReloadLibrary(string)
  if not PLAYLIB.Libraries then return end
  if not PLAYLIB.Libraries[string] then return end

  if string.find(string.lower(PLAYLIB.Libraries[string].name), "cl") or string.find(string.lower(PLAYLIB.Libraries[string].name), "client") then
    self:LoadFile(PLAYLIB.Libraries[string].path,true,false)
    print("| LIBRARY | "..string.." | "..PLAYLIB.Libraries[string].path.." | Clientside")
  elseif string.find(string.lower(PLAYLIB.Libraries[string].name), "sv") or string.find(string.lower(PLAYLIB.Libraries[string].name), "server") then
    self:LoadFile(PLAYLIB.Libraries[string].path,false,true)
    print("| LIBRARY | "..string.." | "..PLAYLIB.Libraries[string].path.." | Serverside")
  elseif string.find(string.lower(PLAYLIB.Libraries[string].name), "sh") or string.find(string.lower(PLAYLIB.Libraries[string].name), "shared") then
    self:LoadFile(PLAYLIB.Libraries[string].path)
    print("| LIBRARY | "..string.." | "..PLAYLIB.Libraries[string].path.." | Shared")
  else
    self:LoadFile(PLAYLIB.Libraries[string].path)
    print("| LIBRARY | "..string.." | "..PLAYLIB.Libraries[string].path.." | Shared")
  end
end



function PLAYLIB.Loading:LoadAll()
  print("")
  MsgC(Color(153,50,204),"//////////",Color(255,255,255)," PLAYLIB ",Color(153,50,204),"\\\\\\\\\\\\\\\\\\\\")
  print("\n")
  MsgC(Color(0,0,255),"+++ Registering all Files +++")
  print("\n")

  PLAYLIB.Loading:RegisterAllLibraries()
  PLAYLIB.Loading:RegisterAllFunctions()
  PLAYLIB.Loading:RegisterAllModules()

  MsgC(Color(0,255,0),"--- Finished Registering all Files ---")
  print("\n")

    MsgC(Color(0,0,255),"+++ Starting Loading of Libraries +++")
    print("\n\n")
    print("| Type   | Name    | Path    | Loading Side  \n")

    for index,lib in pairs(PLAYLIB.Libraries) do
      self:ReloadLibrary(index)
    end

    print("")
    MsgC(Color(0,255,0),"--- Finished Loading of Libraries ---")
    print("\n")
    MsgC(Color(0,0,255),"+++ Starting Loading of Functions +++")
    print("\n\n")
    print("| Type   | Name    | Path    | Loading Side  \n")
    for index,func in pairs(PLAYLIB.Functions) do
      self:ReloadFunction(index)
    end

    print("")
    MsgC(Color(0,255,0),"--- Finished Loading of Functions ---")
    print("\n")
    MsgC(Color(0,0,255),"+++ Starting Loading of Preload Modules +++")
    print("\n\n")
    print("| Type   | Module Name   | Name    | Path    | Loading Side  \n")

    for index,p_mod in pairs(PLAYLIB.PreLoadModules) do
      self:ReloadModule(p_mod)
    end
    print("")
    MsgC(Color(0,255,0),"--- Finished Loading of Preload Modules ---")
    print("\n")
    MsgC(Color(0,0,255),"+++ Starting Loading of Modules +++")
    print("\n\n")
    if table.Count(PLAYLIB.IgnoreModules) != 0 then
      MsgC(Color(255,0,0),"Ignoring/Not Loading following Modules")
      print("\n")
      for index,name in pairs(PLAYLIB.IgnoreModules) do
        MsgC(Color(255,0,0),name)
        print("")
      end
      print("")
      MsgC(Color(255,0,0),"Change in playlib/lua/autorun/playlib.lua")
      print("\n")
    end
    print("| Type   | Module Name   | Name    | Path    | Loading Side  \n")

    for index,mod in pairs(PLAYLIB.Modules) do
      if table.HasValue(PLAYLIB.IgnoreModules,mod["name"]) then continue end
      if table.HasValue(PLAYLIB.PreLoadModules,mod["name"]) then continue end
      self:ReloadModule(index)
    end

    print("")
    MsgC(Color(0,255,0),"--- Finished Loading of Modules ---")
    print("\n")


  MsgC(Color(0,255,0),"--- Finished Loading everything ---")
  print("\n")
  MsgC(Color(153,50,204),"\\\\\\\\\\\\\\\\\\\\",Color(255,255,255)," PLAYLIB ",Color(153,50,204),"//////////")
  print("\n")
end

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

PLAYLIB.Loading:LoadAll()
