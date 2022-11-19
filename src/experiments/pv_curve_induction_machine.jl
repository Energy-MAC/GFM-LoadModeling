using Revise
using PowerSystems
using PowerSimulationsDynamics
using Sundials
using Plots
using PowerFlows
using Logging

const PSID = PowerSimulationsDynamics

# Disable Logging
Logging.disable_logging(Logging.Info) 
Logging.disable_logging(Logging.Warn) 


include("../system_constructor.jl")
include("../main_functions.jl")
gr()
# Sys Dicts
sys_dict = Dict()
sys_static = get_static_system()
sys_dict["Marconato"] = get_marconato_system()
sys_dict["VSM"] = get_vsm_system()
sys_dict["Droop"] = get_droop_system()
sys_dict["dVOC"] = get_voc_system()
attach_5th_induction_motor!(sys_dict["Marconato"])
attach_5th_induction_motor!(sys_dict["VSM"])
attach_5th_induction_motor!(sys_dict["Droop"])
attach_5th_induction_motor!(sys_dict["dVOC"])

# Results Dicts
stable_dict = Dict()
for k in keys(sys_dict)
    stable_dict[k] = Vector{Bool}()
end
status_dict = Dict()
for k in keys(sys_dict)
    status_dict[k] = Vector{Bool}()
end
eigen_dict = Dict()

# Power Range
P_range = 0:0.01:1.5
load_pf = 1.0

# PV Curve Results
P_load = Vector{Float64}()
V_load = Vector{Float64}()

# Main Loop: Constant Power
for p in P_range
    # Obtain PV Curve
    power = p * 1.0
    load = get_component(PSY.ExponentialLoad, sys_static, "load1021")
    set_active_power!(load, power)
    q_power = power * tan(acos(load_pf))
    set_reactive_power!(load, q_power)
    status = run_powerflow!(sys_static)
    if !status
        break
    end
    bus = get_component(Bus, sys_static, "BUS 2")
    Vm = get_magnitude(bus)
    push!(V_load, Vm)
    push!(P_load, power)

    for (key, sys) in sys_dict
        # Update Load Power
        @show power
        load = get_component(PSY.ExponentialLoad, sys, "load1021")
        set_active_power!(load, power)
        q_power = power * tan(acos(load_pf))
        set_reactive_power!(load, q_power)
        # Run Small Signal Stability
        if (key == "Marconato") || (key == "VSM")
            sim = Simulation(ResidualModel, sys, pwd(), (0.0, 1.0), all_lines_dynamic = true)
        else
            sim = Simulation(ResidualModel, sys, pwd(), (0.0, 1.0), all_lines_dynamic = true, frequency_reference = ConstantFrequency())
        end
        if sim.status == PSID.BUILT
            sm = small_signal_analysis(sim).stable
            # Push results
            push!(stable_dict[key], sm)
            push!(status_dict[key], true)
        else
            push!(status_dict[key, false])
        end
    end
end

dict_true_ixs = Dict()
for k in keys(sys_dict)
    dict_true_ixs[k] = findall(x->x, stable_dict[k])
end

# Plots separated
for k in keys(sys_dict)
    true_ixs = dict_true_ixs[k]
    plot(P_load, V_load, color = :blue, label = "PV Curve", xlabel = "Load Power [pu]", ylabel = "Load Bus Voltage [pu]")
    display(Plots.scatter!(P_load[true_ixs] , V_load[true_ixs], markerstrokewidth= 0, label = k))
    #savefig("results/PV_Curves/EMT_IM/$(k)_PV.png")
end

    
