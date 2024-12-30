local C, SQL, Gen = Ambi.General.Global.Colors, Ambi.SQL, Ambi.General
local DB = SQL.CreateTable( 'skill_points', 'SteamID, Points' )
local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetSkillPoints( nValue )
    if not self.nw_SkillPoints then return end
    if not nValue or not isnumber( nValue ) then Gen.Error( 'Skills', 'SetSkillPoints | nValue is not valid number' ) return end
    if ( hook.Call( '[Ambi.Skills.CanSetSkillPoints]', nil, self, nValue ) == false ) then return end

    nValue = math.floor( nValue )
    if ( nValue < 0 ) then nValue = 0 end

    local old_value = self.nw_SkillPoints

    self.nw_SkillPoints = nValue

    if not self:IsBot() then SQL.Update( DB, 'Points', nValue, 'SteamID', self:SteamID() ) end

    hook.Call( '[Ambi.Skills.SetSkillPoints]', nil, self, nValue, old_value )
end

function PLAYER:AddSkillPoints( nValue )
    if not nValue or not isnumber( nValue ) then Gen.Error( 'Skills', 'AddSkillPoints | nValue is not valid number' ) return end
    if ( hook.Call( '[Ambi.Skills.CanAddSkillPoints]', nil, self, nValue ) == false ) then return end

    self:SetSkillPoints( nValue + self:GetSkillPoints() )

    hook.Call( '[Ambi.Skills.AddSkillPoints]', nil, self, nValue )
end

-- ---------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.Skills.SetPoints', function( ePly )
    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end
        if ePly:IsBot() then ePly.nw_SkillPoints = 0 return end

        local is_first = false
        local sid = ePly:SteamID()
        local balance = SQL.Select( DB, 'Points', 'SteamID', sid ) 
        if not balance then 
            balance = Ambi.Skills.Config.points_default

            SQL.Insert( DB, 'SteamID, Points', '%s, %i', sid, balance ) 

            is_first = true

            hook.Call( '[Ambi.Skills.PlayerSkillPointsTableCreated]', nil, ePly, balance )
        else
            balance = tonumber( balance )
        end

        ePly.nw_SkillPoints = balance

        hook.Call( '[Ambi.Skills.PlayerSkillPointsTableInit]', nil, ePly, balance, is_first )
    end )
end )