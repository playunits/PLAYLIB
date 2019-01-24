if !PLAYLIB then return end

PLAYLIB.respawn = PLAYLIB.respawn or {}

if SERVER then

  hook.Add("PlayerSay","PLAYLIB.respawn::ExecuteCommand",function(ply,text,team)
    if text == "!respawn" then
      PLAYLIB.respawn:RespawnPlayer(ply,ply:GetPos(),ply:EyeAngles(),ply:Health(),ply:Armor())
      return ""
    end
  end)

  function PLAYLIB.respawn:RespawnPlayer(ply,pos,ang,hp,armor)

    ply:Spawn()
    ply:SetPos(pos)
    ply:SetEyeAngles(ang)
    timer.Simple(.1,function()
      ply:SetHealth(hp)
      ply:SetArmor(armor)
    end)
    PLAYLIB.misc.notify(ply,"You have been respawned",0,3)

  end

elseif CLIENT then

end
