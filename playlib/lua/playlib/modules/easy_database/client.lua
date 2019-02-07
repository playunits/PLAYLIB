if !PLAYLIB then return end

PLAYLIB.easy_database = PLAYLIB.easy_database or {}

if SERVER then

elseif CLIENT then
  if !file.Exists("easy_database_presets.txt","DATA") then
    file.Write("easy_database_presets.txt","")
  end


  function PLAYLIB.easy_database:AddPreset(str)
    local old = PLAYLIB.easy_database:GetPresets()
    if not old then old = {} end
    table.insert(old,str)
    file.Write("easy_database_presets.txt",util.TableToJSON(old))
    self:RefreshPresets()
  end

  function PLAYLIB.easy_database:RemovePreset(str)
    local old = PLAYLIB.easy_database:GetPresets()
    if not old then return end
    table.RemoveByValue(old,str)
    file.Write("easy_database_presets.txt",util.TableToJSON(old))
    self:RefreshPresets()
  end


  function PLAYLIB.easy_database:GetPresets()
    return util.JSONToTable(file.Read("easy_database_presets.txt"))
  end

  function PLAYLIB.easy_database:RefreshPresets()
    PLAYLIB.easy_database.presets:Clear()
    PLAYLIB.easy_database.presets:SetValue(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["SelectPreset"])
    if PLAYLIB.easy_database:GetPresets() == nil or PLAYLIB.easy_database:GetPresets() == {} or not PLAYLIB.easy_database:GetPresets()[1] then
      PLAYLIB.easy_database.presets:AddChoice(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["NoPresets"])
    else
      for index,v in pairs(PLAYLIB.easy_database:GetPresets()) do
        PLAYLIB.easy_database.presets:AddChoice(v)
      end
    end
  end

  PLAYLIB.easy_database.query_list = nil
  PLAYLIB.easy_database.main = nil
  PLAYLIB.easy_database.presets = nil
  PLAYLIB.easy_database.lastpos = {}



  net.Receive("PLAYLIB.easy_database:SendData",function()

    local title = net.ReadString()
    PLAYLIB.easy_database:OpenUI(title)
    local keys = net.ReadTable()
    local data = net.ReadTable()

    for i,v in pairs(keys) do
      PLAYLIB.easy_database.query_list:AddColumn(v)
    end

    for i,t in pairs(data) do
      t = table.ClearKeys(t)
      local t_l = PLAYLIB.easy_database.query_list:AddLine()
      for index,v in pairs(t) do
        t_l:SetColumnText(index,t[index])
      end
    end

  end)

  function PLAYLIB.easy_database:OpenUI(title)
    if IsValid(PLAYLIB.easy_database.main) then PLAYLIB.easy_database.main:Remove() end
    local main = vgui.Create("DFrame")
    main:SetSize(500,700)
    main:SetTitle(title or PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["StandardTitle"])
    if PLAYLIB.easy_database.lastpos["x"] and PLAYLIB.easy_database.lastpos["y"] then
      main:SetPos(PLAYLIB.easy_database.lastpos["x"],PLAYLIB.easy_database.lastpos["y"])
    else
      main:Center()
    end

    main:MakePopup()
    main.Paint = function(self,w,h)
      draw.RoundedBox(8,0,0,w,h,PLAYLIB.play_derma.MainBaseWindowColor)
      PLAYLIB.vgui.drawHalfCircle(self,0,0,w,30,PLAYLIB.play_derma.MainHighlightWindowColor,8)
    end
    main.OnClose = function(self)
      PLAYLIB.easy_database.lastpos["x"],PLAYLIB.easy_database.lastpos["y"] = self:GetPos()
    end

    PLAYLIB.easy_database.main = main
    PLAYLIB.easy_database.lastpos["x"],PLAYLIB.easy_database.lastpos["y"] = main:GetPos()

    local table_name = vgui.Create("DTextEntry",main)
    table_name:SetPos(10,50)
    table_name:SetSize(200,20)

    local submit_button = vgui.Create("DButton",main)
    submit_button:SetPos(220,50)
    submit_button:SetSize(50,20)
    submit_button:SetText(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["GetData"])
    submit_button.DoClick = function()
      PLAYLIB.easy_database.lastpos["x"],PLAYLIB.easy_database.lastpos["y"] = main:GetPos()
      net.Start("PLAYLIB.easy_database:RequestData")
        net.WriteString(tostring(table_name:GetValue()))
      net.SendToServer()

    end

    local presets = vgui.Create("DComboBox",main)
    presets:SetPos(300,50)
    presets:SetSize(150,20)
    presets:SetValue(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["SelectPreset"])

    PLAYLIB.easy_database.presets = presets

    if PLAYLIB.easy_database:GetPresets() == nil or PLAYLIB.easy_database:GetPresets() == {} then
      presets:AddChoice(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["NoPresets"])
    else
      for index,v in pairs(PLAYLIB.easy_database:GetPresets()) do
        presets:AddChoice(v)
      end
    end

    presets.OnSelect = function(self,index,value)
      if value == PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["SelectPreset"] then return end
      PLAYLIB.easy_database.lastpos["x"],PLAYLIB.easy_database.lastpos["y"] = main:GetPos()
      net.Start("PLAYLIB.easy_database:RequestData")
        net.WriteString(tostring(value))
      net.SendToServer()
    end

    local preset_remove = vgui.Create("DButton",main)
    preset_remove:SetSize(16,16)
    preset_remove:SetPos(455,52)
    preset_remove:SetText("")
    preset_remove.DoClick = function()
      PLAYLIB.vgui.valueDerma(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupRemovalTitle"],PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupPlaceholder"],
      PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupSubmit"],function(btn,val) PLAYLIB.easy_database:RemovePreset(val)  end,
      PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupAbort"],function() end,false)
    end
    preset_remove.Paint = function(self,w,h)
      surface.SetMaterial(Material("icon16/delete.png"))
	     surface.DrawTexturedRect(0,0,w,h)
    end

    local preset_create = vgui.Create("DButton",main)
    preset_create:SetSize(16,16)
    preset_create:SetPos(475,52)
    preset_create:SetText("")
    preset_create.DoClick = function()
      PLAYLIB.vgui.valueDerma(PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupCreationTitle"],PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupPlaceholder"],
      PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupSubmit"],function(btn,val) PLAYLIB.easy_database:AddPreset(val)  end,
      PLAYLIB.easy_database.language[PLAYLIB.easy_database.LangUsed]["PopupAbort"],function() end,false)
    end
    preset_create.Paint = function(self,w,h)
      --surface.SetTexture(surface.GetTextureID("icon16/add.png"))
      surface.SetMaterial(Material("icon16/add.png"))
	     surface.DrawTexturedRect(0,0,w,h)
    end


    local query_list = vgui.Create("DListView",main)
    query_list:SetSize(480,550)
    query_list:SetPos(10,100)

    PLAYLIB.easy_database.query_list = query_list



  end

end
