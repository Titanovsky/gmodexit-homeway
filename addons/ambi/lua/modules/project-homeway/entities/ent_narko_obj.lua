local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_narko_obj'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Клад'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_junk/garbage_bag001a.mdl',
    date = '11.09.2024 6:59'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800 * 800
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 100 )

    SafeRemoveEntityDelayed( self, 60 * 5 )
end

function ENT:Use( ePly )
    if not self.ply then return end
    if ( ePly ~= self.ply ) then return end
    
    self.ply = nil

    ePly.has_narko_obj = true

    self:Remove()

    ePly:Notify( 'Отнеси груз Барыге', 8 )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )

    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:OnRemove()
    if not IsValid( self.ply ) then return end

    self.ply:RemoveESPMarker( 'Пакетик' )

    self.ply:Notify( 'Груз был утерян, ты проебался!', 10, NOTIFY_ERROR )
    Ambi.DarkRP.Wanted( ePly, nil, 'Нелегальный заработок', 60 * 6 )

    ePly:SetDelay( 'NarkoTask', Ambi.Homeway.Config.narko_delay )
end

Ents.Register( ENT.Class, 'ents', ENT )

hook.Add( 'PlayerDeath', 'Ambi.Homeway.Narko', function( ePly ) 
    if ePly.has_narko_obj then  
        ePly:ChatSend( '~RED~ • ~W~ Груз был утерян, ты проебался!' )

        ePly:SetDelay( 'NarkoTask', Ambi.Homeway.Config.narko_delay )
    end
end )