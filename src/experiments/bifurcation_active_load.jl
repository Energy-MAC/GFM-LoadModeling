const PSID = PowerSimulationsDynamics
using OrdinaryDiffEq

P_critical_genrou = 1.0745
#P_critical_genrou = 1.1689 * 1.0 # Static Lines
#P_critical_genrou = 0.5 * 1.0 # Dyn Lines
sys = sys_dict["machine"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_genrou)
q = P_critical_genrou * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)

## Stable Cycle

pert_state = PSID.ModifyState(1.0, 9, 0.01)
#pert_state = PSID.ModifyState(1.0, 5, -0.01)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 40.0), pert_state, all_lines_dynamic = true)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)

dic = sm.participation_factors["generator-101-1"]

#for (k,v) in dic
#    println(k)
#    println(v)
#end

execute!(sim, Rodas4(), abstol = 1e-7, reltol=1e-7)
results = read_results(sim)

t, eq_p = get_state_series(results, ("generator-101-1", :eq_p))
t, Vf = get_state_series(results, ("generator-101-1", :Vf))
plot(eq_p, Vf, xlabel = "eq_p", ylabel = "E_fd",linewidth = 2)


# Droop

P_critical_voc = 1.458#1.0#1.4580 # Droop
sys = sys_dict["droop"]
#P_critical_voc = 1.429 # VOC
#sys = sys_dict["voc"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_voc)
q = P_critical_voc * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)
pert_state = PSID.ModifyState(0.1, 25, 0.005)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 0.4), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
#dic = sm.participation_factors["generator-101-1"]
#dic2 = sm.participation_factors["load1021"]
#for (k,v) in dic2
#    println(k)
#    println(v)
#end

execute!(sim, Rodas5(), abstol = 1e-8, reltol=1e-8)
results = read_results(sim)

t, v_dc = get_state_series(results, ("load1021", :v_dc))
t, η = get_state_series(results, ("load1021", :η))
plot(v_dc, η, xlabel = "v_dc", ylabel = "η",linewidth = 2, color = :blue)


pert_state = PSID.ModifyState(0.1, 25, 0.001)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 0.2), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]
dic2 = sm.participation_factors["load1021"]
#for (k,v) in dic2
#    println(k)
#    println(v)
#end

execute!(sim, Rodas5(), abstol = 1e-8, reltol=1e-8)
results = read_results(sim)

t2, v_dc2 = get_state_series(results, ("load1021", :v_dc))
t2, η2 = get_state_series(results, ("load1021", :η))
plot!(v_dc2, η2, xlabel = "v_dc", ylabel = "η",linewidth = 2, color = :red)


pert_state = PSID.ModifyState(0.1, 25, 0.005)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 0.3), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]
dic2 = sm.participation_factors["load1021"]
#for (k,v) in dic2
#    println(k)
#    println(v)
#end

execute!(sim, Rodas5(), abstol = 1e-8, reltol=1e-8)
results = read_results(sim)

t3, v_dc3 = get_state_series(results, ("load1021", :v_dc))
t3, η3 = get_state_series(results, ("load1021", :η))
plot!(v_dc3, η3, xlabel = "v_dc", ylabel = "η",linewidth = 2, color = :green)


