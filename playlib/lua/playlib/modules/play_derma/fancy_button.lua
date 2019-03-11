if !PLAYLIB then return end

if SERVER then

elseif CLIENT then


  local PANEL = {}

  function PANEL:Init()

  	self:SetContentAlignment( 5 )
    self.Text = "Button"
    self.BorderSize = 2
    self.FillColor = Color(23,23,23,255)
    self.FillHoverColor = Color(23,23,23,255)
    self.BorderColor = Color(200,200,200,255)
    self.BorderHoverColor = Color(255,255,255,255)
    self.TextFont = "DermaDefault"
    self.TextColor = Color(200,200,200,255)
    self.TextHoverColor = Color(255,255,255,255)

    self.TextColorHoverChange = true
    self.BorderColorHoverChange = true
    self.FillColorHoverChange = true


  	--
  	-- These are Lua side commands
  	-- Defined above using AccessorFunc
  	--
  	self:SetDrawBorder( true )
  	self:SetPaintBackground( true )

  	self:SetSize(self.RelativeSize,self.RelativeSize)
  	self:SetMouseInputEnabled( true )
  	self:SetKeyboardInputEnabled( true )

  	self:SetCursor( "hand" )
    self:SetText("")
  	--self:SetFont( "DermaDefault" )

  end

  function PANEL:AllowBorderColorChange(boolean)
    if not boolean then self.BorderColorHoverChange = true end
    if not isbool(boolean) then return end
    self.BorderColorHoverChange = boolean
  end

  function PANEL:AllowInnerColorChange(boolean)
    if not boolean then self.FillColorHoverChange = true end
    if not isbool(boolean) then return end
    self.FillColorHoverChange = boolean
  end

  function PANEL:AllowTextColorChange(boolean)
    if not boolean then self.TextColorHoverChange = true end
    if not isbool(boolean) then return end
    self.TextColorHoverChange = boolean
  end

  function PANEL:SetBorderSize(number)
    if not number then return end
    if !isnumber(number) then return end
    self.BorderSize = number
  end

  function PANEL:SetButtonText(str)
    if not str then return end
    if !isstring(str) then return end
    self.Text = str
  end

  function PANEL:SetFont(str)
    if not str then return end
    if !isstring(str) then return end
    self.TextFont = str
  end

  function PANEL:SetInnerColor(normal,hover)

    if normal then
      if IsColor(normal) then
        self.FillColor = normal
      end
    end


    if hover then
      if IsColor(hover) then
        self.FillHoverColor = hover
      end
    end

    end

    function PANEL:SetBorderColor(normal,hover)

      if normal then
        if IsColor(normal) then
          self.BorderColor = normal
        end
      end


      if hover then
        if IsColor(hover) then
          self.BorderHoverColor = hover
        end
      end

    end

    function PANEL:SetTextColor(normal,hover)

      if normal then
        if IsColor(normal) then
          self.TextColor = normal
        end
      end


      if hover then
        if IsColor(hover) then
          self.TextHoverColor = hover
        end
      end

    end

  function PANEL:IsDown()

  	return self.Depressed

  end

  function PANEL:Paint( w, h )
    draw.RoundedBox((self:GetWide()/10)+2,0,0,w,h,self.BorderColorHoverChange and self:IsHovered() and self.BorderHoverColor or self.BorderColor)
    draw.RoundedBox( self:GetWide()/10, self.BorderSize, self.BorderSize, w-(self.BorderSize*2), h-(self.BorderSize*2),self.FillColorHoverChange and self:IsHovered() and self.FillHoverColor or self.FillColor  )
    draw.DrawText(self.Text,self.TextFont,self:GetWide()/2,(self:GetTall()/2)-(draw.GetFontHeight(self.TextFont)/2),self.TextColorHoverChange and self:IsHovered() and self.TextHoverColor or self.TextColor,TEXT_ALIGN_CENTER)
  end

  vgui.Register("PButton", PANEL, "DButton")
end
