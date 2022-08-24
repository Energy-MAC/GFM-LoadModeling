#########################
### Induction Machine ###
#########################

Ind_Motor(load) = SingleCageInductionMachine(
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