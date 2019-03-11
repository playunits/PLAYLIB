if !PLAYLIB then return end

if SERVER then

elseif CLIENT then


  local PANEL = {}

  function PANEL:Init()

  	self:SetContentAlignment( 5 )
    self.TrueColor = Color(255,255,255,0)
    self.FalseColor = Color(255,255,255,0)
    self.CurColor = Color(255,255,255)
    self.Radius = (self:GetTall()/2)
    self.CurValue = false
    self.SquareSize = (self:GetWide()/2)
    self.OnClick = function() end
    self.BallXPosTrue = (self.Radius)
    self.BallXPosFalse = (self:GetWide()-self.Radius)
    self.CurXPos = Color(self.Radius,0,0,0)
    self.ChangeTime = .5
    self.ChangeSteps = 12
    self.TrueBackColor = Color(0,255,0,255)
    self.FalseBackColor = Color(255,0,0,255)
    self.CurBackColor = Color(0,0,0,255)

    self.NextClick = 0


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
    self:SetValue(true)
  	--self:SetFont( "DermaDefault" )

  end

  function PANEL:GetValue()
    return self.CurValue
  end

  function PANEL:SetChangeTime(number)
    if isnumber(number) then
      self.ChangeTime = number
    end
  end

  function PANEL:SetBorderSize(number)
    if isnumber(number) then
      self.BorderSize = number
    end
  end

  function PANEL:SetChangeSteps(number)
    if isnumber(number) then
      self.ChangeSteps = number
    end
  end

  function PANEL:SetTrueBackColor(color)
    if IsColor(color) then
      self.TrueBackColor = color
    end
  end

  function PANEL:SetFalseBackColor(color)
    if IsColor(color) then
      self.FalseBackColor = color
    end
  end

  function PANEL:SetBoxSize(number)
    self:SetSize(number,number)
    self.SquareSize = number/2
    self.Radius = number/4
    self.BallXPosTrue = (self.Radius)
    self.BallXPosFalse = (self:GetWide()-self.Radius)
  end

  function PANEL:DoClick()
    if CurTime() > self.NextClick then
      if self:GetValue() then
        self:SetValue(false)
      else
        self:SetValue(true)
      end
      self.OnClick(self,self:GetValue())
      self.NextClick = (CurTime() + self.ChangeTime)+0.2
    end

  end

  function PANEL:SetValue(bool)
    if not isbool(bool) then return end
    self.CurValue = bool
    if bool then
      PLAYLIB.vgui.colorInterpolationAnimation(self.CurColor,self.ChangeSteps,self.ChangeTime,self.CurColor,self.TrueColor)
      PLAYLIB.vgui.colorInterpolationAnimation(self.CurBackColor,self.ChangeSteps,self.ChangeTime,self.CurBackColor,self.TrueBackColor)
      PLAYLIB.vgui.colorInterpolationAnimation(self.CurXPos,self.ChangeSteps,self.ChangeTime,self.CurXPos,Color(self.BallXPosTrue,0,0,0))
    else
      PLAYLIB.vgui.colorInterpolationAnimation(self.CurColor,self.ChangeSteps,self.ChangeTime,self.CurColor,self.FalseColor)
      PLAYLIB.vgui.colorInterpolationAnimation(self.CurBackColor,self.ChangeSteps,self.ChangeTime,self.CurBackColor,self.FalseBackColor)
      PLAYLIB.vgui.colorInterpolationAnimation(self.CurXPos,self.ChangeSteps,self.ChangeTime,self.CurXPos,Color(self.BallXPosFalse,0,0,0))
    end
  end

  function PANEL:SetTrueColor(color)
    if IsColor(color) then
      self.TrueColor = color
    end
  end

  function PANEL:SetFalseColor(color)
    if IsColor(color) then
      self.FalseColor = color
    end
  end

  function PANEL:SetRadius(number)
    if isnumber(number) then
      self.Radius = number
    end
  end

  function PANEL:IsDown()

  	return self.Depressed

  end

  function PANEL:Paint( w, h )
    draw.RoundedBox( self:GetWide()/4, 0, (self:GetTall()/4), w, (h/2), self.CurBackColor )
    PLAYLIB.vgui.drawFilledCircle(self.CurXPos.r,self:GetTall()/2,self.Radius,self.CurColor)
  end

  function PANEL:SizeToContents()
  	local w, h = self:GetContentSize()
  	self:SetSize( w + 8, h + 4 )
  end

  vgui.Register("PButton_Toggle", PANEL, "DButton")
end
