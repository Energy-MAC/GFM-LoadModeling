#################################
###### Inverter Components ######
#################################


######## Outer Controls #########

# Droop Controller
function outer_control_droop()
    function active_droop()
        return PSY.ActivePowerDroop(Rp = 0.05, ωz = 2 * pi * 5)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.2, ωf = 1000.0)
    end
    return OuterControl(active_droop(), reactive_droop())
end

# VSM
function outer_control_vsm()
    function virtual_inertia()
        return VirtualInertia(Ta = 2.0, kd = 0.0, kω = 20.0)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.2, ωf = 1000.0)
    end
    return OuterControl(virtual_inertia(), reactive_droop())
end

# VOC
function outer_control_voc()
    function active_voc()
        return PSY.ActiveVirtualOscillator(k1 = 0.0033, ψ = pi / 4)
    end
    function reactive_voc()
        return PSY.ReactiveVirtualOscillator(k2 = 0.0796)
    end
    return OuterControl(active_voc(), reactive_voc())
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
        filt_voc(), # filter
    ) 
end