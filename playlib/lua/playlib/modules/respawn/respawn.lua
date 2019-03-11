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
    if ply:HasWeapon("weapon_lightsaber_personal_dual") then
      ply:StripWeapon("weapon_lightsaber_personal_dual")
      timer.Simple(.1,function() ply:Give("weapon_lightsaber_personal_dual") end)
    elseif ply:HasWeapon("weapon_lightsaber_personal") then
      ply:StripWeapon("weapon_lightsaber_personal")
      timer.Simple(.1,function() ply:Give("weapon_lightsaber_personal") end)
    end
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
