local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_rainbow_printer'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Rainbow Printer'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.RainbowPrinters'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/hunter/blocks/cube075x1x025.mdl',
    date = '16.08.2024 20:49'
}

function ENT:GetUpgrade()
    return self.nw_Upgrade or 0
end

function ENT:GetMaxUpgrade()
    return self.nw_MaxUpgrade or 0
end

function ENT:GetMoney()
    return self.nw_Money or 0
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, ContentLoader = Ambi.Packages.Out( '@d, CL' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 1200 ^ 2
    local COLOR_PANEL = Color( 0, 0, 0, 220 ) 
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local pos = self:GetPos()
	    local ang = self:GetAngles()
        ang:RotateAroundAxis( ang:Up(), 90)

        cam.Start3D2D( pos + ang:Up() * 6, ang, 0.11 )
            Draw.Box( 410, 300, -206, -150, C.HOMEWAY_BLUE, 6 )
            Draw.Box( 398, 280, -200, -140, C.HOMEWAY_BLACK, 8 )

            Draw.Box( 240, 32, -190, -124, COLOR_PANEL, 8 )
            Draw.SimpleText( -184, -148, '•', UI.SafeFont( '64 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
            Draw.SimpleText( -160, -125, 'Состояние: '..self:Health(), UI.SafeFont( '32 Montserrat' ), C.AMBI_WHITE, 'top-left', 1, C.ABS_BLACK )

            Draw.Box( 240, 32, -190, -80, COLOR_PANEL, 8 )
            Draw.SimpleText( -184, -103, '•', UI.SafeFont( '64 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
            Draw.SimpleText( -160, -83, 'Уровень: '..self:GetUpgrade(), UI.SafeFont( '32 Montserrat' ), C.AMBI_WHITE, 'top-left', 1, C.ABS_BLACK )

            Draw.Box( 240, 32, -190, -36, COLOR_PANEL, 8 )
            Draw.SimpleText( -184, -60, '•', UI.SafeFont( '64 Montserrat' ), C.FLAT_GREEN, 'top-left', 1, C.ABS_BLACK )
            Draw.SimpleText( -160, -40, string.Comma( self:GetMoney() )..'$', UI.SafeFont( '32 Montserrat' ), C.FLAT_GREEN, 'top-left', 1, C.ABS_BLACK )
            
            if self.nw_BuyerName then
                Draw.SimpleText( -110, 120, self.nw_BuyerName, UI.SafeFont( '28 Montserrat SemiBold' ), C.AMBI_WHITE, 'bottom-left', 1, C.ABS_BLACK )
            end

            Draw.SimpleText( 150, -200, '•', UI.SafeFont( '150 Montserrat SemiBold' ), self.nw_Enable and C.FLAT_GREEN or C.FLAT_RED, 'top-left', 1, C.ABS_BLACK )
        cam.End3D2D()

    end

    function ENT:Think()
        self:SetColor( HSVToColor( ( CurTime() * 32 ) % 360, 0.6, 0.6 ) )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
    
    self:SetUpgrade( 0 )
    self:SetMoney( 0 )
    self:SetMaxUpgrade( Ambi.Homeway.Config.rainbow_printer.max_update )
    self:SetHealth( Ambi.Homeway.Config.rainbow_printer.start_hp )
    self:SetMaxHealth( Ambi.Homeway.Config.rainbow_printer.max_hp )
    self:ToggleSilence( false )
    self:Enable()

    self:SetMaterial( 'models/debug/debugwhite' )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end

    local money = self:GetMoney()
    if ( money <= 0 ) then ePly:Notify( 'Нет денег', 4, NOTIFY_ERROR ) return end

    self:AddMoney( -money )
    ePly:AddMoney( money )
    ePly:Notify( 'Вы сняли с принтера '..money..'$', 6, 2 )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )

    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:StartTouch( eObj )
    if ( eObj:GetClass() == 'ent_rainbow_silencer' ) then
        if self.has_silencer then return end

        self:ToggleSilence( true )
        self:EmitSound( 'physics/metal/metal_computer_impact_hard1.wav' )

        eObj:Remove()
    elseif ( eObj:GetClass() == 'ent_rainbow_kit_repair' ) then
        local new_hp = self:Health() + Ambi.Homeway.Config.rainbow_printer.repair_kit_add_hp
        if ( new_hp > self:GetMaxHealth() ) then return end

        self:SetHealth( new_hp )

        self:EmitSound( 'physics/metal/metal_grate_impact_soft1.wav' )

        eObj:Remove()
    elseif ( eObj:GetClass() == 'ent_rainbow_upgrader' ) then
        if ( self:GetUpgrade() >= self:GetMaxUpgrade() ) then return end

        self:EmitSound( 'doors/door1_stop.wav' )
        self:AddUpgrade( 1 )
        self:Enable()

        eObj:Remove()
    end
end

function ENT:OnRemove()
    timer.Remove( 'Ambi.Homeway.RainbowPrinter:'..self:EntIndex() )

    if IsValid( self:GetBuyer() ) then
        self:GetBuyer():Notify( 'Ваш денежный принтер уничтожен', 5, NOTIFY_ERROR )
    end
end

function ENT:Enable()
    local time = math.max( 0, Ambi.Homeway.Config.rainbow_printer.delay - Ambi.Homeway.Config.rainbow_printer.minus_delay_on_update * self:GetUpgrade() )
    timer.Create( 'Ambi.Homeway.RainbowPrinter:'..self:EntIndex(), time, 0, function() 
        self:PrintMoney()
    end )

    self:EmitSound( 'ambi/ui/beep1_l4d.wav' )

    self.nw_Enable = true
end

function ENT:Disable()
    timer.Remove( 'Ambi.Homeway.RainbowPrinter:'..self:EntIndex() )

    self:EmitSound( 'ambi/ui/hover1.wav' )

    self.nw_Enable = false
end

function ENT:SetUpgrade( nCount )
    nCount = nCount or 0
    nCount = math.max( 0, math.floor( nCount ) )

    self.nw_Upgrade = nCount
end

function ENT:AddUpgrade( nCount )
    self:SetUpgrade( self:GetUpgrade() + ( nCount or 1 ) )
end

function ENT:SetMaxUpgrade( nCount )
    nCount = nCount or 0
    nCount = math.max( 0, math.floor( nCount ) )

    self.nw_MaxUpgrade = nCount
end

function ENT:ToggleSilence( bEnable )
    self.has_silencer = bEnable
end

function ENT:SetMoney( nCount )
    nCount = nCount or 0
    nCount = math.max( 0, math.floor( nCount ) )

    self.nw_Money = ( nCount )
end

function ENT:AddMoney( nCount )
    self:SetMoney( self:GetMoney() + ( nCount or 1 ) )
end

function ENT:PrintMoney()
    if not self.has_silencer then self:EmitSound( 'ambi/money/counter1.ogg', 80 ) end

    local money = Ambi.Homeway.Config.rainbow_printer.money + Ambi.Homeway.Config.rainbow_printer.multiply_money_on_update * self:GetUpgrade()
    self:AddMoney( money )
    self:TakeDamage( Ambi.Homeway.Config.rainbow_printer.damage, self )
end

hook.Add( 'KeyPress', 'Ambi.Homeway.RainbowMoneyPrinterToogle', function(ePly, nKey )
    if ( nKey ~= IN_RELOAD ) then return end

    local ent = ePly:GetEyeTrace().Entity
    if not IsValid(ent) or ( ent:GetClass() ~= ENT.Class ) then return end
    if ( ePly:GetPos():DistToSqr( ent:GetPos() ) >= 100 * 100 ) then return end
    
    if ent.nw_Enable then ent:Disable() else ent:Enable() end
end )

Ents.Register( ENT.Class, 'ents', ENT )