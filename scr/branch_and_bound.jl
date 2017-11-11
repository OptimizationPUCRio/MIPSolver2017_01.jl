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
  if indVariable == 0
    return false  # No branch necessary
  end
  # creates 2 corresponding juMP models breaking the feasable reagion in 2
  leftChild = deepcopy(model)
  leftChild.objBound = getobjectivevalue(model)
  leftChild.colUpper[indVariable] = 0
  leftChild.colLower[indVariable] = 0

  rightChild = deepcopy(model)
  rightChild.objBound = getobjectivevalue(model)
  rightChild.colUpper[indVariable] = 1
  rightChild.colLower[indVariable] = 1

  # Adds the 2 problems to the problem_list
  enqueue!(problem_head.problem_list, leftChild)
  enqueue!(problem_head.problem_list, rightChild)

  return true  # branch completed successfully
end

function _bound(model::JuMP.Model, problem_head::head)
  # solve relaxation
  status = solve(model, relaxation=true)

    # "bound" by unboundness of the original problem
  if status == :Unbounded
    return false,status  #No branch needed
  end
    # bound by infeasability
  if status == :Infeasible
    return false,status  #No branch needed

    # bound by optimality
  elseif status == :Optimal && _selectInfeasableVariable(model) == 0
      # update best solution if better
    if prod(isnan(problem_head.best_solution.colVal)) # MathProgBase.status(problem_head.best_solution.internalModel) == :NotSolved  # First feasable solution
      problem_head.best_solution = model
    elseif getobjectivesense(model) == :Max && getobjectivevalue(problem_head.best_solution) <  getobjectivevalue(model)
      problem_head.best_solution = model
    elseif getobjectivesense(model) == :Min && getobjectivevalue(problem_head.best_solution) >  getobjectivevalue(model)
      problem_head.best_solution = model
    end
    return false,status  #No branch needed

    # bound by limits
  elseif  getobjectivesense(model) == :Max && prod(isnan(problem_head.best_solution.colVal)) && getobjectivevalue(problem_head.best_solution) >  getobjectivevalue(model)
    return false,status  #No branch needed
  elseif  getobjectivesense(model) == :Min && prod(isnan(problem_head.best_solution.colVal)) && getobjectivevalue(problem_head.best_solution) <  getobjectivevalue(model)
    return false,status  #No branch needed
  end

  return true,status
end

function _update_bestbound(problem_head::head)
  if getobjectivesense(problem_head.model) == :Max
    bestupper = front(problem_head.problem_list).objBound
    for prob in problem_head.problem_list
      if prob.objBound > bestupper
        bestupper = prob.objBound
      end
    end
    problem_head.model.objBound = bestupper
  else
    bestlower = front(problem_head.problem_list).objBound
    for prob in problem_head.problem_list
      if prob.objBound < bestlower
        bestlower = prob.objBound
      end
    end
    problem_head.model.objBound = bestlower
  end
end

function _branch_and_bound(problem_head::head)
  maxiter = 25
  tol = 1E-07
  iter = 1
  ## First iteraction ##
  # select
  model = dequeue!(problem_head.problem_list)

  # solve relaxation and bound
  shouldBranch,status = _bound(model, problem_head)
  if status == :Unbounded
    return status
  elseif status == :Infeasible
    return status
  end
  # branch and add problems to list (if needded)
  if shouldBranch
    _branch(model, problem_head)
  end

  ## Branch and Bound Loop ##
  while !isempty(problem_head.problem_list) && iter <= maxiter  # start loop
    # stop condition:
    if problem_head.best_solution.ext[:status] != :NotSolved
      if abs(problem_head.model.objBound - problem_head.best_solution.objVal) < tol
        break
      end
    end

    # update bestbound
    _update_bestbound(problem_head)

    # select
    model = dequeue!(problem_head.problem_list)

    # solve relaxation and bound
    shouldBranch,status = _bound(model, problem_head)

    # branch and add problems to list (if needded)
    if shouldBranch
      _branch(model, problem_head)
    end
    iter = iter+1
  end # end loop

  # return status
  if iter > maxiter
    return :UserLimit
  end

  return :Optimal

end

function solveMIP(m::JuMP.Model)
  # initialize
  m.ext[:status] = :NotSolved
  problem_list = Queue(JuMP.Model)
  enqueue!(problem_list, deepcopy(m))
  treehead = head(problem_list, m, m)

  # branch and bound
  status = _branch_and_bound(treehead)

  if status == :Unbounded
    m.ext[:status] = :Unbounded
    return status
  elseif status == :Infeasible
    m.ext[:status] = :Infeasible
    return status
  elseif prod(isnan(treehead.best_solution.colVal))
    m.ext[:status] = :Infeasible
    return :Infeasible
  end

  # update solution on original model

  treehead.model.objVal = treehead.best_solution.objVal
  treehead.model.colVal = treehead.best_solution.colVal
  m.ext[:status] = status
  return status

end
