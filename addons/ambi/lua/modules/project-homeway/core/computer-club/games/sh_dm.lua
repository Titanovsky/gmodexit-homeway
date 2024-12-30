if not Ambi.ComputerClub then return end

local SPAWNS = {
    { pos = Vector( 4846, 254, -1351 ) },
    { pos = Vector( 5004, 268, -1342 ) },
    { pos = Vector( 5685, 244, -1339 ) },
    { pos = Vector( 5681, 438, -1340 ) },
    { pos = Vector( 5681, 956, -1295 ) },
    { pos = Vector( 5647, 1059, -1336 ) },
    { pos = Vector( 4817, 1009, -1346 ) },
}

local POSES = {
    Vector( -32, -1741, 115 ),
    Vector( -21, -1667, 111 ),
    Vector( -6, -1582, 113 ),
    Vector( -36, -1500, 124 ),
    Vector( -25, -1417, 124 ),
    Vector( -338, -1449, 142 ),
    Vector( -309, -1531, 143 ),
    Vector( -302, -1622, 130 ),
    Vector( -309, -1750, 113 ),
}

local PROPS = {
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 4847, 381, -1368 ), ang = Angle( 0, 90, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5130, 381, -1369 ), ang = Angle( 0, 90, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 4934, 591, -1367 ), ang = Angle( 0, 111, -1 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 4848, 945, -1364 ), ang = Angle( 0, 110, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5094, 1064, -1369 ), ang = Angle( 0, 168, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5207, 840, -1368 ), ang = Angle( 0, 143, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5321, 1059, -1367 ), ang = Angle( 0, 172, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5570, 950, -1368 ), ang = Angle( 0, -133, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5682, 706, -1368 ), ang = Angle( 0, 86, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5584, 833, -1368 ), ang = Angle( 0, -17, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5426, 636, -1367 ), ang = Angle( 0, 22, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5305, 703, -1367 ), ang = Angle( 0, 91, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5573, 266, -1368 ), ang = Angle( 0, 179, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5590, 500, -1370 ), ang = Angle( 0, -46, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5217, 305, -1369 ), ang = Angle( 0, -1, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5017, 887, -1368 ), ang = Angle( 0, 113, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5278, 442, -1367 ), ang = Angle( 0, -49, 0 ) },
    { model = 'models/props_lab/blastdoor001c.mdl', pos = Vector( 5167, 668, -1367 ), ang = Angle( 0, -59, 0 ) },
}

local WEAPONS = {
    { 'arccw_aug', 'arccw_m9', 'arccw_melee_knife' },
    { 'arccw_ak47', 'arccw_m9', 'arccw_melee_knife' },
    { 'arccw_m1014', 'arccw_m9', 'arccw_melee_knife' },
    { 'arccw_m4a1', 'arccw_m9', 'arccw_melee_knife' },
    { 'arccw_mp5', 'arccw_m9', 'arccw_melee_knife' },
}

local game = Ambi.ComputerClub.Make( 'dm', 'Deathmatch', 'FPS', 'Афигенный шутер, где каждый сам за себя, уровень КС не ниже, ёпть!', 60 * 6, function( ePly, tGame ) 
    ePly.in_game_dm = true
    ePly.pseudo_frags = 0

    ePly:SetPseudoHealth( 125 )

    local weps = {}
    for _, wep in ipairs( ePly:GetWeapons() ) do
        weps[ #weps + 1 ] = { class = wep:GetClass(), cannot_drop = wep.cannot_drop, job_weapon = wep.job_weapon }
    end

    ePly:StripWeapons()

    ePly.old_cc_weapons = weps

    local point = table.Random( SPAWNS )
    ePly:SetPos( point.pos )

    local give_weps = table.Random( WEAPONS )
    for _, class in ipairs( give_weps ) do
        ePly:Give( class )

        local wep = ePly:GetWeapon( class )
        wep.cannot_drop = true

        ePly:GiveAmmo( 300, wep:GetPrimaryAmmoType(), true )
    end
    ePly:SelectWeapon( give_weps[ 1 ] )
end, function( ePly )
    local pos = table.Random( POSES )
    ePly:SetPos( pos )

    ePly.in_game_dm = false
    ePly:StripWeapons()

    local weps = ePly.old_cc_weapons or {}
    for _, wep in ipairs( weps ) do
        ePly:Give( wep.class, true )

        local _wep = ePly:GetWeapon( wep.class )
        _wep.cannot_drop = wep.cannot_drop
        _wep.job_weapon = wep.job_weapon
    end

    ePly.old_cc_weapons = nil
end )

if CLIENT then return end

hook.Add( '[Ambi.ComputerClub.PlayerPseudoDeath]', 'Ambi.Homeway.ComputerClubDeathmatch', function( ePly, dmgInfo )
    if ( Ambi.ComputerClub.GetCurrentGame().class ~= game ) then return end
    if not ePly.in_game_dm then return end

    local point = table.Random( SPAWNS )
    ePly:SetPos( point.pos )

    ePly:StripWeapons()
    
    local give_weps = table.Random( WEAPONS )
    for _, class in ipairs( give_weps ) do
        ePly:Give( class )

        local wep = ePly:GetWeapon( class )
        wep.cannot_drop = true

        ePly:GiveAmmo( 300, wep:GetPrimaryAmmoType(), true )
    end

    ePly:SelectWeapon( give_weps[ 1 ] )

    ePly:SetPseudoHealth( 125 )

    local attacker = dmgInfo:GetAttacker()
    if IsValid( attacker ) and attacker:IsPlayer() and attacker:IsPlayingInComputerClub() and ( attacker ~= ePly ) then
        attacker.pseudo_frags = ( attacker.pseudo_frags or 0 ) + 1
        attacker:ChatSend( '~R~ [DM] ~W~ У вас ~R~ '..attacker.pseudo_frags..' ~W~ фрагов' )
    end
end )

hook.Add( '[Ambi.ComputerClub.Started]', 'Ambi.Homeway.Deathmatch', function( sGame )
    if ( sGame ~= game ) then return end

    DM_Props = {}

    for i, prop in ipairs( PROPS ) do
        local obj = ents.Create( 'prop_physics' )
        obj:SetModel( prop.model )
        obj:SetPos( prop.pos )
        obj:SetAngles( prop.ang )
        obj:Spawn()
        obj:SetMaterial( 'ambi/amp/amp_military3' )

        local phys = obj:GetPhysicsObject()
        if IsValid( phys ) then
            phys:EnableMotion( false )
            phys:Sleep()
        end

        DM_Props[ i ] = obj
    end
end )

hook.Add( '[Ambi.ComputerClub.Stoped]', 'Ambi.Homeway.Deathmatch', function( sGame ) 
    if ( sGame ~= game ) then return end

    for i, prop in ipairs( DM_Props ) do
        if IsValid( prop ) then prop:Remove() end
    end

    DM_Props = nil

    local frags_table = {}
    for _, ply in ipairs( player.GetAll() ) do
        local frags = ply.pseudo_frags
        if not frags then continue end

        --frags_table[ #frags_table + 1 ] = { name = ply:Name(), count = frags }

        ply.pseudo_frags = nil

        local money = 20 * frags
        ply:ChatSend( '~R~ [DM] ~W~ Вы набрали ~R~ '..frags..' ~W~ фрагов, ваша награда: ~G~ '..money..'$' )
        ply:AddMoney( money )

        frags_table[ #frags_table + 1 ] = { player = ply, frags = frags }

        if ply.in_game_dm then
            local pos = table.Random( POSES )
            ply:SetPos( pos )
            ply.in_game_dm = false
        end
    end

    for _, tab in ipairs( frags_table ) do
        Ambi.UI.Chat.SendAll( '⚔️ Игрок ~R~ '..tab.player:Name()..' ~W~ набрал ~R~ '..tab.frags..' ~W~ фрагов' )
    end
end )