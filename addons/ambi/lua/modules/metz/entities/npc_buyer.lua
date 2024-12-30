local C, Ents = Ambi.General.Global.Colors, Ambi.RegEntity

local ENT = {}

ENT.Class       = 'metz_buyer'
ENT.Base	    = 'base_ai'
ENT.Type	    = 'ai'

ENT.PrintName	= 'NPC Покупатель'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'NPC',
    module = 'Metz',
    date = '05.06.2022 08:01'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local UI = Ambi.Packages.Out( 'ui' )

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        Ents.Draw( self, false )

        if not Ambi.Metz.Config.buyer_show_name then return end
        if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = self:LookupBone( 'ValveBiped.Bip01_Head1' )
        local head = self:GetBonePosition( head_bone )

        local color = HSVToColor( ( CurTime() * 50 ) % 360, 1, 1 )

        cam.Start3D2D( head + Vector( 0, 0, 12 ), Angle( 0, rot, 90 ), 0.1 )
            draw.SimpleTextOutlined( Ambi.Metz.Config.buyer_name, UI.SafeFont( '26 Ambi' ), 4, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        cam.End3D2D()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

function ENT:Initialize()
    Ents.Initialize( self, Ambi.Metz.Config.buyer_model )
    Ents.Hull( self )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_BBOX, COLLISION_GROUP_PLAYER, false, false, true )
    Ents.Capability( self, CAP_ANIMATEDFACE )
    Ents.Capability( self, CAP_TURN_HEAD )
end

function ENT:Use( ePly )
    local metz = ePly.metz
    if not metz or ( metz <= 0 ) then return end
    if ( hook.Call( '[Ambi.Metz.CanSale]', nil, ePly, self, metz ) == false ) then return end
    
    local result = metz * Ambi.Metz.Config.buyer_modifier
    ePly:ChatPrint( 'Вы продали '..metz..' Метза за '..result..'$' )

    ePly.metz = 0

    if Ambi.Metz.Config.buyer_can_to_pay then 
        ePly:AddMoney( result ) 
        ePly:ChatSend( '~G~ +'..result..'$' )
    end

    ePly:ChatSend( C.AMBI_PURPLE, '[Продавец] ', C.ABS_WHITE, table.Random( Ambi.Metz.Config.buyer_phrases_on_buy_metz ) )

    local snd = table.Random( Ambi.Metz.Config.buyer_sounds_on_buy_metz )
    self:EmitSound( snd )

    hook.Call( '[Ambi.Metz.Sale]', nil, ePly, self, metz, result )
end