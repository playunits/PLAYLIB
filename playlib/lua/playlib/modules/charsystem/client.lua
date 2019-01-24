if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then

elseif CLIENT then
  LocalPlayer().Characters = {}

  PLAYLIB.charsystem.menu = nil
  function PLAYLIB.charsystem:OpenMenu()


    PLAYLIB.charsystem:RequestSync()

    if IsValid(PLAYLIB.charsystem.menu) then PLAYLIB.charsystem.menu:Remove() end

    local spacing = math.floor(ScrW()/3)

    local bg = vgui.Create("DPanel")
    bg:SetSize(ScrW(),ScrH())
    bg:SetPos(0,0)
    bg.Paint = function(self,w,h)
      draw.RoundedBox(0,0,0,w,h,Color(0,0,0,255))



      surface.SetDrawColor(Color(255,255,255,255))
      surface.DrawLine(spacing*1,0,spacing*1,h)
      surface.DrawLine(spacing*2,0,spacing*2,h)
    end
    PLAYLIB.charsystem.menu = bg
    local leftpanel = vgui.Create("DPanel",bg)
    leftpanel:SetSize((ScrW()/3)-1,ScrH())
    leftpanel:SetPos(spacing*0,0)
    leftpanel.Paint = function(self,w,h)
      draw.RoundedBox(0,0,0,w,h,Color(255,0,0,0))
    end

    local middlepanel = vgui.Create("DPanel",bg)
    middlepanel:SetSize(spacing-1,ScrH())
    middlepanel:SetPos((spacing*1)+1,0)
    middlepanel.Paint = function(self,w,h)
      draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
    end

    local rightpanel = vgui.Create("DPanel",bg)
    rightpanel:SetSize(spacing-1,ScrH())
    rightpanel:SetPos((spacing*2)+1,0)
    rightpanel.Paint = function(self,w,h)
      draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
    end

    local main = vgui.Create("DFrame",bg)
    main:SetSize(400,500)
    main:Center()
    main:SetDraggable(true)
    main:MakePopup()
    main.OnClose = function()
      bg:Remove()
    end


    local model_display = vgui.Create("DModelPanel",middlepanel)
    model_display:SetSize(640,1000)
    model_display:SetPos(0,70)
    model_display:SetCamPos( Vector( 32,0, 40 ) )
    model_display.LayoutEntity = function(ent)
      return
    end
    model_display:SetLookAng(Angle(5,180,0))
    model_display:SetModel(RPExtraTeams[tonumber(LocalPlayer().Characters[1].team)].model[1])
    model_display:SetAmbientLight(Color(255, 255, 255, 255))
    model_display:SetCamPos(model_display:GetLookAt() + Vector(50, 0, 0))
    model_display.Entity:SetEyeTarget(model_display:GetCamPos())
    model_display.Angles = Angle( 0, 0, 0 )



    function model_display:DragMousePress()
        self.PressX, self.PressY = gui.MousePos()
        self.Pressed = true
    end

    function model_display:DragMouseRelease() self.Pressed = false end

    function model_display:LayoutEntity( Entity )
        if ( self.bAnimated ) then self:RunAnimation() end

        if ( self.Pressed ) then
            local mx, my = gui.MousePos()
            self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 ) //76561198137249403

            self.PressX, self.PressY = gui.MousePos()
        end

        Entity:SetAngles( self.Angles )
    end

    local name_label = vgui.Create("DLabel",middlepanel)
    name_label:SetSize(640,50)
    name_label:SetPos(0,0)
    name_label:SetText("")
    name_label.Text = LocalPlayer().Characters[1].name
    name_label.Paint = function(self,w,h)
      draw.DrawText(name_label.Text,"BFHUD.Size50",spacing/2,0,Color(255,0,0,255),TEXT_ALIGN_CENTER)
    end



    /*
    local char_list = vgui.Create("DListView",leftpanel)
    char_list:Dock(FILL)
    char_list:AddColumn( "ID" )
    char_list:AddColumn( "Name" )
    char_list:AddColumn( "Team" )
    char_list:AddColumn( "Money" )

    if not LocalPlayer().Characters or LocalPlayer().Characters == {} then

    else
      for index,char in pairs(LocalPlayer().Characters) do
        char_list:AddLine(char.id,char.name,RPExtraTeams[tonumber(char.team)].name,char.money)
      end
    end

    for i,line in pairs(char_list.Lines) do
      line.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,255))
      end
    end
    */
    local list_label = vgui.Create("DLabel",leftpanel)
    list_label:SetSize(640,50)
    list_label:SetPos(0,0)
    list_label:SetText("")
    list_label.Paint = function(self,w,h)
      draw.DrawText("Deine Charaktere: ","BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
    end


    local scroll = vgui.Create("DScrollPanel",leftpanel)
    scroll:SetSize((ScrW()/3)-1,ScrH()-50)
    scroll:SetPos(0,50)
    scroll:CenterHorizontal(0.5)
    scroll.Paint = function(self,w,h)
      draw.OutlinedRect(0,0,w,h, Color( 0,0,0,150 ), 1,  Color(255,255,255,256))
    end
    scroll.Selected = 1



    local function createScrollBar()
      local sbar = scroll:GetVBar()
      function sbar:Paint( w, h )
          draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 100 ) )
      end
      function sbar.btnUp:Paint( w, h )
          draw.OutlinedRect(0, 0, w, h, Color(100,100,100,20), 1,  Color(255,0,0,256))
          draw.DrawText("^", "BFHUD.Size20", w/2, 0 ,Color( 0,0,0,256 ), TEXT_ALIGN_CENTER)
      end
      function sbar.btnDown:Paint( w, h )
          draw.OutlinedRect(0, 0, w, h, Color(100,100,100,20), 1,  Color(255,0,0,256))
          draw.DrawText("v", "BFHUD.Size20", w/2, -4 ,Color( 0,0,0,256 ), TEXT_ALIGN_CENTER)
      end
      function sbar.btnGrip:Paint( w, h )
          draw.OutlinedRect(0, 0, w, h, Color(100,100,100,20), 1,  Color(255,0,0,256))
      end
      sbar.btnGrip:SetCursor( "hand" )
  end
  createScrollBar()



  local function AddEntry(id)
    local char_line = scroll:Add("DButton")

    char_line:SetSize((ScrW()/3)-23,50)
    if id == 1 then
      char_line:SetPos(3,10)
    else
      char_line:SetPos(3,51*(id-1)+10)
    end

    char_line:SetText("")
    char_line.Paint = function(self,w,h)
      draw.RoundedBox( 0, 0, 0, w, h, self:IsHovered() and Color(100,50,50,230) or Color(200,100,100,230))
      draw.text3D(LocalPlayer().Characters[id].name, "BFHUD.Size20", 5, 2, Color(230,230,230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
      draw.text3D(RPExtraTeams[tonumber(LocalPlayer().Characters[id].team)].name or "None", "BFHUD.Size20", 5, 22, Color(230,230,230), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
      draw.text3D("ID: "..LocalPlayer().Characters[id].id, "BFHUD.Size20", 600, 2, Color(230,230,230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
      draw.text3D("$"..LocalPlayer().Characters[id].money, "BFHUD.Size20", 600, 22, Color(230,230,230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
      if LocalPlayer().Characters[id].last_played == "NULL" then
        draw.text3D("Last Played: None", "BFHUD.Size20", 400, 2, Color(230,230,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
      else
        draw.text3D("Last Played: "..LocalPlayer().Characters[id].last_played, "BFHUD.Size20", 400, 2, Color(230,230,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
      end
    end

    char_line.DoClick = function()
      if scroll.Selected == id then return end
      model_display.ModelTable = RPExtraTeams[tonumber(LocalPlayer().Characters[id].team)].model
      model_display:SetModel(model_display.ModelTable[1])
      name_label.Text = LocalPlayer().Characters[id].name
      name_label:Paint(name_label:GetSize())
      scroll.Selected = id
      --reloadDataLabels()
    end
  end

  for index,chars in pairs(LocalPlayer().Characters) do
    AddEntry(index)
  end


  local b_scroll = vgui.Create("DScrollPanel",rightpanel)
  b_scroll:SetSize(200,400)
  b_scroll:SetPos(0,50)
  b_scroll:CenterHorizontal(0.5)
  b_scroll.Paint = function(self,w,h)
    draw.OutlinedRect(0,0,w,h, Color( 0,0,0,150 ), 1,  Color(255,255,255,256))
  end
  b_scroll.Selected = 1



  local function createScrollBar()
    local sbar = b_scroll:GetVBar()
    function sbar:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0, 100 ) )
    end
    function sbar.btnUp:Paint( w, h )
        draw.OutlinedRect(0, 0, w, h, Color(100,100,100,20), 1,  Color(255,0,0,256))
        draw.DrawText("^", "BFHUD.Size20", w/2, 0 ,Color( 0,0,0,256 ), TEXT_ALIGN_CENTER)
    end
    function sbar.btnDown:Paint( w, h )
        draw.OutlinedRect(0, 0, w, h, Color(100,100,100,20), 1,  Color(255,0,0,256))
        draw.DrawText("v", "BFHUD.Size20", w/2, -4 ,Color( 0,0,0,256 ), TEXT_ALIGN_CENTER)
    end
    function sbar.btnGrip:Paint( w, h )
        draw.OutlinedRect(0, 0, w, h, Color(100,100,100,20), 1,  Color(255,0,0,256))
    end
    sbar.btnGrip:SetCursor( "hand" )
end
createScrollBar()

local function AddButton(id)
  local config_button = b_scroll:Add("DButton")

  config_button:SetSize(b_scroll:GetWide()-20,50)
  if id == 1 then
    config_button:SetPos(5,10)
  else
    config_button:SetPos(5,51*(id-1)+10)
  end

  config_button:SetText("")
  config_button.Paint = function(self,w,h)
    draw.RoundedBox( 0, 0, 0, w, h, self:IsHovered() and Color(100,50,50,230) or Color(200,100,100,230))
    draw.text3D(PLAYLIB.charsystem.config.buttons[id].name, "BFHUD.Size20", 0, 0, Color(230,230,230))
  end

  config_button.DoClick = function()
    PLAYLIB.charsystem:CreateInfoPanel(rightpanel,PLAYLIB.charsystem.config.buttons[id].text)
  end
end

for index,chars in pairs(PLAYLIB.charsystem.config.buttons) do
  AddButton(index)
end
  /*
  local model_select_label = vgui.Create("DLabel",rightpanel)
  model_select_label:SetSize(640,50)
  model_select_label:SetPos(0,0)
  model_select_label:SetText("")
  model_select_label.Paint = function(self,w,h)
    draw.DrawText("Select Your Model: ","BFHUD.Size20",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end


  local model_selection = vgui.Create("DComboBox",rightpanel)
  model_selection:SetPos(5,20)
  model_selection:SetSize(400,20)
  model_selection:SetValue(model_display:GetModel())

  for index,mdl in pairs(RPExtraTeams[tonumber(LocalPlayer().Characters[1].team)].model) do
    model_selection:AddChoice(mdl)
  end

  model_selection.OnSelect = function(self,index,value)
    model_display:SetModel(value)
  end
  */

  function draw.OutlinedBox( x, y, w, h, thickness, clr )
      surface.SetDrawColor( clr )
      for i=0, thickness - 1 do
          surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
      end
  end

  function draw.OutlinedRect(x, y, w, h, InnerColor, OutlineThickness, OutlineColor)
      draw.RoundedBox( 0, x, y, w, h, InnerColor)
      draw.OutlinedBox( x, y, w, h, OutlineThickness, OutlineColor )
  end

  local load_character = vgui.Create("DButton",rightpanel)
  load_character:SetSize(200,50)
  load_character:SetPos(20,900)
  load_character:SetText("")
  load_character.DoClick = function()
    if not scroll.Selected then return end
    local id = LocalPlayer().Characters[scroll.Selected].id
    net.Start("PLAYLIB.charsystem::LoadCharacter")
      net.WriteString(tostring(id))
    net.SendToServer()
    bg:Remove()
  end
  load_character.Paint = function(self,w,h)
    draw.OutlinedRect(0, 0, w, h, self:IsHovered() and Color(100,50,50,230) or Color(200,100,100,230), 1, Color(255,255,255,255))
    draw.DrawText("Charakter Laden","BFHUD.Size20",self:GetWide()/2,self:GetTall()/4,Color(255,255,255,255),TEXT_ALIGN_CENTER)
  end

  local remove_character = vgui.Create("DButton",rightpanel)
  remove_character:SetSize(200,50)
  remove_character:SetPos(240,900)
  remove_character:SetText("")
  remove_character.DoClick = function()
    if not scroll.Selected then return end
    local id = LocalPlayer().Characters[scroll.Selected].id
    net.Start("PLAYLIB.charsystem::RemoveCharacter")
      net.WriteString(tostring(id))
    net.SendToServer()
    bg:Remove()
    PLAYLIB.charsystem:OpenMenu()
  end
  remove_character.Paint = function(self,w,h)
    draw.OutlinedRect(0, 0, w, h, self:IsHovered() and Color(100,50,50,230) or Color(200,100,100,230), 1, Color(255,255,255,255))
    draw.DrawText("Charakter Löschen","BFHUD.Size20",self:GetWide()/2,self:GetTall()/4,Color(255,255,255,255),TEXT_ALIGN_CENTER)
  end

  /*
  local data_name = vgui.Create("DLabel",rightpanel)
  data_name:SetSize(500,50)
  data_name:SetPos(0,0)
  data_name:SetText("")
  data_name.Paint = function(self,w,h)
    draw.DrawText("Name: "..LocalPlayer().Characters[scroll.Selected].name,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end


  local data_money = vgui.Create("DLabel",rightpanel)
  data_money:SetSize(500,50)
  data_money:SetPos(0,40)
  data_money:SetText("")
  data_money.Paint = function(self,w,h)
    draw.DrawText("$"..LocalPlayer().Characters[scroll.Selected].money,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end

  local data_id = vgui.Create("DLabel",rightpanel)
  data_id:SetSize(500,50)
  data_id:SetPos(0,80)
  data_id:SetText("")
  data_id.Paint = function(self,w,h)
    draw.DrawText("ID: "..LocalPlayer().Characters[scroll.Selected].id,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end

  local data_team = vgui.Create("DLabel",rightpanel)
  data_team:SetSize(500,50)
  data_team:SetPos(0,120)
  data_team:SetText("")
  data_team.Paint = function(self,w,h)
    draw.DrawText("Team: "..RPExtraTeams[tonumber(LocalPlayer().Characters[scroll.Selected].team)].name,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end

  local data_last_played = vgui.Create("DLabel",rightpanel)
  data_last_played:SetSize(500,50)
  data_last_played:SetPos(0,160)
  data_last_played:SetText("")
  data_last_played.Paint = function(self,w,h)
    draw.DrawText("Last played on: "..LocalPlayer().Characters[scroll.Selected].last_played,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end

  local data_creation_date = vgui.Create("DLabel",rightpanel)
  data_creation_date:SetSize(500,50)
  data_creation_date:SetPos(0,200)
  data_creation_date:SetText("")
  data_creation_date.Paint = function(self,w,h)
    draw.DrawText("Created on: "..LocalPlayer().Characters[scroll.Selected].creation_date,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end

  local data_steamid64 = vgui.Create("DLabel",rightpanel)
  data_steamid64:SetSize(500,50)
  data_steamid64:SetPos(0,240)
  data_steamid64:SetText("")
  data_steamid64.Paint = function(self,w,h)
    draw.DrawText("Gebunde an: "..LocalPlayer().Characters[scroll.Selected].steamid64,"BFHUD.Size40",5,0,Color(255,0,0,255),TEXT_ALIGN_LEFT)
  end

  function reloadDataLabels()
    data_name:Paint()
    data_money:Paint()
    data_id:Paint()
    data_team:Paint()
    data_last_played:Paint()
    data_creation_date:Paint()
    data_steamid64:Paint()
  end
*/







    local charlist = vgui.Create("DListView",main)
    charlist:SetSize(360,380)
    charlist:SetPos(20,20)
    charlist:SetMultiSelect(false)
    charlist:AddColumn( "ID" )
    charlist:AddColumn( "Name" )
    charlist:AddColumn( "Team" )
    charlist:AddColumn( "Money" )

    if not LocalPlayer().Characters or LocalPlayer().Characters == {} then

    else
      for index,char in pairs(LocalPlayer().Characters) do
        charlist:AddLine(char.id,char.name,RPExtraTeams[tonumber(char.team)].name,char.money)
      end
    end



    local b_Load = vgui.Create("DButton",main)
    b_Load:SetSize(150,20)
    b_Load:SetPos(20,420)
    b_Load:SetText("Charakter Laden")
    b_Load.DoClick = function()
      if not charlist:GetSelectedLine() then return end
      local id = charlist:GetLines()[charlist:GetSelectedLine()]:GetColumnText(1)
      net.Start("PLAYLIB.charsystem::LoadCharacter")
        net.WriteString(tostring(id))
      net.SendToServer()
    end

    local b_Remove = vgui.Create("DButton",main)
    b_Remove:SetSize(150,20)
    b_Remove:SetPos(20,450)
    b_Remove:SetText("Charakter Löschen")
    b_Remove.DoClick = function()
      if not charlist:GetSelectedLine() then return end
      local id = charlist:GetLines()[charlist:GetSelectedLine()]:GetColumnText(1)
      net.Start("PLAYLIB.charsystem::RemoveCharacter")
        net.WriteString(tostring(id))
      net.SendToServer()
    end

    local b_changeName = vgui.Create("DButton",main)
    b_changeName:SetSize(150,20)
    b_changeName:SetPos(180,450)
    b_changeName:SetText("Namen ändern")
    b_changeName.DoClick = function()
      if not charlist:GetSelectedLine() then return end
      PLAYLIB.vgui.valueDerma("Neuer Name","Hier den Namen eingeben...",
      "Abgeben",function(self,val)
        local id = charlist:GetLines()[charlist:GetSelectedLine()]:GetColumnText(1)
        net.Start("PLAYLIB.charsystem::EditCharacter")
          net.WriteString(tostring(id))
          net.WriteTable({["name"]=tostring(val)})
        net.SendToServer()
      end,
      "Abbrechen",function(self) end,
      false)


    end
  end

  function PLAYLIB.charsystem:CreateInfoPanel(parent,txt)
    local base = vgui.Create("DPanel",parent)
    base:SetPos(0,0)
    base:SetSize(parent:GetWide(),parent:GetTall())

    local closeButton = vgui.Create("DButton",base)
    closeButton:SetSize(20,20)
    closeButton:SetPos(base:GetWide()-closeButton:GetWide(),0)
    closeButton:SetText("Close")
    closeButton.DoClick = function()
      base:Remove()
    end

    local text = vgui.Create("RichText",base)
    text:SetSize(base:GetWide(),base:GetTall()-20)
    text:SetPos(0,20)
    text:AppendText(txt)


  end




end
