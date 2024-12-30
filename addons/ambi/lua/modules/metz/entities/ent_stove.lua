local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_stove'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Плита'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '01.07.2022 14:19'
}

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.stove_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        Ambi.Metz.StoveInitialize( self )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.StoveTakeDamage( self, dmgInfo )
    end

    function ENT:Think()
        Ambi.Metz.StoveThink( self )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
    local pos = self:GetPos()
    self.emitTime = CurTime()

    for i = 1, 4 do
        self[ 'firePlace'..i ] = ParticleEmitter( pos )
    end
end

local POS_VELOCITY, POS_GRAVITY = Vector( 0, 0, 150 ), Vector( 0, 0, 10 )
function ENT:Think()
    local pos = self:GetPos()
    local up, forward, right = self:GetUp(), self:GetForward(), self:GetRight()

    local poses = {}
    poses[ 1 ] = pos + ( up * 20 ) + ( forward * 2.8  ) + ( right * 11.5  )
    poses[ 2 ] = pos + ( up * 20 ) + ( forward * 2.8  ) + ( right * -11.2 )
    poses[ 3 ] = pos + ( up * 20 ) + ( forward * -9.8 ) + ( right * -11.2 )
    poses[ 4 ] = pos + ( up * 20 ) + ( forward * -9.8 ) + ( right * 11.5  )

    if self.nw_gasStorage and ( self.nw_gasStorage > 0 ) then
        if ( self.emitTime > CurTime() ) then return end

        for i = 1, 4 do
            if self[ 'nw_firePlace'..i ] then
                local smoke = self[ 'firePlace'..i ]:Add( 'particle/smokesprites_000'..math.random( 1, 9 ), poses[ i ] )
                smoke:SetVelocity( POS_VELOCITY )
                smoke:SetDieTime( math.Rand( 0.6, 2.3 ) )
                smoke:SetStartAlpha( math.Rand( 150, 200 ) )
                smoke:SetEndAlpha( 0 )
                smoke:SetStartSize( math.random( 0, 5 ) )
                smoke:SetEndSize( math.random( 33, 55 ) )
                smoke:SetRoll( math.Rand( 180, 480 ) )
                smoke:SetRollDelta( math.Rand(-3, 3 ) )
                smoke:SetColor( Ambi.Metz.Config.stove_smoke_color.r, Ambi.Metz.Config.stove_smoke_color.g, Ambi.Metz.Config.stove_smoke_color.b )
                smoke:SetGravity( POS_GRAVITY )
                smoke:SetAirResistance( 256 )

                self.emitTime = CurTime() + 1
            end
        end
    end
end

local MAT_LASER = Material( 'cable/physbeam' )
local MAT_STOP = Material( 'icon16/stop.png' )
local COL_WHITE = Color( 255, 0, 0, 0 )
local COL_WHITE_TEXT = Color( 255, 255, 255 )
local COL_BLACK = Color( 0, 0, 0, 200 )
local COL_FIRE_PLACE_ON = Color( 209, 7, 7)
local COL_FIRE_PLACE_OFF = Color( 222, 59 ,59, 0)
local UI = Ambi.Packages.Out( 'ui' )

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

    local pos = self:GetPos()
    local ang = self:GetAngles()

    if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end

    ang:RotateAroundAxis( ang:Up(), 90 )
    ang:RotateAroundAxis( ang:Forward(), 90 )

    render.SetMaterial( MAT_LASER )

    render.DrawBeam( pos + (self:GetUp()*20)+(self:GetForward()*2.8)+(self:GetRight()*11.5), self:GetPos()+(self:GetUp()*24)+(self:GetForward()*2.8)+(self:GetRight()*11.5), 1, 1, 1, COL_WHITE ) -- Fire Place #1
    render.DrawBeam( pos + (self:GetUp()*20)+(self:GetForward()*2.8)+(self:GetRight()*-11.2), self:GetPos()+(self:GetUp()*24)+(self:GetForward()*2.8)+(self:GetRight()*-11.2), 1, 1, 1, COL_WHITE ) -- Fire Place #2
    render.DrawBeam( pos + (self:GetUp()*20)+(self:GetForward()*-9.8)+(self:GetRight()*-11.2), self:GetPos()+(self:GetUp()*24)+(self:GetForward()*-9.8)+(self:GetRight()*-11.2), 1, 1, 1, COL_WHITE ) -- Fire Place #3
    render.DrawBeam( pos + (self:GetUp()*20)+(self:GetForward()*-9.8)+(self:GetRight()*11.5), self:GetPos()+(self:GetUp()*24)+(self:GetForward()*-9.8)+(self:GetRight()*11.5), 1, 1, 1, COL_WHITE ) -- Fire Place #4

    local gas_storage, gas_storage_max = self.nw_gasStorage, self.nw_gasStorageMax
    if not gas_storage then return end

    cam.Start3D2D( pos + ang:Up() * 14.5, ang, 0.1 )
        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( -215, -51, 194, 20 )

        surface.SetDrawColor( Ambi.Metz.Config.stove_indicator_color )

        local width = math.Round( ( gas_storage * 190 ) / gas_storage_max )

        surface.DrawRect( -213, -50, width, 18)

        local text = gas_storage
        draw.SimpleTextOutlined( text , UI.SafeFont( '15 Arial' ), -211, -48, COL_WHITE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, COL_BLACK )

        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( -215, -90, 48, 32 )

        local fire_place = self.nw_firePlace1 
        surface.SetDrawColor( ( gas_storage > 0 and fire_place ) and COL_FIRE_PLACE_ON or COL_FIRE_PLACE_OFF )
        surface.SetMaterial( MAT_STOP )
        surface.DrawTexturedRect( -212.5, -73, 14, 14 )

        local fire_place = self.nw_firePlace2
        surface.SetDrawColor( ( gas_storage > 0 and fire_place ) and COL_FIRE_PLACE_ON or COL_FIRE_PLACE_OFF )
        surface.SetMaterial( MAT_STOP )
        surface.DrawTexturedRect( -184.5, -73, 14, 14 )

        local fire_place = self.nw_firePlace3
        surface.SetDrawColor( ( gas_storage > 0 and fire_place ) and COL_FIRE_PLACE_ON or COL_FIRE_PLACE_OFF )
        surface.SetMaterial( MAT_STOP );
        surface.DrawTexturedRect( -184.5, -89, 14, 14 );

        local fire_place = self.nw_firePlace4
        surface.SetDrawColor( ( gas_storage > 0 and fire_place ) and COL_FIRE_PLACE_ON or COL_FIRE_PLACE_OFF )
        surface.SetMaterial( MAT_STOP )
        surface.DrawTexturedRect( -212.5, -89, 14, 14 )
    cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )