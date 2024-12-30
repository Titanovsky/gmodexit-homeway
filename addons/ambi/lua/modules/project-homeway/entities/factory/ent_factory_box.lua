local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'factory_box'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Коробка с оружием'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Factory'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/Items/item_item_crate.mdl',
    date = '28.08.2024 6:51'
}

function ENT:GetWeapon( sClass )
    return self[ 'nw_'..sClass ] or 0
end

function ENT:HasWeapons()
    for class, _ in pairs( Ambi.Homeway.Config.factory_items ) do
        if ( self:GetWeapon( class ) > 0 ) then return true end
    end
    
    return false
end

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 600 * 600
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 8 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 26 + sin), Angle(0, rot, 90), 0.1)
            Draw.Box( 330, 54, -160, -20, C.HOMEWAY_BLACK, 6 )
            Draw.Box( 330 - 8, 54 - 8, -160 + 4, -20 + 4, C.HOMEWAY_BLUE_DARK, 8 )
            Draw.SimpleText( 4, 4, 'Коробка с оружием', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )

            local i = 0
            for class, info in pairs( Ambi.Homeway.Config.factory_items ) do
                local count = self:GetWeapon( class )
                if ( count <= 0 ) then continue end

                Draw.SimpleText( -155, 32 + ( 24 * i ), info.header..' x'..count, UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.BLACK )

                i = i + 1
            end

            --Draw.SimpleText( 4, 32 + ( 24 * i ), 'Патроны x', UI.SafeFont( '20 Montserrat' ), C.HOMEWAY_BLUE, 'top-right', 1, C.BLACK )
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

local COLOR = Color( 155, 209, 240 )
function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetColor( COLOR )
    self:SetHealth( 100 )

    local phys = self:GetPhysicsObject()
    if IsValid( phys ) then
        phys:SetMass( 250 )
    end
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
end

function ENT:OnTakeDamage( dmgInfo )
    self:SetHealth( self:GetHealth() - dmgInfo:GetDamage() )

    if ( self:Health() <= 0 ) then self:Remove() end
end

function ENT:SetWeapon( sClass, nCount )
    self[ 'nw_'..sClass ] = nCount
end

function ENT:AddWeapon( sClass, nCount )
    self:SetWeapon( sClass, self:GetWeapon( sClass ) + nCount )
end

function ENT:StartTouch( eObj )
    if eObj.cant_touch then return end
    if ( eObj:GetClass() ~= self.Class ) then return end

    local i = eObj:EntIndex()
    local j = self:EntIndex()
    
    if ( i > j ) then 
        self.cant_touch = true

        for class, _ in pairs( Ambi.Homeway.Config.factory_items ) do
            eObj:AddWeapon( class, self:GetWeapon( class ) )
        end

        self:Remove()
    else
        eObj.cant_touch = true

        for class, _ in pairs( Ambi.Homeway.Config.factory_items ) do
            self:AddWeapon( class, eObj:GetWeapon( class ) )
        end

        eObj:Remove()
    end
end

RegEntity.Register( ENT.Class, 'ents', ENT )