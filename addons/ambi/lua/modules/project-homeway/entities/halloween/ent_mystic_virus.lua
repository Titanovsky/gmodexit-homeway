local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'mysticrp_virus'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Вирус'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Halloween'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/Items/combine_rifle_ammo01.mdl',
    date = '25.07.2022 19:49'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local UI = Ambi.Packages.Out( 'ui' ) 

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if not self:CheckDistance( LocalPlayer(), 160 ) then return end

        local rot = ( self:GetPos() - EyePos() ):Angle().yaw - 90
        local head = self:GetPos()

        cam.Start3D2D( head + Vector( 0, 0, 14 ), Angle( 0, rot, 90 ), 0.1 )
            draw.SimpleTextOutlined( 'Аниме Вирус', UI.SafeFont( '26 Ambi' ), 4, 0, C.AMBI_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        cam.End3D2D()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 150 )
    self:SetMaxHealth( 150 )
    self:SetColor( C.ABS_RED )
    self:SetMaterial( 'models/props_c17/FurnitureMetal001a' )
end

-- local RAND_MODELS = {
--     'models/player/biohazard/biohazard.mdl',
--     'models/player/fatty/fatty.mdl',
--     'models/player/monstermash/mm_banshee.mdl',
--     'models/player/monstermash/mm_stein.mdl',
--     'models/player/hidden/hidden.mdl',
--     'models/player/horror/horror.mdl',
--     'models/player/monstermash/mm_zombie.mdl',
--     'models/player/undead/undead.mdl',
--     'models/player/corpse1.mdl',
-- }

local RAND_MODELS = { 'models/raincoat.mdl' }

function ENT:StartTouch( ePly )
    if not ePly:IsPlayer() then return end

    self:Remove()

    local pos = ePly:GetPos()
    --ePly:SetJob( 'TEAM_ZOMBIE', true )

    timer.Simple( 0.1, function()
        if IsValid( ePly ) then ePly:SetPos( pos ) end
    end )

    local model = table.Random( RAND_MODELS )
    ePly:SetModel( model )
    ePly:SetWalkSpeed( math.random( 150, 300 ) )
    ePly:SetRunSpeed( math.random( 300, 600 ) )
    ePly:SetJumpPower( math.random( 100, 450 ) )
    ePly:EmitSound( 'ambi/csz/zombie/coming'..math.random( 1, 16 )..'.ogg' )

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatSend( '~R~ [Вирус] ~W~ Появился мутант ~R~ '..ePly:Name() )
    end
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

Ents.Register( ENT.Class, 'ents', ENT )