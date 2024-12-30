WEED_PANEL = WEED_PANEL or nil

net.Receive("OpenTablet",function()
  if(WEED_PANEL != nil) then
    WEED_PANEL:Remove()
  end
  WEED_PANEL = vgui.Create("dWeeder")
end)

surface.CreateFont( "WeedTitle", {
	font = "Roboto Lt",
	size = 28
} )

surface.CreateFont( "WeedItem", {
	font = "Roboto Lt",
	size = 24
} )

surface.CreateFont( "WeedItemDesc", {
	font = "Roboto Lt",
	size = 20
} )

surface.CreateFont( "WeedDesc", {
	font = "Roboto Lt",
	size = 16
} )

local PANEL = {}
PANEL.Start = 0

function PANEL:Init()
  self.Start = SysTime()
  self:SetSize(800,532)
  self:MakePopup()
  self:Center()
  self:SetDraggable(false)

  self.C = vgui.Create("DScrollPanel",self)
  self.C.Paint = function(s,w,h)  end
  self:SkinScrollbar(self.C:GetVBar())

  self.R = vgui.Create("DPanel",self)
  self.R.Paint = function(s,w,h) self:PaintR(s,w,h) end

  self.L = vgui.Create("DPanel",self)
  self.L.Paint = function(s,w,h) self:PaintL(s,w,h) end
  self.L.Label = vgui.Create("DLabel",self.L)
  self.L.Label:SetPos(12,210)
  self.L.Label:SetSize(192-16,300)
  self.L.Label:SetWrap(true)
  self.L.Label:SetFont("WeedDesc")
  self.L.Label:SetTextColor(Color(75,75,75,150))
	self.L.Label:SetAutoStretchVertical(true)
  self.L.Label:SetText("Tired of seeing how your weed dies because you aren't there for check your resources?\nDon't worry, we got your back with our new device!\nThe Beeper, a device that will notify you every time one of your weed care device fails, so you can fix the issue ASAP")

  self.L.Buy = vgui.Create("DButton",self.L)
  self.L.Buy:SetPos(8,400)
  self.L.Buy:SetSize(178,32)
  self.L.Buy:SetText("")
  self.L.Buy.Paint = function(s,w,h)
    surface.SetDrawColor(Either(s:IsHovered(),Color(211, 84, 0),Color(41, 128, 185)))
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(Either(s:IsHovered(),Color(230, 126, 34),Color(52, 152, 219)))
    surface.DrawRect(2,2,w-4,h-4)
    draw.SimpleText("ONLY $"..WEED_CONFIG.BeeperPrice.."!","WeedItem",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end

  self.L.Buy.DoClick = function()
    if(LocalPlayer():GetNWBool("HasBeeper",false)) then
      Derma_Query( "You already got a beeper\nBind +show_beeper on a key to show this on the screen. Example\nbind mouse3 +show_beeper", "Info", "Okay")
      return
    end
    if(LocalPlayer():getDarkRPVar("money") < WEED_CONFIG.BeeperPrice) then
      Derma_Query( "You don't have enough dosh", "We cannot perform the purchase", "Okay")
    else
      net.Start("PurchaseItem")
      net.WriteString("Beeper")
      net.SendToServer()
      Derma_Query( "Bind +show_beeper on a key to show this on the screen. Example\nbind mouse3 +show_beeper", "Info", "Okay")
      self:Remove()
    end
  end

  self.R:SetSize(350,400)
  self.L:SetSize(200,400)
  self.C:SetSize(250,400)

  self.R:DockMargin( 0,24,0,32 )
  self.L:DockMargin( 0,24,0,32)
  self.C:DockMargin( 0,24,0,32 )

  self.R:Dock(RIGHT)
  self.L:Dock(LEFT)
  self.C:Dock(FILL)

  self:Fill()
  self:SetTitle("")

  self.CloseButton = vgui.Create("DButton",self)
  self.CloseButton:SetSize(100,32)
  self.CloseButton:SetText("")
  self.CloseButton:SetPos(800-100,500)
  self.CloseButton.DoClick = function()
    self:Remove()
  end
  self.CloseButton.Paint = function(s,w,h)
    draw.SimpleText("[CLOSE]","WeedItem",w/2,h/2,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end

  self:ShowCloseButton(false)
end

function PANEL:PaintR(s,w,h)
  surface.SetDrawColor(Color(25, 25, 40,50))
  surface.DrawRect(4,0,w-4,300)
  surface.DrawRect(4,304,w-4,150)

  surface.SetDrawColor(Color(46, 204, 113))
  surface.DrawRect(4,0,w-4,48)
end

local dg = surface.GetTextureID("vgui/gradient-d")
local mt = surface.GetTextureID("gui/beeper")

function PANEL:PaintL(s,w,h)
  surface.SetTexture(dg)
  surface.SetDrawColor(0,0,0,90)
  surface.DrawTexturedRect(0,0,w-4,h)
  surface.SetDrawColor(0,0,0,155)
  surface.DrawTexturedRectRotated((w-4)/2,h/8,w-4,h*0.4,180)

  surface.SetTexture(mt)
  surface.SetDrawColor(Color(241,239,240))
  surface.DrawRect(0,0,w-4,165)
  surface.DrawTexturedRect(6,-8,182,182)

  draw.SimpleText("Get your Beeper!","WeedTitle",w/2-4,160  +16,Color(125,125,125),TEXT_ALIGN_CENTER)
  draw.SimpleText("BUY ME NOW!","RobotText_hud",w/2-48,58,Color(0,0,0))
end

function PANEL:Paint(w,h)
   Derma_DrawBackgroundBlur( self, self.Start )

   DisableClipping(true)
   draw.RoundedBox( 16, -32, -32+4, w+96, h+78, Color(211, 84, 0) )
   draw.RoundedBox( 16, -28, -28+4, w+96-8, h+78-8, Color(40, 40, 40) )
   DisableClipping(false)

   surface.SetDrawColor(Color(241, 239, 240))
   surface.DrawRect(0,0,w,h)

   surface.SetDrawColor(Color(46, 204, 113))
   surface.DrawRect(0,0,w,48)

   surface.SetDrawColor(25,25,25)
   surface.DrawRect(0,h-32,w,32)

   draw.SimpleText("Weed masters...Just grow up","WeedTitle",12,12,Color(241,241,241))
end

PANEL.List = {}

function PANEL:Fill()
  for k,v in pairs(self.List) do
    v:Remove()
  end
  self.List = {}
  local i = 0
  for catName,category in pairs(WEED_ITEMS.Items) do
    local lbl = vgui.Create("DLabel",self.C)
    lbl:SetText(catName)
    lbl:SetSize(250,38)
    lbl:SetPos(8,#self.List*38)
    lbl:SetFont("WeedTitle")
    lbl:SetTextColor(Color(231, 76, 60))
    table.insert(self.List,lbl)
    for k,item in pairs(category) do
      local itm = vgui.Create("dWeedButton",self.C)
      itm.Data = item
      itm.Data.ID = k
      itm:SetSize(250,38)
      itm:SetPos(8,#self.List*38)
      table.insert(self.List,itm)
    end
  end
end

function PANEL:Populate(data)
  if(self.R.Title != nil) then
    self.R.Title:Remove()
  end
  self.R.Title = vgui.Create("DLabel",self.R)
  self.R.Title:SetPos(16,0)
  self.R.Title:SetSize(300,48)
  self.R.Title:SetFont("WeedTitle")
  self.R.Title:SetTextColor(Color(241,240,240))
  self.R.Title:SetText(data.name)

  if(self.R.Model != nil) then
    self.R.Model:Remove()
  end

  self.R.Model = vgui.Create("DAdjustableModelPanel",self.R)
  self.R.Model:SetSize( 346, 252 )
  self.R.Model:SetPos(4,48)
  self.R.Model:SetLookAt( Vector( 0, 0, 0 ) )
  self.R.Model:SetCamPos( Vector( -96, 0, 36 ) )
  self.R.Model:SetModel( data.model )
  self.R.Model.oPaint = self.R.Model.Paint
  self.R.Model.Paint = function(s,w,h)
    self.R.Model:oPaint(w,h)
    draw.SimpleText("You can move with holding 2nd click and W,A,S,D","WeedDesc",4,h-16,Color(64,64,64,75),0)
  end

  self.R.Model.LayoutEntity = function(s,ent)
    if(isfunction(data.draw)) then
      data:draw(ent,s)
    end
  end

  if(self.R.Label != nil) then
    self.R.Label:Remove()
  end

  self.R.Label = vgui.Create("DLabel",self.R)
  self.R.Label:SetPos(12,310)
  self.R.Label:SetSize(350-24,300)
  self.R.Label:SetWrap(true)
  self.R.Label:SetFont("WeedItemDesc")
  self.R.Label:SetTextColor(Color(75,75,75,150))
	self.R.Label:SetAutoStretchVertical(true)
  self.R.Label:SetText(data.description)

  if(self.R.Buy != nil) then
    self.R.Buy:Remove()
  end

  self.R.Buy = vgui.Create("DButton",self.R)
  self.R.Buy:SetPos(350-178-8,400)
  self.R.Buy:SetSize(178,32)
  self.R.Buy:SetText("")
  self.R.Buy.Paint = function(s,w,h)
    surface.SetDrawColor(Either(s:IsHovered(),Color(211, 84, 0),Color(41, 128, 185)))
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(Either(s:IsHovered(),Color(230, 126, 34),Color(52, 152, 219)))
    surface.DrawRect(2,2,w-4,h-4)
    draw.SimpleText("Purchase $"..data.price,"WeedItem",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end
  self.R.Buy.DoClick = function(s)
    if(LocalPlayer():getDarkRPVar("money") < data.price) then
      Derma_Query( "You don't have enough dosh", "We cannot perform the purchase", "Okay")
    else
      net.Start("PurchaseItem")
      net.WriteString(data.ID)
      net.SendToServer()
      self:Remove()
    end
  end
end

function PANEL:SkinScrollbar(sbar)
	sbar:SetWide(8)
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 225, 225, 225, 255 ) )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 175, 175, 175 ) )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 175, 175, 175 ) )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200 ) )
	end

end

derma.DefineControl("dWeeder","dWeeder",PANEL,"DFrame")

local BUTTON = {}
BUTTON.Data = {}

function BUTTON:Init()
  self:SetText("")
end

function BUTTON:DoClick()
  self:GetParent():GetParent():GetParent():Populate(self.Data)
end

BUTTON.Alpha = 0

function BUTTON:Paint(w,h)

  self.Alpha = Lerp(FrameTime()*4,self.Alpha,self:IsHovered() and 255 or 0)

  surface.SetDrawColor(64,64,64,100)
  surface.DrawRect(0,h-4,w-42,2)

  surface.SetDrawColor(Color(243, 156, 18,self.Alpha))
  surface.DrawRect(0,0,w-42,h-6)

  draw.SimpleText(self.Data.name or "","WeedItem",8,h/2-2,Color(64,64,64,150-self.Alpha),0,TEXT_ALIGN_CENTER)
  draw.SimpleText(self.Data.name or "","WeedItem",8,h/2-2,Color(255,255,255,self.Alpha),0,TEXT_ALIGN_CENTER)

end

derma.DefineControl("dWeedButton","dWeedButton",BUTTON,"DButton")
