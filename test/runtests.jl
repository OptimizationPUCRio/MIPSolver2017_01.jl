using Gurobi
include("../../MIPTests.jl/miptests.jl")
include("../scr/branch_and_bound.jl")  # temporario antes da criacao do modulo


test1(solveMIP, GurobiSolver())
test2(solveMIP, GurobiSolver())

testSudoku(solveMIP, GurobiSolver())
testInfeasibleKnapsack(solveMIP, GurobiSolver())

test_PL_Simples_Brito(solveMIP, GurobiSolver())
test_PL_Infeasible_Brito(solveMIP, GurobiSolver())
test_PL_Unbounded_Brito(solveMIP, GurobiSolver())
test_MIP_Minimal_Brito(solveMIP, GurobiSolver())
test_MIP_Pequeno_Brito(solveMIP, GurobiSolver())

test_P1_Brito(solveMIP, GurobiSolver())
testRobustCCUC(solveMIP, GurobiSolver())
testCaminho(solveMIP, GurobiSolver())

# My list
test3(solveMIP, GurobiSolver())
test3_2(solveMIP, GurobiSolver())
test3_3(solveMIP, GurobiSolver())
test_feature_selection_pequeno_viavel(solveMIP, GurobiSolver())
test_feature_selection_pequeno_inviavel(solveMIP, GurobiSolver())

test_feature_selection_medio(solveMIP, GurobiSolver())
test_feature_selection_grande(solveMIP, GurobiSolver())
