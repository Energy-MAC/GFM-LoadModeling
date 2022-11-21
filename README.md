# Small-Signal Stability of Load and Network Dynamics on Grid-Forming Inverters

This repository contains the Julia code used in the paper: R. Henriquez-Auba, J. D. Lara and D. S. Callaway, "Small-Signal Stability of Load and Network Dynamics on Grid-Forming Inverters", submitted to the IEEE Power and Energy General Meeting (IEEE PES-GM), 2023.

The code is organized in different scripts that allow to replicate te results obtained in the paper. The results and figures are already available in the results folder, and the code replicates such figures.

The user must run Julia in this project environment to ensure correct versions of each package used. It is recommended to use Julia 1.8 or more.


## Data Used

Static data for the system is available in the PTI Format in the file `src/data/OMIB_Load.raw`. Synchronous machine dynamic model parameters are available in `src/data/generator_data.jl`, while grid-forming dynamic model parameters are available in `src/data/inverter_data.jl`. Finally, load data parameters are available in `src/data/load_data.jl`.

## Dynamic Models

All dynamic model differential equations can be found in the [Documentation of PowerSimulationsDynamics.jl](https://nrel-siip.github.io/PowerSimulationsDynamics.jl/stable/).

### Quasi-Static Phasor (QSP) Power-Voltage (P-V) curves for Constant Power Loads

Results for Section III.A can be replicated by running the file `src/experiments/pv_curve_CPL.jl` for the P-V curve in Figure 3-(a). Bifurcation cases are available in `src/experiments/bifurcation_CPL.jl`.

### Electromagnetic Transients (EMT) P-V curves for ZIP and Induction Machines

Results for Section III.B can be obtained by running the file `src/experiments/pv_curve_CCL_CIL.jl` for Constant Current and Constant Impedance load models. Induction machine P-V curves are obtained by running the file `src/experiments/pv_curve_induction_machine.jl`. Bifurcation cases for the induction machine are presented in `src/experiments/bifucation_induction_machine.jl`.

### EMT P-V curves for Active Load

Results for Secttion III.C can be replicated by running `src/experiments/pv_curve_active_load.jl` for the P-V curve in Figure 3-(b). The bifurcation case showcased in Figure 4 can be replicated running the file `src/experiments/bifurcation_active_load.jl`.

## Symbolic Analysis

The Symbolic Analysis for Constant Power Loads is done in Python and Sympy using Jupyter-Notebook. The notebook is located in `SymbolicZIP/simpy.ipynb`. It showcased the Constant Power Load case and the solution for the system of equations presented in Section IV. Figure 5 is also obtained in the Notebook.