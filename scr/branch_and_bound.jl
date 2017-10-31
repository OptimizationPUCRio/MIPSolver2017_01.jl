include("types.jl")


function branch(model::JuMP.Model, )
  # find one variable which breaks feasability

  # creates 2 corresponding juMP models breaking the feasable reagion in 2

  # returns the 2 models
  return
end

function bound(leaf::node, problem_head::head)
  # bound by infeasability

  # bound by optimality

    # update best solution
  # end bound opt

  # bound by limits

end

function branch_and_bound(problem_head::head)
# initialize

# loop

  # select

  # branch

  # solve relaxation

  # bound

  # add problem to list

#end loop

# return

end
