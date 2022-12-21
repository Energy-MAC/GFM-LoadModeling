const PSID = PowerSimulationsDynamics

####################################
###### Bifurcation for GENROU ######
####################################

P_critical_genrou = 1.168922
sys = sys_dict["Genrou"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_genrou)
q = P_critical_genrou * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)

## Unstable Cycle

pert_state = PSID.PerturbState(1.0, 5, 0.05)

sim = Simulation(ResidualModel, sys, pwd(), (0.0, 7.0), pert_state)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]

execute!(sim, IDA(), abstol = 1e-9, reltol=1e-9)
results = read_results(sim)

t, eq_p = get_state_series(results, ("generator-101-1", :eq_p))
t, Vf = get_state_series(results, ("generator-101-1", :Vf))
plot(eq_p, Vf, xlabel = "eq_p", ylabel = "E_fd",linewidth = 2, label = "Shift 0.05")

## Limit Cycle
pert_state = PSID.PerturbState(1.0, 5, -0.01)

sim = Simulation(ResidualModel, sys, pwd(), (0.0, 50.0), pert_state)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]

execute!(sim, IDA(), abstol = 1e-9, reltol=1e-9)
results = read_results(sim)

t, eq_p2 = get_state_series(results, ("generator-101-1", :eq_p))
t, Vf2 = get_state_series(results, ("generator-101-1", :Vf))
plot!(eq_p2, Vf2, xlabel = "eq_p", ylabel = "E_fd", linewidth = 2, label = "Shift -0.01")

## Limit Cycle2
pert_state = PSID.PerturbState(1.0, 5, -0.005)

sim = Simulation(ResidualModel, sys, pwd(), (0.0, 100.0), pert_state)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]

execute!(sim, IDA(), abstol = 1e-9, reltol=1e-9)
results = read_results(sim)

t, eq_p3 = get_state_series(results, ("generator-101-1", :eq_p))
t, Vf3 = get_state_series(results, ("generator-101-1", :Vf))
plot!(eq_p3, Vf3, xlabel = "eq_p", ylabel = "E_fd", linewidth = 2, label = "Shift -0.005")
#savefig("results/Bifurcation/QSP_GENROU_LimitCycles.png")



####################################
###### Bifurcation for Droop #######
####################################

P_critical_voc = 1.2421 # First SIB
#P_critical_voc = 2.005 # Leaving SIB
sys = sys_dict["Droop"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_voc)
q = P_critical_voc * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)
pert_state = PSID.PerturbState(1.0, 7, -0.1)

sim = Simulation(ResidualModel, sys, pwd(), (0.0, 1.55), pert_state, frequency_reference = ConstantFrequency())
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]
