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

# Construct Systems Dictionary
sys_dict = Dict()
sys_static = get_static_system()
sys_dict["Genrou"] = get_genrou_system()
sys_dict["VSM"] = get_vsm_system_nodyn()
sys_dict["Droop"] = get_droop_system_nodyn()
sys_dict["dVOC"] = get_voc_system_nodyn()

# Results Dictionaries
stable_dict_p = Dict()
for k in keys(sys_dict)
    stable_dict_p[k] = Vector{Bool}()
end
status_dict_p = Dict()
for k in keys(sys_dict)
    status_dict_p[k] = Vector{Bool}()
end
eigen_dict = Dict()

# Power Range
P_range = 0:0.01:4.5
load_pf = 1.0

# PV Curve Results
P_load_p = Vector{Float64}()
V_load_p = Vector{Float64}()

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
    push!(V_load_p, Vm)
    push!(P_load_p, power)

    for (key, sys) in sys_dict
        # Update Load Power
        @show power
        load = get_component(PSY.ExponentialLoad, sys, "load1021")
        set_active_power!(load, power)
        q_power = power * tan(acos(load_pf))
        set_reactive_power!(load, q_power)
        # Run Small Signal Stability
        if (key == "Genrou") || (key == "VSM")
            sim = Simulation(ResidualModel, sys, pwd(), (0.0, 1.0))
        else
            sim = Simulation(ResidualModel, sys, pwd(), (0.0, 1.0), frequency_reference = ConstantFrequency)
        end
        if sim.status == PSID.BUILT
            sm = small_signal_analysis(sim).stable
            # Push results
            push!(stable_dict_p[key], sm)
            push!(status_dict_p[key], true)
        else
            push!(status_dict_p[key, false])
        end
    end
end

# Find where is stable and unstable
dict_true_ixs_p = Dict()
dict_false_ixs_p = Dict()
for k in keys(sys_dict)
    dict_true_ixs_p[k] = findall(x->x, stable_dict_p[k])
    dict_false_ixs_p[k] = findall(x->!x, stable_dict_p[k])
end

# Plots separated
for k in keys(sys_dict)
    true_ixs = dict_true_ixs_p[k]
    plot(P_load_p, V_load_p, color = :blue, label = "PV Curve", xlabel = "Load Power [pu]", ylabel = "Load Bus Voltage [pu]")
    display(Plots.scatter!(P_load_p[true_ixs] , V_load_p[true_ixs], markerstrokewidth= 0, label = k))
    savefig("results/PV_Curves/QSP_CPL/$(k)_PV.png")
end

# Paper Figure
plot(P_load_p, V_load_p, label = "PV Curve", xlabel = "Load Power [pu]", ylabel = "Load Bus Voltage [pu]", color = :black)
genrou_ixs = dict_true_ixs_p["Genrou"]
droop_ixs = dict_true_ixs_p["Droop"]
display(scatter!(P_load_p[genrou_ixs] , V_load_p[genrou_ixs], markerstrokewidth= 0, label = "GENROU", markersize = 4, color = :blue))
display(scatter!(P_load_p[droop_ixs] , V_load_p[droop_ixs], markerstrokewidth= 0, label = "Droop/VSM", markersize = 2,
                xticks = 0:0.5:5, markershape = :circle, color = :red, size = (600, 300)))
savefig("results/PV_Curves/QSP_CPL/Paper_QSP_PV.png")
    
