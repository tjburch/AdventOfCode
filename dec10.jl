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
