using PowerSystems
const PSY = PowerSystems

include(joinpath(dirname(@__FILE__), "data/generator_data.jl"))
include(joinpath(dirname(@__FILE__), "data/inverter_data.jl"))
raw_file = joinpath(dirname(@__FILE__), "data/OMIB_Load.raw")

##############################
#### System Constructors #####
##############################

function get_static_system()
    sys_exp = System(raw_file)
    l = first(get_components(PowerLoad, sys_exp))
    exp_load = PSY.ExponentialLoad(
        name = get_name(l),
        available = get_available(l),
        bus = get_bus(l),
        active_power = get_active_power(l),
        reactive_power = get_reactive_power(l),
        active_power_coefficient = 0.0, # Constant Power
        reactive_power_coefficient = 0.0, # Constant Power
        base_power = get_base_power(l),
        max_active_power = get_max_active_power(l),
        max_reactive_power = get_max_reactive_power(l),
    )
    remove_component!(sys_exp, l)
    add_component!(sys_exp, exp_load)
    return sys_exp
end

function get_genrou_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = dyn_genrou(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_marconato_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = dyn_marconato(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_vsm_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_vsm(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end



function get_vsm_system_nodyn()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_vsm_nodyn(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_droop_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_droop(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_droop_system_nodyn()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_droop_nodyn(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_voc_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_voc(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

function get_voc_system_nodyn()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_voc_nodyn(gen)
    add_component!(sys, dyn_device, gen)
    return sys
end

