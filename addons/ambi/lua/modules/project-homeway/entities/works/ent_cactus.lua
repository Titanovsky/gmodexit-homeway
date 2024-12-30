local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'cactus'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Cactus'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Works'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/de_inferno/tree_small.mdl',
    date = '09.08.2024 10:06'
}

function ENT:GetReady()
    return self.nw_Ready
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

    function ENT:DrawTranslucent( nFlags )
        self:DrawShadow( false )
        self:Draw( nFlags )
    end

    function ENT:Initialize()
        self:SetRenderMode( 1 )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, 'models/cactus/cactus.mdl' )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
    self:SetRenderMode( 1 )
    self:SetReady( true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not self:GetReady() then ePly:Notify( 'Кактусик ещё не созрел', 3, NOTIFY_ERROR ) return end

    self:EmitSound( 'garrysmod/balloon_pop_cute.wav' )

    ePly.cactuses = ( ePly.cactuses or 0 ) + 1
    ePly:Notify( 'Вы собрали кактус, отнесите на склад', 3, NOTIFY_SUCCESS )

    self:SetReady( false )

    timer.Simple( Ambi.Homeway.Config.cactus.delay, function()
        if not IsValid( self ) then return end

        self:SetReady( true )
    end )
end

function ENT:SetReady( bReady )
    self.nw_Ready = bReady

    self:SetColor( Color( 255, 255, 255, bReady and 255 or 200 ) )
end

Ents.Register( ENT.Class, 'ents', ENT )