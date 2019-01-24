if !PLAYLIB then return end

PLAYLIB.wos_force_extension = PLAYLIB.wos_force_extension or {}

if SERVER then
  util.AddNetworkString("PLAYLIB.wos_force_extension.blind::Handler")
elseif CLIENT then
  local blindTime = 3

  net.Receive("PLAYLIB.wos_force_extension.blind::Handler",function()
    local endTime = CurTime() + blindTime

    hook.Add("HUDPaint","PLAYLIB.wos_force_extension.blind::Handler",function()
      if CurTime() > endTime then hook.Remove("HUDPaint","PLAYLIB.wos_force_extension.blind::Handler") return end
      draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0,0,0,255))
    end)
  end)
end
