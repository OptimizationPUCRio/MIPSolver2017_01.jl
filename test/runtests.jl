using Gurobi
include("../../MIPTests.jl/miptests.jl")
include("../scr/branch_and_bound.jl")  # temporario antes da criacao do modulo


test3(solveMIP, GurobiSolver())
