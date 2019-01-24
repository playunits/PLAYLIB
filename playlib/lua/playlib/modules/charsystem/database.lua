if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then
  timer.Simple(1,function()
    PLAYLIB.logger.addLogger("charsystem")
  end)


  function PLAYLIB.charsystem:log(str)
    PLAYLIB.logger.log("charsystem",str)
  end

  function PLAYLIB.charsystem:InitializeDatabase()
    local query = [[CREATE TABLE IF NOT EXISTS playlib_charsystem (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    name STRING NOT NULL,
    money INTEGER NOT NULL,
    steamid64 varchar(17) NOT NULL,
    team INTEGER NOT NULL,
    creation_date varchar(19) NOT NULL,
    last_played varchar(19)
    );
    ]]

    PLAYLIB.sql.query(false,query,function(res)
      PLAYLIB.logger.log("charsystem","Erstellen der Datenbank erfolgreich! / Datenbank existierte bereits!")
    end,function(error)
      PLAYLIB.logger.log("charsystem","Fehler beim erstellen der Datenbank!")
      PLAYLIB.logger.log("charsystem","Fehler"..error)
    end)
  end

  function PLAYLIB.charsystem:CreateEntry(name,money,steamid64,team)

    local date = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
    local query = "INSERT INTO playlib_charsystem (name,money,steamid64,team,creation_date) VALUES ('"..name.."',"..money..",'"..steamid64.."',"..team..",'"..date.."')"

    PLAYLIB.sql.query(false,query,function(res)
      self:log("Neuer Charakter wurde erstellt!")
    end,function(error)
      self:log("Fehler beim erstellen des Charakters!")
      self:log("Fehler: "..error)
    end)
  end

  function PLAYLIB.charsystem:AlterEntry(id,name,money,team,last_played)

    local query = "UPDATE playlib_charsystem SET name='"..name.."', money="..money..", team="..team..", last_played='"..last_played.."' WHERE id="..id..";"

    PLAYLIB.sql.query(false,query,function(res)
      self:log("Charakter wurde bearbeitet!")
    end,function(error)
      self:log("Fehler beim bearbeiten des Charakters!")
      self:log("Fehler: "..error)
    end)
  end

  function PLAYLIB.charsystem:RemoveEntry(id)

    local query = "DELETE FROM playlib_charsystem WHERE id="..id..";"

    PLAYLIB.sql.query(false,query,function(res)
      self:log("Charakter wurde gelöscht!")
    end,function(error)
      self:log("Fehler beim löschen des Charakters!")
      self:log("Fehler:"..error)
    end)
  end

  function PLAYLIB.charsystem:GetMatchingSID64Entries(steamid64)

    local retval = {}
    local query = "SELECT * FROM playlib_charsystem WHERE steamid64='"..steamid64.."';"

    PLAYLIB.sql.query(false,query,function(res)
      retval = res
    end,function(error)
      retval = false
      self:log("Fehler bei der GET Anfrage über die Steamid64!")
      self:log("Fehler: "..error)
    end)

    return retval
  end

  function PLAYLIB.charsystem:GetMatchingIDEntries(id)
    local retval = {}
    local query = "SELECT * FROM playlib_charsystem WHERE id="..id..";"
    PLAYLIB.sql.query(false,query,function(res)
      retval = res[1]
    end,function(error)
      retval = false
      self:log("Fehler bei der GET Anfrage über die ID!")
      self:log("Fehler: "..error)
    end)
    return retval
  end

  function PLAYLIB.charsystem:GetMatchingNameEntries(name)
    local retval = {}
    local query = "SELECT * FROM playlib_charsystem WHERE name='"..name.."';"

    PLAYLIB.sql.query(false,query,function(res)
      retval = res[1]
    end,function(error)
      retval = false
      self:log("Fehler bei der GET Anfrage über den Namen!")
      self:log("Fehler: "..error)
    end)
    return retval
  end

elseif CLIENT then

end
