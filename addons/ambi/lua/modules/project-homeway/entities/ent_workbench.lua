local RegEntity = Ambi.Packages.Out( 'regentity' )
local ENT = {}

ENT.Class       = 'workbench'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Верстак'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_wasteland/controlroom_desk001b.mdl',
    date = '15.09.2024 7:03'
}

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
            Draw.SimpleText( 4, 4, 'asdsd', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 


function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

RegEntity.Register( ENT.Class, 'ents', ENT )