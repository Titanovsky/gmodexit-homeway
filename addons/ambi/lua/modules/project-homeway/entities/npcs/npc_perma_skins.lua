local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_perma_skins'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Perma Skins'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.NPC'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/konnie/jumpforce/lightyagami_f.mdl',
    module = 'Homeway',
    date = '11.09.2024 6:27'
}

function ENT:PlayAnimation(animation)
    local sequence = self:LookupSequence(animation)
    if not sequence then return end
    
    if sequence then
        self:ResetSequence(sequence)
        self:SetCycle(0)
        self:SetPlaybackRate(4)  -- Устанавливаем скорость воспроизведения
    end
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 450 ^ 2

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            Draw.SimpleText( 4, -20, 'Дик Велмор', UI.SafeFont( '40 Montserrat Medium' ), C.AMBI_PURPLE, 'center', 1, C.BLACK )
            Draw.SimpleText( 4, 10, 'Продаёт крутые шмотки', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
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
    ePly:SendLua( 'Ambi.Homeway.OpenPermaSkinShop()' )
end

Ents.Register( ENT.Class, 'ents', ENT )