#################################
###### Inverter Components ######
#################################

# Parameter Data for Outer Control is tuned for three VSM models to have 
# 2% P-ω pu/pu and 5% Q-v pu/pu droop steady state response.
# Metodology for tuning is based on the paper: B. Johnson et al, 
# "A generic primary-control model for grid-forming inverters:
# Towards interoperable operation & control" in HICCS 2022.

# Parameter Data for Inner Controllers and Filters are taken from
# S. D'Arco, J.A. Suul and O.B. Fosso, " A virtual synchronous
# machine implementation for distributed control of power converters
# in smartgrids", Electric Power Systems Research, 2015.

######## Outer Controls #########

# Droop Controller
function outer_control_droop()
    function active_droop()
        return PSY.ActivePowerDroop(Rp = 0.02, ωz = 2 * pi * 20)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.05, ωf = 2 * pi * 20)
    end
    return OuterControl(active_droop(), reactive_droop(), Dict{String,Any}("is_not_reference" => 0.0))
end

# VSM
function outer_control_vsm()
    function virtual_inertia()
        return VirtualInertia(Ta = 0.397887, kd = 0.0, kω = 50.0)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.05, ωf = 2 * pi * 20)
    end
    return OuterControl(virtual_inertia(), reactive_droop())
end

# VOC
function outer_control_voc()
    function active_voc()
        return PSY.ActiveVirtualOscillator(k1 = 0.02*1.0, ψ = pi / 4)
    end
    function reactive_voc()
        return PSY.ReactiveVirtualOscillator(k2 = 0.4 * 1.0)
    end
    return OuterControl(active_voc(), reactive_voc(), Dict{String,Any}("is_not_reference" => 0.0))
end

######## Inner Controls #########
inner_control() = VoltageModeControl(
    kpv = 0.59,     #Voltage controller proportional gain
    kiv = 736.0,    #Voltage controller integral gain
    kffv = 0.0,     #Binary variable enabling the voltage feed-forward in output of current controllers
    rv = 0.0,       #Virtual resistance in pu
    lv = 0.2,       #Virtual inductance in pu
    kpc = 1.27,     #Current controller proportional gain
    kic = 14.3,     #Current controller integral gain
    kffi = 0.0,     #Binary variable enabling the current feed-forward in output of current controllers
    ωad = 50.0,     #Active damping low pass filter cut-off frequency
    kad = 0.2,      #Active damping gain
)

######## PLL Data ########
no_pll() = PSY.FixedFrequency()

######## Filter Data ########
filt() = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01)
filt_no_dynamics() = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01, ext = Dict{String,Any}("is_filter_differential" => 0.0))
filt_voc() = LCLFilter(lf = 0.0196, rf = 0.0139, cf = 0.1086, lg = 0.0196, rg = 0.0139)

####### DC Source Data #########
stiff_source() = FixedDCSource(voltage = 690.0)

####### Converter Model #########
average_converter() = AverageConverter(rated_voltage = 690.0, rated_current = 9999.0)


#################################
##### Inverter Constructors #####
#################################

# VSM
function inv_vsm(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_vsm(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt(), # filter
    ) 
end

function inv_vsm_nodyn(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_vsm(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt_no_dynamics(), # filter
    ) 
end

# Droop 
function inv_droop(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_droop(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt(), # filter
    ) 
end

function inv_droop_nodyn(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_droop(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt_no_dynamics(), # filter
    ) 
end

# VOC
function inv_voc(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_voc(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt(),
        #filt_voc(), # filter
    ) 
end

function inv_voc_nodyn(static_device)
    return PSY.DynamicInverter(
        get_name(static_device), # name
        1.0, #ω_ref
        average_converter(), # converter
        outer_control_voc(), # outer control
        inner_control(), # inner control
        stiff_source(), # dc source
        no_pll(), # pll
        filt_no_dynamics(),
        #filt_voc(), # filter
    ) 
end