local REMOVE_ABSOLUTE = { 
    [ language.GetPhrase("spawnmenu.category.postprocess") ] = true, 
	[ language.GetPhrase("spawnmenu.category.dupes") ] = true, 
	[ language.GetPhrase("spawnmenu.category.saves") ] = true 
}

local SPECIFIC = { 
    [ language.GetPhrase("spawnmenu.content_tab") ] = true, 
	[ language.GetPhrase("spawnmenu.category.npcs") ] = true, 
    [ language.GetPhrase("spawnmenu.category.npc") ] = true, 
	[ language.GetPhrase("spawnmenu.category.entities") ] = true, 
    [ language.GetPhrase("spawnmenu.category.weapons") ] = true,
    [ language.GetPhrase("spawnmenu.category.vehicles") ] = true,
}

local function HideQMenu()
    for k, v in pairs( g_SpawnMenu.CreateMenu.Items ) do
        local text = v.Tab:GetText()

        if REMOVE_ABSOLUTE[ text or '' ] then g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true ) HideQMenu() end
        if SPECIFIC[ text or '' ] and not LocalPlayer():IsSeniorStaff() then g_SpawnMenu.CreateMenu:CloseTab( v.Tab, true ) HideQMenu() end
    end
end

hook.Add( 'SpawnMenuOpen', 'Ambi.Homeway.Hide', HideQMenu )

hook.Add( 'SpawnMenuOpen', 'Ambi.Homeway.FixShowHelpWithHideQMenu', function()
    hook.Remove( 'StartSearch', 'StartSearch' )
end )