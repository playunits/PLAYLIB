if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then
  util.AddNetworkString("PLAYLIB.charsystem::LoadCharacter")
  util.AddNetworkString("PLAYLIB.charsystem::UnloadCharacter")
  util.AddNetworkString("PLAYLIB.charsystem::SyncCharacters")
  util.AddNetworkString("PLAYLIB.charsystem::RequestSync")
  util.AddNetworkString("PLAYLIB.charsystem::OpenCharacterMenu")
  util.AddNetworkString("PLAYLIB.charsystem::EditCharacter")
  util.AddNetworkString("PLAYLIB.charsystem::RemoveCharacter")
  util.AddNetworkString("PLAYLIB.charsystem::CreateCharacter")

  net.Receive("PLAYLIB.charsystem::RemoveCharacter",function(len,ply)
    local id = tonumber(net.ReadString())

    PLAYLIB.charsystem:RemoveCharacter(false,ply,id)

    if ply:GetCurCharID() == id then
      PLAYLIB.charsystem:UnloadCharacter(ply)
    end

    net.Start("PLAYLIB.charsystem::OpenCharacterMenu")
    net.Send(ply)
  end)

  net.Receive("PLAYLIB.charsystem::LoadCharacter",function(len,ply)
    local id = tonumber(net.ReadString())
    PLAYLIB.charsystem:LoadCharacter(ply,id)
  end)

  net.Receive("PLAYLIB.charsystem::UnloadCharacter",function(len,ply)
    PLAYLIB.charsystem:UnloadCharacter(ply)
  end)

  net.Receive("PLAYLIB.charsystem::EditCharacter",function(len,ply)
    local id = tonumber(net.ReadString())
    local data  = net.ReadTable()

    PLAYLIB.charsystem:EditCharacter(false,ply,id,data)

    if ply:GetCurCharID() == id then
      PLAYLIB.charsystem:LoadCharacter(ply,id)
    end

    net.Start("PLAYLIB.charsystem::OpenCharacterMenu")
    net.Send(ply)
  end)

  net.Receive("PLAYLIB.charsystem::RequestSync",function(len,ply)
    net.Start("PLAYLIB.charsystem::SyncCharacters")
      net.WriteTable(PLAYLIB.charsystem:GetPlayerCharacters(ply) or {})
    net.Send(ply)
  end)

  function PLAYLIB.charsystem:Sync(ply)
    net.Start("PLAYLIB.charsystem::SyncCharacters")
      net.WriteTable(PLAYLIB.charsystem:GetPlayerCharacters(ply) or {})
    net.Send(ply)
  end

elseif CLIENT then

  net.Receive("PLAYLIB.charsystem::SyncCharacters",function(len)
      LocalPlayer().Characters = net.ReadTable()
  end)

  net.Receive("PLAYLIB.charsystem::OpenCharacterMenu",function(len)
    PLAYLIB.charsystem:OpenMenu()
  end)

  function PLAYLIB.charsystem:RequestSync()
    net.Start("PLAYLIB.charsystem::RequestSync")
    net.SendToServer()
  end

end
