local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'box_for_money'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Коробка для денег'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/cs_militia/footlocker01_open.mdl',
    date = '15.09.2024 7:03'
}

function ENT:GetMoney()
    return self.nw_Money or 0
end

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800 ^ 2
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent( nFlags )
        self:DrawShadow( false )

        self:Draw( nFlags )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head = self:GetPos()

        cam.Start3D2D( head + Vector( 0, 0, 14 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 4, 4, self:GetMoney()..'$', UI.SafeFont( '64 Montserrat Medium' ), C.AMBI_GREEN, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 


function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 100 )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )

    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:Use( ePly )
    local owner = self:GetBuyer()
    if not IsValid( owner ) then return end

    if ( ePly ~= owner ) then ePly:Notify( 'Бросьте деньги и положите в ящик', 6, NOTIFY_ERROR ) return end

    local money = self:GetMoney()
    if ( money <= 0 ) then return end

    self:SetMoney( 0 )
    ePly:AddMoney( money )
    ePly:Notify( 'Вы сняли '..money..'$', 10, NOTIFY_ACCEPT )
end

function ENT:StartTouch( eObj )
    if ( eObj:GetClass() ~= 'homeway_money' ) then return end

    local money = eObj:GetMoney()
    eObj:Remove()

    self:SetMoney( self:GetMoney() + money )

    if IsValid( self:GetBuyer() ) then 
        self:GetBuyer():Notify( 'Вам задонатили', 2, NOTIFY_ACCEPT )
        self:GetBuyer():ChatSend( '~W~ 💸 В ваш ящик для пожертвований положили ~AMBI_GREEN~ '..money..'$' )
    end
end

function ENT:SetMoney( nCount )
    self.nw_Money = nCount or 0
end

RegEntity.Register( ENT.Class, 'ents', ENT )