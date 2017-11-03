include("types.jl")

function _selectInfeasableVariable(model::JuMP.Model)
  indexVariables = collect(1:model.numCols)
  selection = [model.colCat .== :Bin  model.colVal .!= 0  model.colVal .!= 1]
  for row = 1 : size(selection, 1)
    if prod(selection[row, :])
      return indexVariables[row]
    end
  end
  return 0
end

function _branch(model::JuMP.Model, problem_head::head)
  # find one variable which breaks feasability
  indVariable = _selectInfeasableVariable(model)
  if ind == 0
    return false  # No branch necessary

  # creates 2 corresponding juMP models breaking the feasable reagion in 2
  leftChild = copy(model)
  leftChild.colUpper[indVariable] = 0
  leftChild.colLower[indVariable] = 0

  rightChild = copy(model)
  rightChild.colUpper[indVariable] = 1
  rightChild.colLower[indVariable] = 1

  # Adds the 2 problems to the problem_list
  enqueue!(problem_list, leftChild)
  enqueue!(problem_list, rightChild)

  return true  # branch completed successfully
end

function _bound(model::JuMP.Model, problem_head::head)
  # solve relaxation
  status = solve(model, relaxation=true)

    # bound by infeasability
  if satus == :Infeasible
    return false  #No branch needed

    # bound by optimality
  elseif satus == :Optimal && _selectInfeasableVariable(model) == 0
    return false  #No branch needed
    problem_head.best_solution = model # update best solution

    # bound by limits
  elseif  problem_head.best_solution.status != :NotSolved && getobjectivevalue(problem_head.best_solution) >  getobjectivevalue(model)
    return false  #No branch needed
  end
    
  return true
end

function _branch_and_bound(problem_head::head)
  maxiter = 25
  # start loop

    # select
    model = dequeue!(problem_head.problem_list)

    # solve relaxation and bound
    shouldBranch = _bound(model, problem_head)

    # branch and add problems to list (if needded)
    if shouldBranch
      _branch(model, problem_head)
    end

  # end loop

  # return

end

function solveMIP(m::JuMP.Model)
  # initialize
  problem_list = Queue(JuMP.Model)
  enqueue!(problem_list, copy(m))
  treehead = head(problem_list, m, m)

  # branch and bound
  _branch_and_bound(treehead)

end
