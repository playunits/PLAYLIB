PLAYLIB = PLAYLIB or {}
PLAYLIB.FS = PLAYLIB.FS or {}
PLAYLIB.FS.Files = PLAYLIB.FS.Files or {}
PLAYLIB.FS.StartDirectories = {
    "playlib"
}
PLAYLIB.FS.Messages = {
    ["index"] = false,
    ["load"] = true
}

PLAYLIB_FS_MODULE = 0
PLAYLIB_FS_FILE = 1
PLAYLIB.FS.Logo = {
[[ _____  _           __     ___      _____ ____  ]],
[[|  __ \| |        /\\ \   / / |    |_   _|  _ \ ]],
[[| |__) | |       /  \\ \_/ /| |      | | | |_) |]],
[[|  ___/| |      / /\ \\   / | |      | | |  _ < ]],
[[| |    | |____ / ____ \| |  | |____ _| |_| |_) |]],
[[|_|    |______/_/    \_\_|  |______|_____|____/ ]]
                                                
}
PLAYLIB.FS.Color = Color(0,0,255,255)
function PLAYLIB.FS:Message(message) MsgC(PLAYLIB.FS.Color,"[PLAYLIB] ",Color(255,255,255,255),message.."\n") end

PLAYLIB.FS.AllowedExtensions = {
    ".lua"
}
PLAYLIB.FS.Prioritize = {}
PLAYLIB.FS.Prioritize[PLAYLIB_FS_FILE] = {
    "cfg",
    "config"
}
PLAYLIB.FS.Prioritize[PLAYLIB_FS_MODULE] = {
    "libraries",
    "chat_commands",
    "logger",
    "play_derma",
    
}

PLAYLIB.FS.Ignore = {}
PLAYLIB.FS.Ignore[PLAYLIB_FS_FILE] = {
    ["playlib/modules/play_derma"] = {
        "frame.lua"
    }
}
PLAYLIB.FS.Ignore[PLAYLIB_FS_MODULE]  = {
    "fileloading",
    "multilang_textscreens",
    "charsystem",
    "debug",
    "hud_v1.0",
    "wip"
}


function PLAYLIB.FS:Index(dir)
    if not dir then return end
    local files,dirs  = file.Find(dir.."/*","LUA")

    local name = string.Split(dir, "/")
    PLAYLIB.FS.Files[dir] = {}

    for key,f in SortedPairs(files) do

        if ( table.HasValue(PLAYLIB.FS.AllowedExtensions,string.sub(f,#f-3))) then
            table.insert(PLAYLIB.FS.Files[dir],f)
        end
        
    end

    if self.Messages["index"] then
        self:Message("[INDEX] - "..table.Count(files).." Files in "..dir)
    end
    
    for key,d in SortedPairs(dirs) do 
        self:Index(dir.."/"..d)
    end
end

function PLAYLIB.FS:SortPriorities(to_sort,sort_example)
    local retval = {}

    local function contains(tbl,str)
        local found = {}
        for _,entry in SortedPairs(tbl) do
            entry = tostring(entry)
            if string.find(entry,str) then
                table.insert(found,entry)
            end
        end

        if table.Count(found) <1 then
            return found
        else
            return found[1]
        end
    end

    for i=1,#sort_example do
        local f = contains(to_sort,sort_example[i])
        if f and !istable(f) then
            table.insert(retval,f)
            table.RemoveByValue(to_sort,f)
        end
            
    end

    for _,val in SortedPairs(to_sort) do
		table.insert(retval,val)
	end

    return retval
end

function PLAYLIB.FS:Sort(typ,mod)

    local p = {}

    local n 

    if typ == PLAYLIB_FS_MODULE then
        n = table.GetKeys(self.Files)
    elseif typ == PLAYLIB_FS_FILE then
        if mod then
             n = table.Copy(self.Files[mod])
        else    
            return
        end
    else
        return
    end

    for _, obj in SortedPairs(n) do
        local ign_flag = false

        if typ == PLAYLIB_FS_MODULE then
            for _,ign in SortedPairs(self.Ignore[typ]) do
                if string.find(obj,ign) then
                    ign_flag = true
                    table.RemoveByValue(n, obj)
                end
            end
        elseif typ == PLAYLIB_FS_FILE then
            if self.Ignore[typ][mod] then 
                for _,ign in SortedPairs(self.Ignore[typ][mod]) do
                    if ign == obj then
                        ign_flag = true
                        table.RemoveByValue(n, obj)
                    end
                end
            end
        end
        

        if ign_flag then
            continue
        end
 
        for _, tok in SortedPairs(self.Prioritize[typ]) do
            if string.find(obj,tok) then
                table.insert(p,obj)
                table.RemoveByValue(n, obj)
                continue
            end
        end
        
    end

    if typ == PLAYLIB_FS_FILE then
        return p,n
    elseif typ == PLAYLIB_FS_MODULE then
        return self:SortPriorities(p,self.Prioritize[typ]),n
    end 
    
end

function PLAYLIB.FS:LoadFile(mod,fl)
    if not PLAYLIB.FS.Files[mod] or not table.HasValue(PLAYLIB.FS.Files[mod],fl) then return end

    if string.find(fl,"cl") or string.find(fl,"client") then
        if SERVER then
            AddCSLuaFile(mod.."/"..fl)
        elseif CLIENT then
            include(mod.."/"..fl)
        end
            
    elseif string.find(fl,"sv") or string.find(fl,"server") then
        if SERVER then
            include(mod.."/"..fl)
        end
    else
        if SERVER then
            AddCSLuaFile(mod.."/"..fl)
            include(mod.."/"..fl)
        elseif CLIENT then
            include(mod.."/"..fl)
        end
    end
end

function PLAYLIB.FS:LoadModule(mod)
    if not mod then return end
    local configs,normals = self:Sort(PLAYLIB_FS_FILE,mod)

    for key, conf in SortedPairs(configs) do
        self:LoadFile(mod,conf)
    end

    for key, norm in SortedPairs(normals) do
        self:LoadFile(mod,norm)
    end
    if self.Messages["load"] then
        self:Message("[LOAD] - "..table.Count(configs)+table.Count(normals).." in "..mod)
    end
    
end

function PLAYLIB.FS:Startup()
    print("\n\n")
    for _,line in SortedPairs(PLAYLIB.FS.Logo) do
        print(line)
    end
    print("\n")
    if self.Messages["index"] then
        PLAYLIB.FS:Message("Indexing...")
        print("\n")
    end
    
    for _,dir in SortedPairs(PLAYLIB.FS.StartDirectories) do
        PLAYLIB.FS:Index(dir)
    end

    if self.Messages["index"] then
        print("\n")
        PLAYLIB.FS:Message("Indexing Done!")
        print("\n")
    end
    
    if self.Messages["load"] then
        PLAYLIB.FS:Message("Loading...")
        print("\n")
    end
    

    local prio, normals = PLAYLIB.FS:Sort(PLAYLIB_FS_MODULE)
    
    for _,m in SortedPairs(prio) do
        PLAYLIB.FS:LoadModule(m)
    end

    for _,m in SortedPairs(normals) do
        PLAYLIB.FS:LoadModule(m)
    end

    if self.Messages["load"] then
        print("\n")
        PLAYLIB.FS:Message("Loading Done!")
    end

    print("\n")
end



