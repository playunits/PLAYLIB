if !PLAYLIB then return end
if !PLAYLIB.charsystem then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}
PLAYLIB.charsystem.whitelist = PLAYLIB.charsystem.whitelist or {}

if SERVER then

  function PLAYLIB.charsystem.whitelist.InitializeDatabase()
			local queryString = [[CREATE TABLE IF NOT EXISTS playlib_whitelist (
				sid varchar(20) NOT NULL PRIMARY KEY AUTOINCREMENT,
				whitelist TEXT
				);
			]]
			PLAYLIB.sql.query(false,queryString,function(res)
				PLAYLIB.logger.log("whitelist","Database Created or already existed!")
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Database Created or already existed!\n")
			end,function(error)
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Beim erstellen des SQLite Tables ist ein Error aufgetreten!\n")
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Error: "..error.."\n")
				PLAYLIB.logger.log("whitelist","Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
				PLAYLIB.logger.log("whitelist","Error: "..error)
			end)
	end

  function PLAYLIB.charsystem.whitelist.registerInDB(ply,team)
      local t = {}
      table.insert(t,team)
      local tstring = util.TableToJSON(t)
      local queryString = "INSERT INTO playlib_whitelist (sid,team) VALUES ('"..PLAYLIB.sql.sqlStr(ply:SteamID64())"','"..tstring.."')"
      PLAYLIB.sql.query(false,queryString,function(res)
        PLAYLIB.logger.log("whitelist","Database Created or already existed!")
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [WHITELIST] Database Created or already existed!\n")
      end,function(error)
        MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [WHITELIST] Beim erstellen des SQLite Tables ist ein Error aufgetreten!\n")
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [WHITELIST] Error: "..error.."\n")
				PLAYLIB.logger.log("whitelist","Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
				PLAYLIB.logger.log("whitelist","Error: "..error)
      end)
  end

  function PLAYLIB.charsystem.whitelist.isRegistered(ply)
    local queryString = "SELECT COUNT(sid) FROM playlib_whitelist WHERE sid='"..PLAYLIB.sql.sqlStr(ply:SteamID64()).."'"
    local retval = -1
    PLAYLIB.sql.query(false,queryString,function(res)
      retval = tonumber(res[1]["COUNT(id)"])
    end,function(error)

    end)
    if retval > 0 then
      return true
    elseif
      return false
    end
  end

  function PLAYLIB.charsystem.whitelist.addToWhitelist(ply,team)
    local old = PLAYLIB.charsystem.whitelist.getAllWhitelist(ply)
    local new = old
    table.insert(new,team)
    PLAYLIB.charsystem.whitelist.writeAllWhitelist(ply,new)
  end

  function PLAYLIB.charsystem.whitelist.removeFromWhitelist(ply,team)
    local old = PLAYLIB.charsystem.whitelist.getAllWhitelist(ply)
    local new = {}

    for index,t in pairs(old) do
      if t != team then
        table.insert(new,t)
      end
    end

  end

  function PLAYLIB.charsystem.whitelist.isInWhitelist(ply,team)
    local w = PLAYLIB.charsystem.whitelist.getAllWhitelist(ply)

    return table.HasValue(w,team)
  end

  function PLAYLIB.charsystem.whitelist.writeAllWhitelist(ply,tbl)
    local tstring = util.TableToJSON(tbl)

    local queryString = "UPDATE playlib_whitelist SET whitelist='"..tstring.."' WHERE sid='"..PLAYLIB.sql.sqlStr(ply:SteamID64()).."'"
    PLAYLIB.sql.query(false,queryString,function(res)

    end,function(error)

    end)
  end

  function PLAYLIB.charsystem.whitelist.getAllWhitelist(ply)
    local tstring = ""
    local queryString = "SELECT * FROM playlib_whitelist WHERE sid='"..PLAYLIB.sql.sqlStr(ply:SteamID64()).."'"
    PLAYLIB.sql.query(false,queryString,function(res)
      tstring = res[1]
    end,function(error)

    end)

    return util.JSONToTable(tstring)
  end

  hook.Add("Initialize", "PLAYLIB.Charsystem::InitializeDatabase", function()
		PLAYLIB.logger.addLogger("whitelist")

    PLAYLIB.charsystem.whitelist.InitializeDatabase()

  end



elseif CLIENT then

end
