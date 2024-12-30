local todo = ''

-- local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
-- local ENT = {}

-- ENT.Class       = 'ent_rainbow_printer'
-- ENT.Type	    = 'anim'

-- ENT.PrintName	= 'PC'
-- ENT.Author		= 'Ambi'
-- ENT.Category	= 'Homeway.RainbowPrinters'
-- ENT.Spawnable   =  true

-- ENT.Stats = {
--     type = 'Entity',
--     module = 'Homeway',
--     model = 'models/props/de_inferno/tree_small.mdl',
--     date = '16.08.2024 20:49'
-- }

-- function ENT:GetUpgrade()
--     return self.nw_Upgrade or 0
-- end

-- function ENT:GetMaxUpgrade()
--     return self.nw_MaxUpgrade or 0
-- end

-- function ENT:GetMoney()
--     return self.nw_Money or 0
-- end

-- Ents.Register( ENT.Class, 'ents', ENT )

-- if CLIENT then
--     local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
--     local W, H = ScrW(), ScrH()
--     local DISTANCE = 400 * 400
    
--     ENT.RenderGroup = RENDERGROUP_BOTH

--     function ENT:DrawTranslucent()
--         if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) <= DISTANCE ) then return end

--         self:DrawShadow( false )
--     end

--     return Ents.Register( ENT.Class, 'ents', ENT )
-- end 

-- function ENT:Initialize()
--     Ents.Initialize( self, self.Stats.model )
--     Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
    
--     self:SetUpgrade( 0 )
--     self:SetMoney( 0 )
--     self:SetMaxUpgrade( Ambi.Homeway.Config.rainbow_printer.max_update )
--     self:SetHealth( Ambi.Homeway.Config.rainbow_printer.start_hp )
--     self:ToggleSilence( false )
-- end

-- function ENT:Use( ePly )
--     if not ePly:IsPlayer() then return end
-- end

-- function ENT:SetUpgrade( nCount )
--     self.nw_Upgrade = ( nCount or 0 )
-- end

-- function ENT:AddUpgrade( nCount )
--     self:SetUpgrade( self:GetUpgrade() + ( nCount or 1 ) )
-- end

-- function ENT:SetMaxUpgrade( nCount )
--     self.nw_MaxUpgrade = ( nCount or 0 )
-- end

-- function ENT:ToggleSilence( bEnable )
--     self.has_silencer = bEnable
-- end

-- function ENT:SetMoney( nCount )
--     self.nw_Money = ( nCount or 0 )
-- end

-- function ENT:AddMoney( nCount )
--     self:SetMoney( self:GetMoney() + ( nCount or 1 ) )
-- end

-- function ENT:PrintMoney()
-- end

-- function ENT:OnTakeDamage( damageInfo )
--     self:SetHealth( self:Health() - damageInfo:GetDamage() )

--     if ( self:Health() <= 0 ) then self:Remove() return end
-- end

-- Ents.Register( ENT.Class, 'ents', ENT )