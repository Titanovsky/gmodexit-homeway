local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'applejack_tree'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Apple Tree'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Works'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/de_inferno/tree_small.mdl',
    date = '31.07.2024 2:24'
}

function ENT:GetReady()
    return self.nw_Ready
end

function ENT:GetColorApple()
    return self.nw_ColorApple
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 1200
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if self:GetReady() and ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
            local center = self:LocalToWorld(self:OBBCenter())

            cam.Start3D2D( center, Angle(0, rot, 90), 0.15)
                Draw.SimpleText( 90, -300, '•', UI.SafeFont( '200 Ambi' ), ( self:GetColorApple() == 'red' ) and C.FLAT_RED or C.FLAT_GREEN, 'center', 1, C.BLACK )
                Draw.SimpleText( -120, -400, '•', UI.SafeFont( '200 Ambi' ), ( self:GetColorApple() == 'red' ) and C.FLAT_RED or C.FLAT_GREEN, 'center', 1, C.BLACK )
                Draw.SimpleText( -20, -500, '•', UI.SafeFont( '200 Ambi' ), ( self:GetColorApple() == 'red' ) and C.FLAT_RED or C.FLAT_GREEN, 'center', 1, C.BLACK )
                Draw.SimpleText( -10, -150, '•', UI.SafeFont( '200 Ambi' ), ( self:GetColorApple() == 'red' ) and C.FLAT_RED or C.FLAT_GREEN, 'center', 1, C.BLACK )
                Draw.SimpleText( 25, -560, '•', UI.SafeFont( '200 Ambi' ), ( self:GetColorApple() == 'red' ) and C.FLAT_RED or C.FLAT_GREEN, 'center', 1, C.BLACK )
            cam.End3D2D()
        end
    end

    function ENT:Initialize()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetModelScale( .6 )
    self:ChangeColorApple()
    self:SetReady( true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not self:GetReady() then  ePly:Notify( 'Яблоня ещё не созрела', 3, NOTIFY_ERROR ) return end

    local color = self:GetColorApple()
    
    if ( color == 'red' ) then
        ePly.apple_red = ( ePly.apple_red or 0 ) + 1
    else
        ePly.apple_green = ( ePly.apple_green or 0 ) + 1
    end

    self:EmitSound( 'garrysmod/balloon_pop_cute.wav' )

    ePly:Notify( 'Вы собрали яблоко, отнесите на склад', 3, NOTIFY_SUCCESS )

    self:SetReady( false )

    timer.Simple( Ambi.Homeway.Config.applejack.delay, function()
        if not IsValid( self ) then return end

        self:ChangeColorApple()
        self:SetReady( true )
    end )
end

function ENT:SetReady( bReady )
    self.nw_Ready = bReady
end

function ENT:ChangeColorApple()
    self.nw_ColorApple = ( math.random( 0, 1 ) == 0 ) and 'red' or 'green'
end

Ents.Register( ENT.Class, 'ents', ENT )