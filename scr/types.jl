using JuMP

mutable struct head
  problem_list
  best_solution
  relaxarion
  model::JuMP.Model
  int_variables
  bin_variables
end

mutable struct node
  relaxarion
  model::JuMP.Model
end
