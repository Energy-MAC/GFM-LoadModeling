using PowerSystems

include("data/generator_data.jl")
include("data/inverter_data.jl")
raw_file = "data/OMIB_Load.raw"

##############################
#### System Constructors #####
##############################

function get_static_system()
    return System(raw_file)
end

function get_genrou_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = dyn_genrou(gen)
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

function get_droop_system()
    sys = get_static_system()
    gen = get_component(ThermalStandard, sys, "generator-101-1")
    dyn_device = inv_droop(gen)
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


