if !PLAYLIB then return end

PLAYLIB.jr_outfitter = PLAYLIB.jr_outfitter or {}

if SERVER then
  util.AddNetworkString("PLAYLIB.jr_outfitter:OpenMenu")
  util.AddNetworkString("PLAYLIB.jr_outfitter:StandardModelChange")

  net.Receive("PLAYLIB.jr_outfitter:OpenMenu",function(len,ply)
    local data = net.ReadTable()

    ply:SetModel(data.Model)

    if data.Bodygroups then
      for k,v in pairs(data.Bodygroups) do
        ply:SetBodygroup(v[1],v[2])
      end
    end

    if data.Skin then
      ply:SetSkin(data.Skin)
    end

    ply:SetupHands()

  end)

  net.Receive("PLAYLIB.jr_outfitter:StandardModelChange",function(len,ply)
    local data = net.ReadTable()

    ply:SetSkin(data["skin"])

    for index,bg in pairs(data["bodygroups"]) do
      ply:SetBodygroup(index,bg)
    end

    ply:SetupHands()
  end)
elseif CLIENT then

end
