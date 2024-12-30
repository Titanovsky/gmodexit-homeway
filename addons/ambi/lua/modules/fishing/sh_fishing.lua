function AMB.Fishing.AddBait( sBait, sDescription, tRandTime, sModel, nScale, sMaterial, cColor, fAction )
    AMB.Fishing.baites[ string.lower( tostring( sBait ) ) ] = {
        desc = sDescription or '',
        model = sModel,
        time = tRandTime,
        scale = nScale or 1,
        mat = sMaterial or '',
        color = cColor,
        action = fAction
    }
end

function AMB.Fishing.GetBait( sBait )
    return AMB.Fishing.baites[ string.lower( tostring( sBait ) ) ]
end