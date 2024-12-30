local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'homeway_money'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Money'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  false
ENT.IsSpawnedMoney = true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    date = '28.07.2024 19:43'
}

function ENT:GetMoney()
    return self.nw_Money or 0
end

function ENT:Getamount() -- for compatibility
    return self:GetMoney()
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 450
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if self.nw_Money and ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
            local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
            local sin = math.sin(CurTime() * 4 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
            local center = self:LocalToWorld(self:OBBCenter())

            cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 6 + sin), Angle(0, rot, 90), 0.1)
                Draw.SimpleText( 4, 4, self.nw_Money..'$', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, Ambi.DarkRP.Config.money_drop_entity_model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 100 )
    self:SetMaxHealth( 100 )
    if not self.nw_Money then self.nw_Money = 0 end
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if ( hook.Call( '[Ambi.DarkRP.PlayerCanPickupMoney]', nil, ePly, self, self:GetMoney() ) == false ) then return end 

    hook.Call( '[Ambi.DarkRP.PlayerPickedupMoney]', nil, ePly, self, self:GetMoney() )
    
    ePly:AddMoney( self:GetMoney() )
    self:Remove()
end

function ENT:SetMoney( nMoney )
    if ( nMoney < 0 ) then nMoney = 0 end

    local money = math.floor( nMoney )

    self.nw_Money = money
end

function ENT:Setamount( nMoney ) -- for compatibility
    self:SetMoney( nMoney )
end

function ENT:StartTouch( eObj )
    if self.cant_touch then return end
    if ( eObj:GetClass() ~= self.Class ) then return end

    self.cant_touch = true
    eObj.cant_touch = true

    local i = eObj:EntIndex()
    local j = self:EntIndex()

    local money = eObj.nw_Money + self.nw_Money
    
    if ( i > j ) then 
        self:Remove()
        eObj:SetMoney( money )
    else
        eObj:Remove()
        self:SetMoney( money )
    end
end

Ents.Register( ENT.Class, 'ents', ENT )