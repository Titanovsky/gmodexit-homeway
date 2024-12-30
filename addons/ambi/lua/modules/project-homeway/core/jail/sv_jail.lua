Ambi.Homeway.jail = Ambi.Homeway.jail or {}

local SQL = Ambi.Packages.Out( 'sql' )
--local DB = SQL.CreateTable( 'ambi_jail', 'SteamID, Name, Date, RegDate, Reason, Punisher' )
local PLAYER = FindMetaTable( 'Player' )

local SPAWNS = {
    Vector( 1232, -4409, 121 ),
    Vector( 1381, -4436, 118 ),
    Vector( 1123, -4487, 122 ),
}

local function UnJail( ePly )
    ePly.nw_Jail = false
    ePly.nw_JailTime = 0

    ePly:Spawn()

    ePly:Notify( '[Jail] Вы освобождены, больше не нарушайте правила!', 15 )

    net.Start( 'ambi_homeway_unjail' )
    net.Send( ePly )

    Ambi.Homeway.jail[ ePly:SteamID() ] = nil

    timer.Remove( 'Ambi.Homeway.Jail:'..ePly:SteamID() )
end

local function Jail( ePly, nSeconds, sReason )
    nSeconds = nSeconds or 1
    sReason = sReason or ''

    ePly.nw_Jail = true
    ePly.nw_JailReason = sReason
    ePly.nw_JailTime = nSeconds

    local spawn = table.Random( SPAWNS )
    ePly:SetPos( spawn )
    ePly:SetJob( Ambi.DarkRP.Config.jobs_class, true )
    ePly:Notify( '[Jail] Вас посадили!', 15 )

    timer.Simple( .1, function()
        if IsValid( ePly ) then ePly:StripWeapons() end
    end )

    local sid = ePly:SteamID()
    timer.Create( 'Ambi.Homeway.Jail:'..sid, nSeconds, 1, function() 
        if not IsValid( ePly ) then return end

        UnJail( ePly )
    end )

    net.Start( 'ambi_homeway_jail' )
        net.WriteUInt( nSeconds / 60, 10 )
    net.Send( ePly )
end

function PLAYER:Jail( nMinutes, sReason )
    sReason = sReason or ''
    nMinutes = nMinutes or 1

    local _time = 60 * nMinutes

    Ambi.Homeway.jail[ self:SteamID() ] = {
        reason = sReason or '',
        time = _time,   
    }

    Jail( self, _time, sReason )
end

function PLAYER:UnJail()
    Ambi.Homeway.jail[ self:SteamID() ] = nil

    UnJail( self )
end

hook.Add( '[Ambi.Homeway.Auth]', 'Ambi.Homeway.Jail', function( ePly ) 
    local jail = Ambi.Homeway.jail[ ePly:SteamID() ]
    if not jail then return end

    Jail( ePly, jail.time, jail.reason )
end )

hook.Add( 'PlayerDisconnected', 'Ambi.Homeway.Jail', function( ePly ) 
    local jail = Ambi.Homeway.jail[ ePly:SteamID() ]
    if not jail then return end

    jail.time = math.floor( timer.TimeLeft( 'Ambi.Homeway.Jail:'..ePly:SteamID() ) or 0 )

    timer.Remove( 'Ambi.Homeway.Jail:'..ePly:SteamID() )
end )

hook.Add( 'PlayerSpawn', 'Ambi.Homeway.Jail', function( ePly ) 
    if not ePly.nw_Jail then return end

    timer.Simple( .1, function()
        if not IsValid( ePly ) then return end
        
        local spawn = table.Random( SPAWNS )
        ePly:SetPos( spawn )
    end )
end )

hook.Add( 'PlayerSpawnObject', 'Ambi.Homeway.Jail', function( ePly ) 
    if ePly.nw_Jail then return false end
end )

hook.Add( 'PlayerSwitchFlashlight', 'Ambi.Homeway.Jail', function( ePly ) 
    if ePly.nw_Jail then return false end
end )

hook.Add( 'PlayerShouldTakeDamage', 'Ambi.Homeway.Jail', function( ePly, eAttacker ) 
    if eAttacker.nw_Jail or ePly.nw_Jail then return false end
end )

hook.Add( '[Ambi.DarkRP.CanSetJob]', 'Ambi.Homeway.Jail', function( ePly ) 
    if ePly.nw_Jail then ePly:Notify( 'Вы в джайле!', 4, NOTIFY_ERROR ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanBuyShopItem]', 'Ambi.Homeway.Jail', function( ePly ) 
    if ePly.nw_Jail then ePly:Notify( 'Вы в джайле!', 4, NOTIFY_ERROR ) return false end
end )

hook.Add( 'WeaponEquip', 'Ambi.Homeway.Jail', function( eWeapon, ePly ) 
    if not ePly.nw_Jail then return end

    timer.Simple( 0, function()
		if IsValid( ePly ) then 
            ePly:Notify( 'Вы в джайле!', 4, NOTIFY_ERROR )
            ePly:StripWeapon( eWeapon:GetClass() ) 
        end
	end )
end )

net.AddString( 'ambi_homeway_jail' )
net.AddString( 'ambi_homeway_unjail' )