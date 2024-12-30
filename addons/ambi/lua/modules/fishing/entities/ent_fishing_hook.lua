local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'fishing_hook'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Крючок'
ENT.Author		= 'Ambi'
ENT.Category	= 'Fishing'
ENT.Spawnable   = false

ENT.Stats = {
    type = 'Entity',
    module = 'Fishing',
    model = 'models/props_junk/meathook001a.mdl',
    date = '07.06.2021 14:09:12'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = AMB.Ambition.Global.RENDER

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end
    
    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    self:SetModelScale( 0.2 )
    Ents.Physics( self, nil, nil, nil, true, false )
end

function ENT:StartTouch( eObj )
    if not self.rod or self.occupaited then return end
    if ( eObj:GetClass() ~= 'fishing_bait' ) then return end
    if not eObj.bait then return end

    if IsValid( eObj ) then
        self.occupaited = true
        self.bait = eObj
        self.player = eObj:GetOwner()
        
        eObj:SetPos( self:GetPos() )
        eObj:SetParent( self )
        eObj:SetColor( Color( 255, 0, 0 ) )
        eObj.hook = self
    end
end

hook.Add( 'OnEntityWaterLevelChanged', 'AMB.Fishing.ReadyBait', function( eObj, nOldLevel, nNewLevel )
    if ( eObj:GetClass() == 'fishing_hook' ) and eObj.occupaited and IsValid( eObj.bait ) then
        local bait = eObj.bait
        if bait.ready then
            if ( nNewLevel > 0 ) then return end
            
            bait.ready = false
            bait:SetColor( Color( 255, 0, 0 ) )
            timer.Remove( 'AmbFishingBait:'..tostring( bait ) )
        elseif not bait.ready then
            if ( nNewLevel < 2 ) then return end

            bait:SetHealth( bait:Health() - 10 )
            if ( bait:Health() <= 0 ) then bait:Remove() return end
        
            bait.ready = true
            bait:SetColor( Color( 0, 255, 0 ) )
            timer.Create( 'AmbFishingBait:'..tostring( bait ), math.random( AMB.Fishing.GetBait( bait.bait ).time.min, AMB.Fishing.GetBait( bait.bait ).time.max ), 1, function()
                if not IsValid( bait ) then return end

                AMB.Fishing.GetBait( bait.bait ).action( eObj.player, eObj, eObj.rod )

                bait:EmitSound( 'physics/cardboard/cardboard_box_break1.wav' )
                bait:Remove()
            end )
        end
    end
end )

Ents.Register( ENT.Class, 'ents', ENT )