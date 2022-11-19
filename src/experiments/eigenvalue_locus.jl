using Plots
using DelimitedFiles

M = readdlm("src/data/eig_data.csv", ',', header=false)
re_eig = M[2:end, 1]
im_eig = M[2:end, 2]

scatter(re_eig, im_eig, marker = 3,legend = :none, color=:yellow, markerstrokewidth = 0.1, xlim = [-25, 25], size = (600,250), xticks = -20:5:20, xlabel = "Re[λ]",ylabel="Im[λ]")
#savefig("results/ZIP_eigenvalues_locus.png")