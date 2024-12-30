local C = Ambi.General.Global.Colors

Ambi.ESP.gps_points = Ambi.ESP.gps_points or {}

function Ambi.ESP.Add( sName, sHeader, sDescription, vPos, cColor, sImage )
    if not sHeader or not sName then return end
    if not cColor then cColor = C.ABS_WHITE end

    Ambi.ESP.gps_points[ sName ] = {
        header = sHeader,
        desc = sDescription or '',
        pos = vPos or Vector( 0, 0, 0 ),
        image = sImage and Material( sImage ) or nil,
        color = { 
            r = cColor.r or 0, 
            g = cColor.g or 0, 
            b = cColor.b or 0,
            a = cColor.a or 0, 
        }
    }

    if CLIENT then concommand.Add( 'ambi_esp_gps_'..sName, function() Ambi.ESP.SetPoint( sHeader, vPos, sImage, cColor ) end ) end
end