include("data/load_data.jl")

function change_load_power!(sys::System, p_change::Float64, power_factor::Float64)
    load = first(get_components(PowerLoad, sys))
    set_active_power!(load, p_change)
    q_change = p_change * tan(acos(power_factor))
    set_reactive_power!(load, q_change)
end

function change_load_model!(sys::System, model)
    load = first(get_components(PowerLoad, sys))
    set_model!(load, model)
end

function attach_3rd_induction_motor!(sys::System)
    load = first(get_components(PowerLoad, sys))
    ind_motor = Ind_Motor3rd(load)
    add_component!(sys, ind_motor, load)
end

function attach_5th_induction_motor!(sys::System)
    load = first(get_components(PowerLoad, sys))
    ind_motor = Ind_Motor(load)
    add_component!(sys, ind_motor, load)
end
