local SKYBOXES_TYPES = { 'lf', 'ft', 'rt', 'bk', 'dn', 'up' }

local function ChangeSkyboxOnBangclaw( sNewSkybox )
    for _, side in ipairs( SKYBOXES_TYPES ) do
        Material( 'skybox/militia_hdr'..side ):SetTexture( '$basetexture', 'ambi/homeway/skybox/'..sNewSkybox..side )
    end
end

function Ambi.Homeway.Retexture()
    local default_road = 'ambi/amp/amp_road2'
    Material( 'maps/rp_bangclaw_test22222/concrete/concretefloor033k_c17_3224_-2651_560' ):SetTexture( '$basetexture', default_road )
    Material( 'maps/rp_bangclaw_test22222/concrete/concretefloor033a_3224_-2651_560' ):SetTexture( '$basetexture', default_road )
    Material( 'maps/rp_bangclaw_test22222/concrete/concretefloor033o_3224_-2651_560' ):SetTexture( '$basetexture', default_road )
    Material( 'maps/rp_bangclaw_test22222/concrete/concretefloor033k_c17_3208_509_-488' ):SetTexture( '$basetexture', default_road )
    Material( 'CONCRETE/CONCRETEFLOOR023A' ):SetTexture( '$basetexture', 'ambi/amp/amp_tile_high1' )
    Material( 'BRICK/BRICKWALL003D' ):SetTexture( '$basetexture', 'ambi/amp/amp_brick4' )

    local sand = 'ambi/homeway/list/sand1'
    Material( 'nature/blendrocksand008d' ):SetTexture( '$basetexture', sand )
    Material( 'maps/rp_bangclaw_test22222/nature/blendsandgrass008a_wvt_patch' ):SetTexture( '$basetexture', sand )

    local side = ''
    local time = GetGlobal2String( 'time_environment' )
    
    if ( time == 'night' ) then
        ChangeSkyboxOnBangclaw( 'sky_night01' )
    elseif ( time == 'dawn' ) then
        ChangeSkyboxOnBangclaw( 'sky_frommars' )
    elseif ( time == 'xmas' ) then
        ChangeSkyboxOnBangclaw( 'skynight' )
    elseif ( time == 'halloween' ) then
        ChangeSkyboxOnBangclaw( 'nei_6' )
    else
        ChangeSkyboxOnBangclaw( 'sky_gravity' )
    end

    Material( 'models/weapons/v_models/acw_welrod/welrod' ):SetTexture( '$basetexture', 'models/gonzo/weed/bong.vtf' )
end
concommand.Add( 'ambi_hw_retexture', Ambi.Homeway.Retexture )

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'InitPostEntity', 'Ambi.Homeway.Retexture', Ambi.Homeway.Retexture )