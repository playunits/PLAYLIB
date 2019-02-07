if !PLAYLIB then return end

PLAYLIB.easy_database = PLAYLIB.easy_database or {}

if SERVER then

  function PLAYLIB.easy_database:SelectAllFromTable(tbl)
    if not tbl or type(tbl) != "string" then return end
    local query = "SELECT * FROM "..tbl..";"
    local retval = {}
    PLAYLIB.sql.query(false,query, function(res)
      retval = res
    end,
    function(err)
      MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [EASY DATABASE] Fehler beim Abfragen der Table Daten für "..tbl.."!\n")
      MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [EASY DATABASE] Error: "..err.."\n")
      retval = err
    end)

    return retval

  end



elseif CLIENT then

end
