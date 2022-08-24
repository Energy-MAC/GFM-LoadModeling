#################################
##### Generator Components ######
#################################

GENROU_ex() = RoundRotorQuadratic(
    R = 0.0,
    Td0_p = 8.0,
    Td0_pp = 0.03,
    Tq0_p = 0.4,
    Tq0_pp = 0.05,
    Xd = 1.8,
    Xq = 1.7,
    Xd_p = 0.3,
    Xq_p = 0.55,
    Xd_pp = 0.25,
    Xl = 0.2,
    Se = (0.0, 1.0),
)
shaft_ex() = SingleMass(
    H = 6.175,
    D = 0.05,
)

avr_sexs() = SEXS(
    Ta_Tb = 0.4,
    Tb = 5.0,
    K = 20.0,
    Te = 1.0,
    V_lim = (-999.0, 999.0)
)
tg_tgov1() = SteamTurbineGov1(
    R = 0.05,
    T1 = 0.2,
    valve_position_limits = (-999.0, 999.0),
    T2 = 0.3,
    T3 = 0.8,
    D_T = 0.0,
    DB_h = 0.0,
    DB_l = 0.0,
    T_rate = 0.0
)
pss_none() = PSSFixed(0.0)

#################################
##### Generator Constructor #####
#################################

function dyn_genrou(gen)
    return PSY.DynamicGenerator(
        name = get_name(gen),
        ω_ref = 1.0,
        machine = GENROU_ex(), 
        shaft = shaft_ex(), 
        avr = avr_sexs(), 
        prime_mover = tg_tgov1(), 
        pss = pss_none(), 
    )
end