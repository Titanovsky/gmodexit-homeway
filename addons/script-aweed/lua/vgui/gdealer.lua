local PANEL = {}
PANEL.Start = 0
PANEL.State = 0
PANEL.DrawText = ""

local percent = 0

function PANEL:Init()

    percent = 0

    self.Start = SysTime()
    self:SetSize(ScrW(),ScrH())
    self:Center()

    self.State = 0
    self.DrawText = ""

    timer.Simple(0.5,function()
        if(IsValid(self)) then
            self.State = 1
        end
    end)

    self.Model = vgui.Create("DModelPanel",self)
    self.Model:SetModel("models/player/monk.mdl")
    self.Model:SetSize(ScrW()*0.3,ScrH())
    self.Model.LayoutEntity = function(s,ent)
        ent.GetPlayerColor = function() return Vector(1,0.2,1) end
        ent:SetFlexWeight(42,1)
        return
    end


    local eyepos = self.Model.Entity:GetBonePosition( self.Model.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
    eyepos:Add( Vector( 0, 0, 2 ) )	-- Move up slightly
    self.Model:SetLookAt( eyepos )
    self.Model:SetCamPos( eyepos-Vector( -12, 4, 0 ) )	-- Move cam in front of eyes

    self.Exit = vgui.Create("DButton",self)
    self.Exit:SetSize(128,48)
    self.Exit:SetPos(ScrW()-128-24,ScrH()-48-24)
    self.Exit:SetText("")
    self.Exit.DoClick = function() self:Remove() end
    self.Exit.Paint = function(s,w,h)
        surface.SetDrawColor(Color(22, 160, 133))
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(Color(39, 174, 96))
        surface.DrawRect(8,8,w-16,h-16)

        draw.SimpleText("EXIT","BeeperText",w/2+1,h/2+1,Color(35,35,35),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("EXIT","BeeperText",w/2,h/2,Color(235,235,235),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        if(s:IsHovered()) then
            surface.SetDrawColor(Color(255, 255,255, 10))
            surface.DrawRect(0,0,w,h)
        end
    end

    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:SetTitle("")

end

local rope = surface.GetTextureID("gui/rope")
local states = {"Hello! Wanna buy something today?"}
local nDraw = 0

function PANEL:Paint(w,h)

    Derma_DrawBackgroundBlur( self, self.Start )

    percent = Lerp(FrameTime()*2,percent,w-w*0.1+48)

    surface.SetDrawColor(Color(22, 160, 133))
    surface.DrawRect(w*0.1,h-256,percent,256)

    surface.SetDrawColor(Color(39, 174, 96))
    surface.DrawRect(w*0.1+16,h-256+16,percent-32,256-32)

    self.Exit:SetPos(percent-64,ScrH()-48-24)

    surface.SetTexture(rope)
    surface.DrawTexturedRectUVRotated(w*0.1+percent/2+16,h-256-32,32,percent, 0, 0, 1, w/256 ,90)

    if(self.State == 1) then
        if(states[self.State] != self.DrawText && nDraw <= CurTime()) then
            nDraw = CurTime() + 0.05
            self.DrawText = self.DrawText..states[self.State][#self.DrawText+1]
        elseif(states[self.State] == self.DrawText) then
            self.State = 2
            self:CreateButtons()
        end
    end

    draw.SimpleText(self.DrawText,"DealerText",w*0.3+32+1,h-223+1,Color(35,35,35))
    draw.SimpleText(self.DrawText,"DealerText",w*0.3+32,h-223,Color(235,235,235))
end

function PANEL:CreateButtons()
    local w,h = ScrW(),ScrH()
    self.Purchase = {}

    if(table.HasValue(WEED_CONFIG.Tablet,LocalPlayer():Team()) || #WEED_CONFIG.Tablet == 0) then
        self.Purchase[1] = vgui.Create("DButton",self)
        self.Purchase[1]:SetSize(w-w*0.3-64,44)
        self.Purchase[1]:SetPos(w*0.3+32,h-216+48)
        self.Purchase[1]:SetText("")
        self.Purchase[1].Text = "Purchase a provider's tablet ($"..WEED_CONFIG.TabletPrice..")"
        self.Purchase[1].Paint = self.PaintButton
        self.Purchase[1].Price = WEED_CONFIG.TabletPrice
        self.Purchase[1].DoClick = function()
            if(LocalPlayer():getDarkRPVar("money")>=WEED_CONFIG.TabletPrice) then
                net.Start("DoDealerDeliver")
                net.WriteBool(false)
                net.SendToServer()
                self:Remove()
            end
        end
    end

    if(true) then
        self.Purchase[2] = vgui.Create("DButton",self)
        self.Purchase[2]:SetSize(w-w*0.3-64,44)
        self.Purchase[2]:SetPos(w*0.3+32,h-216+48+48)
        self.Purchase[2]:SetText("")
        self.Purchase[2].Text = "Purchase a bong ($"..WEED_ITEMS.Items["Tools"]["bong"].price..")"
        self.Purchase[2].Paint = self.PaintButton
        //76561198011794778
        self.Purchase[2].Price = WEED_ITEMS.Items["Tools"]["bong"].price
        self.Purchase[2].DoClick = function()
            if(LocalPlayer():getDarkRPVar("money")>=WEED_ITEMS.Items["Tools"]["bong"].price) then
                net.Start("DoDealerDeliver")
                net.WriteBool(true)
                net.SendToServer()
                self:Remove()
            end
        end
    end

    self.Purchase[3] = vgui.Create("DButton",self)
    self.Purchase[3]:SetSize(w*0.5,44)
    self.Purchase[3]:SetPos(w*0.3+32,h-216+48+96)
    self.Purchase[3]:SetText("")
    self.Purchase[3].Text = "Purchase/Sell drugs"
    self.Purchase[3].Price = 50
    self.Purchase[3].Paint = self.PaintButton
    self.Purchase[3].DoClick = function()
        if(self.DrugPanel != nil) then
            self.DrugPanel:Remove()
        end
        self.DrugPanel = vgui.Create("gDrugs",self)
        self.DrugPanel:SetSize(400,200)
        self.DrugPanel:Center()
        self.DrugPanel:MakePopup()
    end
end

function PANEL:PaintButton(w,h)
    draw.SimpleText(self.Text,"BeeperText",9,h/2+1,Color(35,35,35),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    draw.SimpleText(self.Text,"BeeperText",8,h/2,Either(LocalPlayer():getDarkRPVar("money")>=self.Price,Color(235,235,235),Color(235,75,75)),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    if(self:IsHovered()) then
        surface.SetDrawColor(Color(255, 255,255, 25))
        surface.DrawRect(0,0,w,h)
    end
end

derma.DefineControl("gDealer","gDealer",PANEL,"DFrame")

local DRUGS = {}
DRUGS.Reference = nil
DRUGS.Selling = false

function DRUGS:Init()

    self.Selling = false;

    if(self.Model != nil) then
      self.Model:Remove()
    end

    self.Model = vgui.Create("DModelPanel",self)
    self.Model:SetSize( 128, 128 )
    self.Model:SetPos(12,48+(200-48)/2-64)
    self.Model:SetModel( "models/gonzo/weedb/bag/bag.mdl" )
    self.Model.oPaint = self.Model.Paint
    self.Model.Paint = function(s,w,h)
      self.Model:oPaint(w,h)
      draw.RoundedBox( 8, 0, 0,w,h, Color(0,0,0,50) )
    end
    self.Selling = false
    self:BestGuessLayout()

    self.Purchase = vgui.Create("DButton",self)
    self.Purchase:SetSize(112,32)
    self.Purchase:SetPos(156,200-32-12)
    self.Purchase:SetText("")
    self.Purchase.Paint = function(s,w,h)
        surface.SetDrawColor(Color(46, 204, 113))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(Either(self.Selling,"Sell","Purchase"),"MainWeedFont_min",w/2+1,h/2+1-4,Color(35,35,35),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(Either(self.Selling,"Sell","Purchase"),"MainWeedFont_min",w/2,h/2-4,Either(self.Selling || LocalPlayer():getDarkRPVar("money") >= self.Price,Color(235,235,235),Color(235,75,75)),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        if(s:IsHovered()) then
            surface.SetDrawColor(Color(255, 255,255, 25))
            surface.DrawRect(0,0,w,h)
        end
    end
    self.Purchase.DoClick = function(s)
        if(tonumber(self.Price) != nil && (self.Selling || LocalPlayer():getDarkRPVar("money") >= self.Price) && tonumber(self.QNT:GetValue()) > 0 && tonumber(self.QLT:GetValue()) > 0) then
            net.Start("PurchaseWeed")
            net.WriteInt(tonumber(self.QNT:GetValue()),16)
            net.WriteInt(tonumber(self.QLT:GetValue()),16)
            net.WriteBool(self.Selling)
            net.SendToServer()
            self:GetParent():Remove()
        end
    end

    self.Cancel = vgui.Create("DButton",self)
    self.Cancel:SetSize(112,32)
    self.Cancel:SetPos(400-112-12,200-32-12)
    self.Cancel:SetText("")
    self.Cancel.Paint = function(s,w,h)
        surface.SetDrawColor(Color(211, 84, 0))
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Cancel","MainWeedFont_min",w/2,h/2+1-4,Color(35,35,35),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("Cancel","MainWeedFont_min",w/2,h/2-4,Color(235,235,235),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        if(s:IsHovered()) then
            surface.SetDrawColor(Color(255, 255,255, 25))
            surface.DrawRect(0,0,w,h)
        end
    end
    self.Cancel.DoClick = function()
        self:Remove()
    end

    self.QNT = vgui.Create( "DTextEntry", self )	-- create the form as a child of frame
    self.QNT:SetPos( 156, 90 )
    self.QNT:SetSize( 112, 24 )
    self.QNT:SetText( 10 )
    self.QNT.OVal = 10
    self.QNT.OnTextChanged = function(s)
        if(tonumber(self.QNT:GetValue()) && tonumber(self.QLT:GetValue())) then
            self.Price = math.Round((self.QNT:GetValue()*WEED_CONFIG.QuantityPrice * self.QLT:GetValue()*WEED_CONFIG.QualityPrice * Either(self.Selling,WEED_CONFIG.SellingPrice,1))/10)*10*Either(self.Selling,WEED_CONFIG.SellingPrice,1)
        end
        if(self.Selling && isnumber(tonumber(self.QNT:GetValue()))) then
            if(tonumber(self.QNT:GetValue()) > LocalPlayer():GetNWInt("WeedAmmount",0)) then
                self.QNT:SetText(LocalPlayer():GetNWInt("WeedAmmount"))
                self.Price = math.Round((self.QNT:GetValue()*WEED_CONFIG.QuantityPrice * self.QLT:GetValue()*WEED_CONFIG.QualityPrice * Either(self.Selling,WEED_CONFIG.SellingPrice,1))/10)*10*Either(self.Selling,WEED_CONFIG.SellingPrice,1)
            end
        end
    end

    self.QLT = vgui.Create( "DTextEntry", self )	-- create the form as a child of frame
    self.QLT:SetPos( 400-112-12, 90 )
    self.QLT:SetSize( 112, 24 )
    self.QLT:SetText( 50 )
    self.QLT.OnTextChanged = function(s)
        if(tonumber(self.QNT:GetValue()) && tonumber(self.QLT:GetValue())) then
            self.Price = math.Round((self.QNT:GetValue()*WEED_CONFIG.QuantityPrice * self.QLT:GetValue()*WEED_CONFIG.QualityPrice)/10)*10*Either(self.Selling,WEED_CONFIG.SellingPrice,1)
        end
    end

    self.Sell = vgui.Create( "DCheckBox", self )
    self.Sell:SetPos( 372, 128 )
    self.Sell:SetValue( 0 )
    self.Sell.OnChange = function(s, bVal )
        self.QLT:SetEditable(!bVal)
        self.Selling = bVal
        if ( bVal ) then
            self.QLT:SetText(math.Round(LocalPlayer():GetNWInt("WeedQuality")))
            self.QNT:SetText(math.Clamp(tonumber(self.QNT:GetValue()),1,math.Round(LocalPlayer():GetNWInt("WeedAmmount",0))))
            timer.Simple(0.1,function()
                self.Price = math.Round((self.QNT:GetValue()*WEED_CONFIG.QuantityPrice * self.QLT:GetValue()*WEED_CONFIG.QualityPrice * Either(self.Selling,WEED_CONFIG.SellingPrice,1))/10)*10*Either(self.Selling,WEED_CONFIG.SellingPrice,1)
            end)
        else
            self.QLT:SetText(50)
            self.Price = math.Round((self.QNT:GetValue()*WEED_CONFIG.QuantityPrice * self.QLT:GetValue()*WEED_CONFIG.QualityPrice)/10)*10*Either(self.Selling,WEED_CONFIG.SellingPrice,1)
        end
    end

    self.Price = math.Round((self.QNT:GetValue()*WEED_CONFIG.QuantityPrice * self.QLT:GetValue()*WEED_CONFIG.QualityPrice)/10)*10*Either(self.Selling,WEED_CONFIG.SellingPrice,1)
    //76561198011794778
    self:SetTitle("")
    self:SetDraggable(false)
    self:ShowCloseButton(false)
end

function DRUGS:BestGuessLayout()

	local ent = self.Model:GetEntity()
	local pos = ent:GetPos()

	local tab = PositionSpawnIcon( ent, pos )

	if ( tab ) then
		self.Model:SetCamPos( tab.origin )
		self.Model:SetFOV( tab.fov )
		self.Model:SetLookAng( tab.angles )
	end

end

DRUGS.Price = 0

function DRUGS:Paint(w,h)
    surface.SetDrawColor(240,240,240)
    surface.DrawRect(0,0,w,h)

    surface.SetDrawColor(Color(52, 73, 94))
    surface.DrawRect(0,0,w,48)

    draw.SimpleText("Grams","MainWeedFont_min",156,52,Color(75,75,75))
    draw.SimpleText("Quality","MainWeedFont_min",280,52,Color(75,75,75))

    draw.SimpleText("Price: $"..self.Price,"MainWeedFont_min",156,116,Color(75,75,75))
    draw.SimpleText("Sell","MainWeedFont_min",372-8,116,Color(75,75,75),TEXT_ALIGN_RIGHT)

    draw.SimpleText("Weed store","MainWeedFont_med",8+2,20+2,Color(35,35,35),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    draw.SimpleText("Weed store","MainWeedFont_med",8,20,Color(235,235,235),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
end

derma.DefineControl("gDrugs","gDrugs",DRUGS,"DFrame")
