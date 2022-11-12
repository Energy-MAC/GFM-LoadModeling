include("data/load_data.jl")

function change_load_power!(sys::System, p_change::Float64, power_factor::Float64)
    load = first(get_components(StaticLoad, sys))
    set_active_power!(load, p_change)
    q_change = p_change * tan(acos(power_factor))
    set_reactive_power!(load, q_change)
end

"""
Function to change load coefficients of a exponential load of the form:
P + jQ = P0 * (V / V0)^α + jQ0 * (V / V0)^β

With α = β = 0.0 we get Constant Power load
With α = β = 1.0 we get Constant Current load
With α = β = 2.0 we get Constant Impedance load
"""
function change_load_coefficients!(sys::System, α::Float64, β::Float64)
    load = first(get_components(StaticLoad, sys))
    set_active_power_coefficient!(load, α)
    set_reactive_power_coefficient!(load, β)
end

function attach_3rd_induction_motor!(sys::System)
    load = first(get_components(StaticLoad, sys))
    ind_motor = Ind_Motor3rd(load)
    add_component!(sys, ind_motor, load)
end

function attach_5th_induction_motor!(sys::System)
    load = first(get_components(StaticLoad, sys))
    ind_motor = Ind_Motor(load)
    add_component!(sys, ind_motor, load)
end

function attach_active_cpl!(sys::System)
    load = first(get_components(StaticLoad, sys))
    dyn_load = active_cpl(load)
    add_component!(sys, dyn_load, load)
end