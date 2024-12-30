local function Check()
    return true
end

local function ToggleThirdView()
    if not Check() then return end

    if Ambi.Homeway.view3d then hook.Remove( 'CalcView', 'Ambi.Homeway.ThirdView' ) Ambi.Homeway.view3d = false return end

    hook.Add( 'CalcView', 'Ambi.Homeway.ThirdView', function( ePly, vOrigin, nAng, nFov ) 
        local targetPos = vOrigin - (nAng:Forward() * 70) - (nAng:Right() * -20)
    
        local traceData = {
            start = vOrigin,
            endpos = vOrigin - (nAng:Forward() * 80) - (nAng:Right() * -30),
            filter = ePly
        }

        local tr = util.TraceLine(traceData)

        -- Корректируем позицию, если есть препятствие
        if tr.Hit then
            targetPos = tr.HitPos + tr.HitNormal * 10 -- Сдвигаем немного вперед от стены
        end

        local view = {
            origin = targetPos,
            angles = nAng,
            fov = nFov,
            drawviewer = true
        }

        return view
    end )

    Ambi.Homeway.view3d = true
end
concommand.Add( 'ambi_hw_third_view', ToggleThirdView )

hook.Add( 'Think', 'Ambi.Homeway.Toggle3DView', function()
    if not input.IsKeyDown( KEY_F7 ) then return end
    if timer.Exists( '3dperson_key' ) then return end
    timer.Create( '3dperson_key', 0.25, 1, function() end )

    ToggleThirdView()
end )