using Gurobi
include("../../MIPTests.jl/miptests.jl")

using andrewmipsolver


test1(solveMIP, GurobiSolver())
test2(solveMIP, GurobiSolver())

testSudoku(solveMIP, GurobiSolver())
testInfeasibleKnapsack(solveMIP, GurobiSolver())
testUnboundedKnapsack(solveMIP, GurobiSolver())
testInfeasibleUC(solveMIP, GurobiSolver())
test_PL_Simples_Raphael(solveMIP, GurobiSolver())
test_PL_Infeasible_Raphael(solveMIP, GurobiSolver())
test_Minimal_UC(solveMIP, GurobiSolver())
testSudoku4x4(solveMIP, GurobiSolver())

test_rv_1(solveMIP, GurobiSolver())
test_rv_2(solveMIP, GurobiSolver())
test_rv_3(solveMIP, GurobiSolver())
test_rv_4(solveMIP, GurobiSolver())
test_rv_5(solveMIP, GurobiSolver())
test_rv_6(solveMIP, GurobiSolver())
test_rv_7(solveMIP, GurobiSolver())
test_rv_8(solveMIP, GurobiSolver())
test_optimal_dispatch(solveMIP, GurobiSolver())

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
teste_PL_andrew_unbounded(solveMIP, GurobiSolver())
teste_PL_andrew_viavel(solveMIP, GurobiSolver())
teste_PL_andrew_inviavel(solveMIP, GurobiSolver())

test_feature_selection_medio(solveMIP, GurobiSolver())
test_feature_selection_grande(solveMIP, GurobiSolver())

test_P1_Andrew_Bianca_viavel(solveMIP, GurobiSolver())
