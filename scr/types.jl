using JuMP
using DataStructures

mutable struct head
  problem_list::Queue(JuMP.Model)
  model::JuMP.Model
  best_solution::JuMP.Model
end

# mutable struct node
#   model::JuMP.Model
# end
