if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}
PLAYLIB.charsystem.config = PLAYLIB.charsystem.config or {}
local Config = {}

if SERVER then
  Config.CharacterLimit = 3
  Config.StartingMoney = 100


elseif CLIENT then

  Config.buttons = {
    [1] = {
      name = "Regeln",
      text = "Hier sollten Regeln stehen\nZeilenumbruch\n\n By Juri",
    },
    [2] = {
      name = "Swag",
      text = "Ich habe Swag XD Lol"
    }

  }
end

if SERVER then
  local references = {
    "logger",
  }

  local m_references = ""
  timer.Simple(1,function() //Wait till everythin was loaded to check the References
    for index,mod in pairs(references) do
      if not PLAYLIB:ReferenceCheck(mod) then
        m_references = m_references + " "..mod
      end
    end

    if m_references != "" then
      Msg("[PLAYLIB] Charsystem is missing following References: "..m_references.." !")
      Msg("[PLAYLIB] It is not going to work properly!")
      PLAYLIB.charsystem.Loaded = false
    else
      PLAYLIB.charsystem.Loaded = true
    end

  end)

  if PLAYLIB.charsystem.Loaded then
    PLAYLIB.logger.addLogger("charsystem")

    function PLAYLIB.charsystem:log(msg)
      PLAYLIB.logger.log("charsystem",msg)
    end
  end


end

PLAYLIB.charsystem.config = Config
