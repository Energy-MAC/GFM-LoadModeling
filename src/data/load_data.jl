#########################
### Induction Machine ###
#########################

# Parameters are taken from typical per-unit parameters
# of Single Cage Induction Machine Motors provided in Lecture
# Notes ELEC0047: Power System Dynamics, Control and Stability
# by professor Thierry Van Cutsem from University of Liège
# Link: https://thierryvancutsem.github.io/home/elec0047/dyn_of_ind_mac.pdf

Ind_Motor(load) = SingleCageInductionMachine(
    name = PSY.get_name(load),
    R_s = 0.013,
    R_r = 0.009,
    X_ls = 0.067,
    X_lr = 0.17,
    X_m = 3.8,
    H = 1.5,
    A = 0.0,
    B = 1.0, # Torque linearly proportional to speed.
    base_power = 100.0,
)

Ind_Motor3rd(load) = SimplifiedSingleCageInductionMachine(
    name = PSY.get_name(load),
    R_s = 0.013,
    R_r = 0.009,
    X_ls = 0.067,
    X_lr = 0.17,
    X_m = 3.8,
    H = 1.5,
    A = 0.0,
    B = 1.0,
    base_power = 100.0,
)


# Parameters taken from active load model from N. Bottrell Masters
# Thesis "Small-Signal Analysis of Active Loads and Large-signal Analysis
# of Faults in Inverter Interfaced Microgrid Applications", 2014.

# The parameters are then per-unitized to be scalable to represent an aggregation
# of multiple active loads

# Base AC Voltage: Vb = 380 V
# Base Power (AC and DC): Pb = 10000 VA
# Base AC Current: Ib = 10000 / 380 = 26.32 A
# Base AC Impedance: Zb = 380 / 26.32 =  14.44 Ω
# Base AC Inductance: Lb = Zb / Ωb = 14.44 / 377 = 0.3831 H
# Base AC Capacitance: Cb = 1 / (Zb * Ωb) = 0.000183697 F
# Base DC Voltage: Vb_dc = (√8/√3) Vb = 620.54 V
# Base DC Current: Ib_dc = Pb / V_dc = 10000/620.54 = 16.12 A
# Base DC Impedance: Zb_dc = Vb_dc / Ib_dc = 38.50 Ω
# Base DC Capacitance: Cb_dc = 1 / (Zb_dc * Ωb) = 6.8886315e-5 F

Ωb = 2*pi*60
Vb = 380
Pb = 10000
Ib = Pb / Vb
Zb = Vb / Ib
Lb = Zb / Ωb
Cb = 1 / (Zb * Ωb)
Vb_dc = sqrt(8)/sqrt(3) * Vb
Ib_dc = Pb / Vb_dc
Zb_dc = Vb_dc / Ib_dc
Cb_dc = 1/(Zb_dc * Ωb)

function active_cpl(load)
    return PSY.ActiveConstantPowerLoad(
        name = get_name(load),
        r_load = 70.0 / Zb_dc,
        c_dc = 2040e-6 / Cb_dc,
        rf = 0.1 / Zb,
        lf = 2.3e-3 / Lb,
        cf = 8.8e-6 / Cb,
        rg = 0.03 / Zb,
        lg = 0.93e-3 / Lb,
        kp_pll = 0.4,
        ki_pll = 4.69,
        kpv = 0.5 * (Vb_dc / Ib_dc),
        kiv = 150.0 * (Vb_dc / Ib_dc),
        kpc = 15.0 * (Ib / Vb),
        kic = 30000.0 * (Ib / Vb),
        base_power = 100.0,
    )
end