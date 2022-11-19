const PSID = PowerSimulationsDynamics
using OrdinaryDiffEq

####################################
##### Bifurcation for Marconato ####
####################################

P_critical_machine = 0.689
sys = sys_dict["Marconato"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_machine)
q = P_critical_machine * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)

## Unstable Cycle

pert_state = PSID.PerturbState(1.0, 9, 0.05)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 30.0), pert_state, all_lines_dynamic = true)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]

execute!(sim, Rodas4(), abstol = 1e-8, reltol=1e-8)
results = read_results(sim)

t, eq_p = get_state_series(results, ("generator-101-1", :eq_p))
t, Vf = get_state_series(results, ("generator-101-1", :Vf))
plot(eq_p, Vf, xlabel = "eq_p", ylabel = "E_fd",linewidth = 2)


####################################
####### Bifurcation for dVOC #######
####################################

#P_critical_voc = 1.015 # Droop
P_critical_voc = 1.049
sys = sys_dict["dVOC"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_voc)
q = P_critical_voc * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)
pert_state = PSID.PerturbState(1.0, 23, 0.2)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 10.35), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency)
sm = small_signal_analysis(sim)   
println(sm.eigenvalues)
dic = sm.participation_factors["generator-101-1"]
dic2 = sm.participation_factors["load1021"]