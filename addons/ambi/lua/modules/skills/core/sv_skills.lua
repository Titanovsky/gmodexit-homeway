local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetSkill( sSkill, nNode )
    local skills = self.skills
    if not skills then return end
    if not Ambi.Skills.GetSkill( sSkill ) then return end

    nNode = math.max( 0, math.floor( nNode ) )

    skills[ sSkill ] = ( nNode == 0 ) and nil or nNode
    if not self.skills then self.skills = {} end

    if ( nNode > 0 ) then
        local Callback = Ambi.Skills.GetSkill( sSkill ).nodes[ nNode ].Callback
        if Callback then Callback( self ) end   
    end

    Ambi.Skills.Save( self )

    net.Start( 'ambi_skills_sync' )
        net.WriteTable( self.skills )
    net.Send( self )

    hook.Call( '[Ambi.Skills.PlayerSetSkill]', nil, self, sSkill, nNode )
end

function PLAYER:AddSkill( sSkill, nNode )
    sSkill, nNode = sSkill or '', nNode or 1

    local skill = self:GetSkill( sSkill ) and self:GetSkill( sSkill ) + 1 or 1
    self:SetSkill( sSkill, skill or 1 )
end

-- --------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Skills.Initial', function( ePly )
    timer.Simple( 1, function()
        if not IsValid( ePly ) then return end
        if ePly:IsBot() then return end

        ePly.skills = {}

        local skills = Ambi.Skills.Load( ePly )
        if skills then 
            for skill, node in pairs( skills ) do
                if not Ambi.Skills.GetSkill( skill ) then skills[ skill ] = nil continue end

                local node = Ambi.Skills.GetSkill( skill ).nodes[ node ]
                if not node then skills[ skill ] = #Ambi.Skills.GetSkill( skill ).nodes continue end

                if node.Callback then node.Callback( ePly ) end
            end

            ePly.skills = skills or {}
        else
            Ambi.Skills.Save( ePly )
        end

        net.Start( 'ambi_skills_sync' )
            net.WriteTable( ePly.skills )
        net.Send( ePly )
    end )
end )

hook.Add( 'PlayerSpawn', 'Ambi.Skills.Callback', function( ePly )
    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end
        if ePly:IsBot() then return end

        if not ePly.skills then return end

        for skill, node in pairs( ePly.skills ) do
            local node = Ambi.Skills.GetSkill( skill ).nodes[ node ]

            if node.Callback then node.Callback( ePly ) end
        end
    end )
end )