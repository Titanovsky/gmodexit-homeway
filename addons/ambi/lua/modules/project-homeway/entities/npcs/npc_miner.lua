local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'npc_miner'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Miner'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.NPC'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    model = 'models/humans/Group03/male_08.mdl',
    module = 'Homeway',
    date = '19.08.2024 19:11'
}

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
            Draw.SimpleText( 4, -20, 'Боб Фьючер', UI.SafeFont( '40 Montserrat Medium' ), C.AMBI, 'center', 1, C.BLACK )
            Draw.SimpleText( 4, 10, 'Прораб на шахте', UI.SafeFont( '24 Montserrat' ), C.HOMEWAY_WHITE, 'center', 1, C.BLACK )
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
    if ( ePly:GetJob() ~= 'j_miner' ) then ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Ты не рудокоп!' ) return end
    
    local count = 0
    local counts = {}

    for class, _ in pairs( Ambi.Homeway.Config.mine_costs ) do
        local count_item = ePly:GetInvItemCount( class ) or 0
        counts[ class ] = count_item
        count = count + count_item
    end

    if ( count == 0 ) then ePly:ChatSend( '~HOMEWAY_BLUE~ • ~W~ Работай, животное!' ) return end

    local reward_money_all = 0
    for class, count in pairs( counts ) do
        local reward_money = count * Ambi.Homeway.Config.mine_costs[ class ]
        ePly:RemoveInvItem( class, count )
        ePly:Notify( 'Вы продали '..Ambi.Inv.GetItem( class ).name..' на '..reward_money..'$', 8, 2 )
        ePly:AddMoney( reward_money )
        reward_money_all = reward_money_all + reward_money
    end

    ePly:ChatSend( '~G~ • ~W~ Вы заработали: '..reward_money_all..'$' )
end

return Ents.Register( ENT.Class, 'ents', ENT )