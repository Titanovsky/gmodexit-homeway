hook.Add( '[Ambi.DarkRP.CanSetJob]', 'Ambi.Homeway.PriviligeBlock', function( ePly, _, _, tJob ) 
    if tJob.is_vip and not ePly:IsVIP() then ePly:Notify( 'Вам нужна VIP (F6)', 5, NOTIFY_ERROR ) return false end
    if tJob.is_premium and not ePly:IsPremium() then ePly:Notify( 'Вам нужен Premium (F6)', 5, NOTIFY_ERROR ) return false end
end )