local CATEGORY = 'Warn'

local command = 'warn'
local function Action( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    eTarget:Warn( sReason, owner )

	ulx.fancyLogAdmin( eCaller, '#A дал варн #T. Причина: #s', eTarget, sReason )

    hook.Call( '[Ambi.ULX.warn]', nil, eCaller, eTarget, sReason )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Дать обычный варн игроку' )

local command = 'unwarn'
local function Action( eCaller, eTarget, nID, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    local warn = Ambi.Warn.GetWarns( eTarget:SteamID() )[ nID ]
    if not warn then return end

    eTarget:UnWarn( nID )

	ulx.fancyLogAdmin( eCaller, '#A убрал варн #i для #T. Причина: #s', nID, eTarget, sReason )

    hook.Call( '[Ambi.ULX.unwarn]', nil, eCaller, eTarget, nID, sReason, warn )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.NumArg, min=1, max=100, default=1, hint="Номер варна", ULib.cmds.round, ULib.cmds.optional }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия варна' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убрать обычный варн у игрока по ID' )

local command = 'removewarns'
local function Action( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    local warns = Ambi.Warn.GetWarns( eTarget:SteamID() )
    if not warns then return end

    eTarget:RemoveAllWarns()

	ulx.fancyLogAdmin( eCaller, '#A убрал все варны для #T. Причина: #s', eTarget, sReason )

    hook.Call( '[Ambi.ULX.removewarns]', nil, eCaller, eTarget, sReason, warn )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия варнов' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убрать все обычный варны' )

local command = 'getwarns'
local function Action( eCaller, eTarget )
    local warns = eTarget:GetWarns()

    if IsValid( eCaller ) then
        if ( #warns == 0 ) then eCaller:ChatSend( '~FLAT_RED~ [Warn] ~W~ У игрока '..eTarget:Name()..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            eCaller:ChatSend( '~FLAT_RED~ [Warn] ~W~ '..id..'. '..warn.reason )
        end
    else
        if ( #warns == 0 ) then print( '[Warn] У игрока '..eTarget:Name()..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            print( '[Warn] '..id..'. '..warn.reason )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Посмотреть действующие варны у игрока' )

local command = 'getwarnsoffline'
local function Action( eCaller, sSteamID )
    local warns = Ambi.Warn.GetWarns( sSteamID )

    if IsValid( eCaller ) then
        if not Ambi.Homeway.IsPlayerReg( sSteamID ) then eCaller:ChatSend( '~FLAT_RED~ • Игрок с таким SteamID даже не зарегистрирован' ) return end
        if ( #warns == 0 ) then eCaller:ChatSend( '~FLAT_RED~ [Warn] ~W~ У игрока '..sSteamID..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            eCaller:ChatSend( '~FLAT_RED~ [Warn] ~W~ '..id..'. '..warn.reason )
        end
    else
        if not Ambi.Homeway.IsPlayerReg( sSteamID ) then print( '[Warn] Игрок с таким SteamID даже не зарегистрирован' ) return end
        if ( #warns == 0 ) then print( '[Warn] У игрока '..sSteamID..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            print( '[Warn] '..id..'. '..warn.reason )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.StringArg, hint = 'SteamID' }
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Посмотреть действующие варны у игрока по SteamID' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Warn.Donate'

local command = 'dwarn'
local function Action( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    eTarget:DonateWarn( sReason, owner )

	ulx.fancyLogAdmin( eCaller, '#A дал донат варн #T. Причина: #s', eTarget, sReason )

    hook.Call( '[Ambi.ULX.dwarn]', nil, eCaller, eTarget, sReason )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Дать обычный варн игроку' )

local command = 'undwarn'
local function Action( eCaller, eTarget, nID, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    local warn = Ambi.Warn.GetDonateWarns( eTarget:SteamID() )[ nID ]
    if not warn then return end

    eTarget:UnDonateWarn( nID )

	ulx.fancyLogAdmin( eCaller, '#A убрал донат варн #i для #T. Причина: #s', nID, eTarget, sReason )

    hook.Call( '[Ambi.ULX.undwarn]', nil, eCaller, eTarget, nID, sReason, warn )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.NumArg, min=1, max=100, default=1, hint="Номер варна", ULib.cmds.round, ULib.cmds.optional }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия варна' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убрать обычный варн у игрока по ID' )

local command = 'removedwarns'
local function Action( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    local warns = Ambi.Warn.GetDonateWarns( eTarget:SteamID() )
    if not warns then return end

    eTarget:RemoveAllDonateWarns()

	ulx.fancyLogAdmin( eCaller, '#A убрал все донат варны для #T. Причина: #s', eTarget, sReason )

    hook.Call( '[Ambi.ULX.removedwarns]', nil, eCaller, eTarget, sReason, warn )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия варнов' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убрать все обычный варны' )

local command = 'getdwarns'
local function Action( eCaller, eTarget )
    local warns = eTarget:GetDonateWarns()

    if IsValid( eCaller ) then
        if ( #warns == 0 ) then eCaller:ChatSend( '~AMBI_YELLOW~ [Donate Warn] ~W~ У игрока '..eTarget:Name()..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            eCaller:ChatSend( '~AMBI_YELLOW~ [Donate Warn] ~W~ '..id..'. '..warn.reason )
        end
    else
        if ( #warns == 0 ) then print( '[Donate Warn] У игрока '..eTarget:Name()..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            print( '[Donate Warn] '..id..'. '..warn.reason )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Посмотреть действующие варны у игрока' )

local command = 'getdwarnsoffline'
local function Action( eCaller, sSteamID )
    local warns = Ambi.Warn.GetDonateWarns( sSteamID )

    if IsValid( eCaller ) then
        if not Ambi.Homeway.IsPlayerReg( sSteamID ) then eCaller:ChatSend( '~AMBI_YELLOW~ • Игрок с таким SteamID даже не зарегистрирован' ) return end
        if ( #warns == 0 ) then eCaller:ChatSend( '~AMBI_YELLOW~ [Donate Warn] ~W~ У игрока '..sSteamID..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            eCaller:ChatSend( '~AMBI_YELLOW~ [Donate Warn] ~W~ '..id..'. '..warn.reason )
        end
    else
        if not Ambi.Homeway.IsPlayerReg( sSteamID ) then print( '[Donate Warn] Игрок с таким SteamID даже не зарегистрирован' ) return end
        if ( #warns == 0 ) then print( '[Donate Warn] У игрока '..sSteamID..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            print( '[Donate Warn] '..id..'. '..warn.reason )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.StringArg, hint = 'SteamID' }
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Посмотреть действующие донат варны у игрока по SteamID' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local CATEGORY = 'Warn.Admin'

local command = 'adminwarn'
local function Action( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    eTarget:AdminWarn( sReason, owner )

	ulx.fancyLogAdmin( eCaller, '#A дал админ варн #T. Причина: #s', eTarget, sReason )

    hook.Call( '[Ambi.ULX.adminwarn]', nil, eCaller, eTarget, sReason )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Дать админ варн игроку' )

local command = 'unadminwarn'
local function Action( eCaller, eTarget, nID, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    local warn = Ambi.Warn.GetAdminWarns( eTarget:SteamID() )[ nID ]
    if not warn then return end

    eTarget:UnAdminWarn( nID )

	ulx.fancyLogAdmin( eCaller, '#A убрал админ варн #i для #T. Причина: #s', nID, eTarget, sReason )

    hook.Call( '[Ambi.ULX.unadminwarn]', nil, eCaller, eTarget, nID, sReason, warn )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.NumArg, min=1, max=100, default=1, hint="Номер варна", ULib.cmds.round, ULib.cmds.optional }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия варна' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убрать админ варн у игрока по ID' )

local command = 'removeadminwarns'
local function Action( eCaller, eTarget, sReason )
    local owner = IsValid( eCaller ) and eCaller:SteamID() or 'Server'

    local warns = Ambi.Warn.GetAdminWarns( eTarget:SteamID() )
    if not warns then return end

    eTarget:RemoveAllAdminWarns()

	ulx.fancyLogAdmin( eCaller, '#A убрал все админ варны для #T. Причина: #s', eTarget, sReason )

    hook.Call( '[Ambi.ULX.removeadminwarns]', nil, eCaller, eTarget, sReason, warn )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint = 'Причина снятия варнов' }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Убрать все админ варны' )

local command = 'getadminwarns'
local function Action( eCaller, eTarget )
    local warns = eTarget:GetWarns()

    if IsValid( eCaller ) then
        if ( #warns == 0 ) then eCaller:ChatSend( '~AU_SOFT_PURPLE~ [Admin Warn] ~W~ У игрока '..eTarget:Name()..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            eCaller:ChatSend( '~AU_SOFT_PURPLE~ [Admin Warn] ~W~ '..id..'. '..warn.reason )
        end
    else
        if ( #warns == 0 ) then print( '[Admin Warn] У игрока '..eTarget:Name()..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            print( '[Admin Warn] '..id..'. '..warn.reason )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Посмотреть действующие админ варны у игрока' )

local command = 'getadminwarnsoffline'
local function Action( eCaller, sSteamID )
    local warns = Ambi.Warn.GetAdminWarns( sSteamID )

    if IsValid( eCaller ) then
        if not Ambi.Homeway.IsPlayerReg( sSteamID ) then eCaller:ChatSend( '~AU_SOFT_PURPLE~ • Игрок с таким SteamID даже не зарегистрирован' ) return end
        if ( #warns == 0 ) then eCaller:ChatSend( '~AU_SOFT_PURPLE~ [Admin Warn] ~W~ У игрока '..sSteamID..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            eCaller:ChatSend( '~AU_SOFT_PURPLE~ [Warn] ~W~ '..id..'. '..warn.reason )
        end
    else
        if not Ambi.Homeway.IsPlayerReg( sSteamID ) then print( '[Admin Warn] Игрок с таким SteamID даже не зарегистрирован' ) return end
        if ( #warns == 0 ) then print( '[Admin Warn] У игрока '..sSteamID..' нет варнов' ) return end

        for id, warn in ipairs( warns ) do
            print( '[Admin Warn] '..id..'. '..warn.reason )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.StringArg, hint = 'SteamID' }
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Посмотреть действующие админ варны у игрока по SteamID' )