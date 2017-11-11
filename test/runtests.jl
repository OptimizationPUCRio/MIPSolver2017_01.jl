using Gurobi
include("../../MIPTests.jl/miptests.jl")
include("../scr/branch_and_bound.jl")  # temporario antes da criacao do modulo


test1(solveMIP, GurobiSolver())
test2(solveMIP, GurobiSolver())
test3(solveMIP, GurobiSolver())
testSudoku(solveMIP, GurobiSolver())
testInfeasibleKnapsack(solveMIP, GurobiSolver())
