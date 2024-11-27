using Symbolics
using Plots

# Helper function to generate random symbolic variables
function random_symbol()
    @variables a b c d e f g h i j  # Define some symbolic variables
    return rand([a b c d e f g h i j])  
end

function two_random_symbol()
    @variables a b c d e f g h i j  # Define some symbolic variables
    range=Set([a b c d e f g h i j])
    rand1=rand(range)
    delete!(range,rand1)
    rand2=rand(range)
    return rand1,rand2
end

# Helper function to generate random operations
function random_operation(a, b)
    ops = [(+), (-), (*), (/), (^)] 
    op = rand(ops) 
    return op(a, b)
end

function special_operations(a)
    ops = [sin,cos,log,sqrt] 
    op = rand(ops) 
    return op(a)
end

# Function to generate random symbolic expressions
function random_expression(depth::Int = 3)
    if depth == 1
        return 
    else
        left_expr = rand([random_expression(depth - 1)])
        right_expr = rand([random_expression(depth - 1)])
        return random_operation(left_expr, right_expr)
    end
end

function random_expression_w_special(depth::Int = 3)
    if depth == 1
        a,b = two_random_symbol()
        return special_operations(random_operation(a,b))
    else
        left_expr = rand([random_expression_w_special(depth - 1)])
        right_expr = rand([random_expression_w_special(depth - 1)])
        return special_operations(random_operation(left_expr, right_expr))
    end
end


function sample_hashes(num_sample::Int, depth::Int)
    expressions = Set([random_expression_w_special(depth) for _ in 1:num_sample])  # Generate random expressions
    hashes = Set([hash(expr) for expr in expressions])  # Compute hash values
    return expressions, hashes
end

function sample_hashes_by_length(num_sample::Int, max_depth::Int)
    hashes=[]
    for d in 1:max_depth
        append!(hashes,sample_hashes(num_sample,d)[2])
    end
    return hashes
end

expr = random_expression_w_special(3)
println(expr)
println(hash(expr))



expressions, hashes = sample_hashes(10000,3)
@assert length(expressions) == length(hashes)
even = [h for h in hashes if h%2==0]
odd = [h for h in hashes if h%2==1]
print(length(even),length(odd))

scatter(1:10000, [h for h in hashes], xlabel="Expression #", ylabel="Hash Value", title="Hash Values by length",ms=1)