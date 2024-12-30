local PLAYER = FindMetaTable( 'Player' )

function PLAYER:GetPrivilege()
    return self.nw_Privilege or 'user'
end

function PLAYER:Privilege()
    return self:GetPrivilege()
end

function PLAYER:IsPrivilege( sPrivilege )
    return self:GetPrivilege() == ( sPrivilege or '' )
end