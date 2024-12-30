Ambi.General.CreateModule( 'Territory' )

Ambi.Territory.Config.removed_classes = {
    [ 'prop_physics' ] = true,
    [ 'prop_custom' ] = true,
    [ 'survival_build' ] = true,
    [ 'sinv_storage' ] = true,
    [ 'survival_build_oil_pumper' ] = true,
    [ 'survival_build_sleeping_bag' ] = true,
}
Ambi.Territory.Config.chunks = Ambi.Territory.Config.chunks or {}