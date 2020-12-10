## Problem text: https://adventofcode.com/2020/day/10

using StatsBase

f = open("inputs/dec10-input.txt")
lines = readlines(f)

v = map(x->parse(Int, x), lines)
sorted_vals = sort(v)
reference_value = maximum(v) + 3;

# Add 0 and reference value
pushfirst!(sorted_vals, 0)
push!(sorted_vals, reference_value)

# Get differences
diffs = []
for (i, v) in enumerate(sorted_vals[1:end-1])
    push!(diffs, sorted_vals[i+1] - v)
end

vc = countmap(diffs)

# Part 1
println("Number of differences of 3: ", vc[3])
println("Number of differences of 1: ", vc[1])
println("Multiplied: ", vc[3] * vc[1])


combinations = zeros(Int, length(sorted_vals))
combinations[end] = 1  # know this one will be true a priori

# Count back from the second to last index
for i in (length(sorted_vals)-1):-1:1
    lcount = 0
    for j in 1:3 
        if i + j <= length(sorted_vals) && 1 <= sorted_vals[i + j] - sorted_vals[i] <= 3
            lcount += combinations[i+j]
        end
    end
    combinations[i] = lcount    
end

println("Total number of combinations: ", combinations[1])