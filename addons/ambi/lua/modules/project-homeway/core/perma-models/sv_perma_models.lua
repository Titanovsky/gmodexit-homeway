local function SetHands( ePly )
    local model_name = player_manager.TranslateToPlayerModelName( ePly:GetModel() ) -- string name of model
    local hands_info = player_manager.TranslatePlayerHands( model_name ) -- table: model, skin, body
    local hands = ePly:GetHands() -- entity

    if IsValid( hands ) and hands_info and istable( hands_info ) then
        ePly.workaround_can_pickup_weapon = true --! for job.can_pickup_weapons

        hands:SetModel( hands_info.model )
        hands:SetSkin( hands_info.skin )
        hands:SetBodyGroups( hands_info.body )

        ePly.workaround_can_pickup_weapon = nil
    end
end

net.AddString( 'ambi_homeway_perma_model_choice', function( _, ePly ) 
    local id = net.ReadUInt( 7 )
    local item = Ambi.Homeway.Config.perma_models[ id ]
    if not item then return end

    if not ePly:CheckPermaModel( id ) then ePly:PlaySound( 'ambi/ui/beep2_l4d.wav' ) ePly:Notify( 'Нельзя взять эту перма модель', 5, NOTIFY_ERROR ) return end
    if not ePly:Alive() then return end

    --if timer.Exists( 'Ambi.Homeway.PermaWeaponsDelay:'..id..':'..ePly:SteamID() ) then ePly:PlaySound( 'ambi/ui/beep2_l4d.wav' ) ePly:ChatSend( '~R~ • ~W~ У вас задержка, подождите!' ) return end
    --timer.Create( 'Ambi.Homeway.PermaWeaponsDelay:'..id..':'..ePly:SteamID(), item.delay, 1, function() end )

    ePly:EmitSound( 'garrysmod/ui_hover.wav' )
    ePly:RunCommand( 'act forward' )
    ePly:SetModel( item.model )
    ePly:Notify( 'Вы взяли скин '..item.header, 6 )
    ePly.perma_model = item

    if item.bodygroups then
        ePly:SetBodyGroups( item.bodygroups )
    end

    SetHands( ePly )
end )

net.AddString( 'ambi_homeway_perma_model_clear', function( _, ePly ) 
    if not ePly.perma_model then return end

    ePly.perma_model = nil

    ePly:SetModel( ePly:GetJobTable().models[ 1 ] )
    ePly:Notify( 'Вы сняли перма скин', 3 )

    SetHands( ePly )
end )

hook.Add( 'PlayerSpawn', 'Ambi.Homeway.SetPermaModels', function( ePly ) 
    if not ePly.perma_model then return end

    timer.Simple( 0.11, function()
        if IsValid( ePly ) then 
            ePly:SetModel( ePly.perma_model.model ) 
            if ePly.perma_model.bodygroups then ePly:SetBodyGroups( ePly.perma_model.bodygroups ) end

            SetHands( ePly )
        end
    end )
end )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.Homeway.SetPermaModels', function( ePly, sClass, _, _, tJob ) 
    if not ePly.perma_model then return end

    timer.Simple( 0.11, function()
        if IsValid( ePly ) then 
            ePly:SetModel( ePly.perma_model.model ) 
            if ePly.perma_model.bodygroups then ePly:SetBodyGroups( ePly.perma_model.bodygroups ) end

            SetHands( ePly )
        end
    end )
end )