const PSID = PowerSimulationsDynamics
using OrdinaryDiffEq

####################################
###### Bifurcation for Droop #######
####################################

P_critical_voc = 1.458#1.0#1.4580 # Droop
sys = sys_dict["Droop"]
load = get_component(PSY.ExponentialLoad, sys, "load1021")
set_active_power!(load, P_critical_voc)
q = P_critical_voc * tan(acos(1.0))
set_reactive_power!(load, q)
status = run_powerflow!(sys)

# First Perturbation -0.0005
pert_state = PSID.PerturbState(0.1, 10, -0.0005)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 0.4), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency())
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

# Second Perturbation 0.001
pert_state = PSID.PerturbState(0.1, 10, 0.001)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 0.2), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency())
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

# Third Perturbation 0.005
pert_state = PSID.PerturbState(0.1, 10, 0.005)

sim = Simulation(MassMatrixModel, sys, pwd(), (0.0, 0.3), pert_state, all_lines_dynamic = true, frequency_reference = ConstantFrequency())
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
#savefig("results/Bifurcation/EMT_Droop_ActiveLoad_LimitCycles.png")

