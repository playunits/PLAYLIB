if !PLAYLIB then return end

PLAYLIB.jr_outfitter = PLAYLIB.jr_outfitter or {}

if SERVER then

elseif CLIENT then

  net.Receive("PLAYLIB.jr_outfitter:OpenMenu",function(len,ply)
    local Models = net.ReadTable()

    if not Models or Models == {} then

    end
    PLAYLIB.jr_outfitter:OpenMenu(Models)
  end)

  net.Receive("PLAYLIB.jr_outfitter:StandardModelChange",function(len)
    PLAYLIB.jr_outfitter:OpenNormalMenu()
  end)

    function PLAYLIB.jr_outfitter:OpenNormalMenu()
      local skins = {}
      local bodygroups = {}
      local job = LocalPlayer():getJobTable()

      if job.skins then
        skins = job.skins
      else
        local n_skin = LocalPlayer():SkinCount()
        for i = 0, n_skin do
          table.insert(skins,i)
        end
        PrintTable(skins)
      end

      if job.bodygroups then
        bodygroups = job.bodygroups
      else
        bodygroups = LocalPlayer():GetBodyGroups()
      end




      local main = vgui.Create("DFrame")
      main:SetSize(600,500)
      main:Center()
      main:SetDraggable(false)
      main:SetTitle("JobRanks Playermodel Selector")
      main:MakePopup()


      local creator = vgui.Create("DImageButton",main)
  		creator:SetPos(main:GetWide()-120,2.5)
  		creator:SetSize(20,20)
  		creator:SetImage("icon16/information.png")
  		creator:SetToolTip("Go to the Creators Profile")
  		creator.DoClick = function()
  			gui.OpenURL("https://steamcommunity.com/id/playunits/")
  		end




      local model = vgui.Create("DModelPanel",main)
      model:SetSize(300,350)
      model:SetPos(250,50)
      model:SetModel(LocalPlayer():GetModel())

      model.Entity:SetEyeTarget( Vector( 0, 0, 0 ) )

    	model:SetFOV( 75 )

    	model:SetCamPos( Vector( 45, 20, 64 ) )

      local button = vgui.Create("DButton",main)
      button:SetSize(200,20)
      button:SetPos(300,450)
      button:SetText("Angezeigtes Model übernehmen")
      button.DoClick = function(self)
        local s_tbl = {
          ["bodygroups"] = {},
          ["skin"] = {},
        }

        for index,bg in pairs(model.Entity:GetBodyGroups()) do
          s_tbl["bodygroups"][index] = model.Entity:GetBodygroup(index)
        end

        s_tbl["skin"] = model.Entity:GetSkin()

        net.Start("PLAYLIB.jr_outfitter:StandardModelChange")
          net.WriteTable(s_tbl)
        net.SendToServer()
        main:Remove()
      end

      local tree = vgui.Create("DTree",main)
      tree:SetPos(10,50)
      tree:SetSize(200,400)

      local t_bg = tree:AddNode("Bodygroups")
      t_bg:SetExpanded(true)

        PrintTable(bodygroups)
      for index,bg in pairs(bodygroups) do
        local ts_bg = t_bg:AddNode(bg.name)
        ts_bg:SetExpanded(true)
        ts_bg.Table = bg
        ts_bg.Index = index


        for index2,bg_num in pairs(bodygroups[index].submodels) do
          local tss_bg = ts_bg:AddNode(index2)
          --tss_bg:SetIcon("icon16/cancel.png")
          tss_bg.DoClick = function(self)
            model.Entity:SetBodygroup(ts_bg.Index,index2)
          end

        end

      end

      if LocalPlayer():SkinCount() > 1 then
        local t_s = tree:AddNode("Skins")
        t_s:SetExpanded(true)

        for index,skin in pairs(skins) do
          local ts_s = t_s:AddNode(index)

          ts_s.DoClick = function(self)
            model.Entity:SetSkin(index)
          end

      end




    end // Line5
  end

  function PLAYLIB.jr_outfitter:OpenMenu(ModelTable)

    PrintTable(ModelTable)
    local main = vgui.Create("DFrame")
    main:SetSize(600,500)
    main:Center()
    main:SetDraggable(false)
    main:SetTitle("JobRanks Playermodel Selector")
    main:MakePopup()


    local creator = vgui.Create("DImageButton",main)
		creator:SetPos(main:GetWide()-120,2.5)
		creator:SetSize(20,20)
		creator:SetImage("icon16/information.png")
		creator:SetToolTip("Go to the Creators Profile")
		creator.DoClick = function()
			gui.OpenURL("https://steamcommunity.com/id/playunits/")
		end


    local m_list = vgui.Create("DScrollPanel",main)
    m_list:SetSize(200,400)
    m_list:SetPos(10,50)

    local b_p1 = vgui.Create("DPanel",main)
    b_p1:SetSize(300,350)
    b_p1:SetPos(250,50)
    b_p1:SetBGColor(Color(105,105,105,255))

    local model = vgui.Create("DModelPanel",main)
    model:SetSize(300,350)
    model:SetPos(250,50)
    model:SetModel(ModelTable[1].Model or "models/error.mdl")
    print(model:GetModel())

    model.Entity:SetEyeTarget( Vector( 0, 0, 0 ) )

  	model:SetFOV( 75 )

  	model:SetCamPos( Vector( 45, 20, 64 ) )

    for index,m in pairs(ModelTable) do

      local b = m_list:Add("DButton")
      b:SetText(m.Model)
      b:SetSize(200,20)
      b:Dock(TOP)
      b:DockMargin(0, 0, 0, 5)
      b.DoClick = function(self)
        model:SetModel(m.Model)
      end

    end

    local button = vgui.Create("DButton",main)
    button:SetSize(200,20)
    button:SetPos(300,450)
    button:SetText("Angezeigtes Model übernehmen")
    button.DoClick = function(self)
      for index,m in pairs(ModelTable) do
        if m.Model == model:GetModel() then
          net.Start("PLAYLIB.jr_outfitter:OpenMenu")
            net.WriteTable(m)
          net.SendToServer()
          main:Remove()
        end
      end
    end

  end

end
