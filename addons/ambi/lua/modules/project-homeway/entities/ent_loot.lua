local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'loot'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Loot'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_junk/TrashDumpster01a.mdl',
    date = '15.09.2024 7:03'
}

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800 ^ 2
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head = self:GetPos()

        cam.Start3D2D( head + Vector( 0, 0, 30 ), Angle( 0, rot, 90 ), 0.13 )
            Draw.SimpleText( 4, -50, 'Контейнер', UI.SafeFont( '40 Montserrat Medium' ), self.nw_Ready and C.HOMEWAY_BLUE or C.FLAT_RED, 'center', 1, C.BLACK )
            if not self.nw_Ready then Draw.SimpleText( 4, -14, os.date( '%M:%S', self.nw_Delay or 0 ), UI.SafeFont( '32 Montserrat' ), C.AMBI_GRAY, 'center', 1, C.BLACK ) end
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 


function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self.nw_Ready = true
end

function ENT:Use( ePly )
    if not self.nw_Ready then ePly:Notify( 'Подождите', 2, NOTIFY_ERROR ) return end

    self.nw_Ready = false
    self:EmitSound( 'physics/cardboard/cardboard_box_impact_soft6.wav' )
    
    local item = table.Random( Ambi.Homeway.Config.loot_items )
    if ( item == 'none' ) then 
        ePly:Notify( 'Вы ничего не нашли', 5 )
    else
        ePly:AddInvItemOrDrop( item, 1 )
        ePly:Notify( 'Вы нашли '..Ambi.Inv.GetItem( item ).name, 10, NOTIFY_ACCEPT )
    end

    self.nw_Delay = Ambi.Homeway.Config.loot_delay
    self:StartBroadcastTimer()

    timer.Create( 'Ambi.Homeway.LootDelay:'..self:EntIndex(), Ambi.Homeway.Config.loot_delay, 1, function() 
        if not IsValid( self ) then return end

        self.nw_Ready = true
    end )

    hook.Call( '[Ambi.Homeway.Looting]', nil, ePly, item, self )
end

function ENT:StartBroadcastTimer()
    timer.Simple( 1, function()
        if not IsValid( self ) or self.nw_Ready then return end

        self.nw_Delay = timer.TimeLeft( 'Ambi.Homeway.LootDelay:'..self:EntIndex() )
        self:StartBroadcastTimer()
    end )
end

RegEntity.Register( ENT.Class, 'ents', ENT )