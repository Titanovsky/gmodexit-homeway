local Ents, C = Ambi.Packages.Out( 'regentity, colors' )

local MAX = 30000

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'npc_casino_coinfliper'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Casino Coin Fliper'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.NPC'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/gman_high.mdl',
    date = '16.08.2024 21:18'
}

function ENT:PlayAnimation(animation)
    self:SetCycle(0)

    local sequence = self:LookupSequence(animation)
    if not sequence then return end
    
    if sequence then
        self:SetPlaybackRate(0.1)
        self:ResetSequence(sequence) 
    end
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 450 ^ 2

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        self:PlayAnimation('ThrowItem')

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            if timer.Exists( 'Casino:'..self:EntIndex() ) then
                local time = tostring( math.floor( timer.TimeLeft( 'Casino:'..self:EntIndex() ) + 1 ) )

                Draw.SimpleText( 8, -16, time, UI.SafeFont( '40 Montserrat' ), C.HOMEWAY_BLUE, 'top-left', 1, C.ABS_BLACK )
            else
                Draw.SimpleText( 4, -20, 'Крупье', UI.SafeFont( '40 Montserrat Medium' ), HSVToColor(  ( CurTime() * 64 ) % 360, 1, 1 ), 'center', 1, C.BLACK )
                Draw.SimpleText( 4, 10, 'Сыграть в Coin Flip', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
            end
        cam.End3D2D()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Hull( self )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_BBOX, COLLISION_GROUP_PLAYER, false, false, true )
    Ents.Capability( self, CAP_ANIMATEDFACE )
    Ents.Capability( self, CAP_TURN_HEAD )
end

function ENT:Use( ePly )
    ePly:SendLua( 'Ambi.Homeway.ShowCasino('..self:EntIndex()..')' )
end