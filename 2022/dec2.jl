# Day 2:
# Sucess! Time elapsed = 24:54

# Text: https://adventofcode.com/2022/day/2

values = Dict(
    "X" => 1,
    "Y" => 2,
    "Z" => 3
)

lines = readlines("2022/inputs/dec2-input.txt")
pairs = split.(lines)

# Part 1:
win_pairs = [
    ["A", "Y"],
    ["B", "Z"],
    ["C", "X"]
]
tie_pairs = [
    ["A", "X"],
    ["B", "Y"],
    ["C", "Z"]
]

choice_score = map(x -> values[x[2]], pairs)
wins = map(x -> x in win_pairs, pairs)
win_score = wins * 6
ties = map(x -> x in tie_pairs, pairs)
tie_score = ties * 3

round_score = win_score .+ tie_score .+ choice_score
println(sum(round_score))


# Part 2
outcome_pairs = Dict(
    "X"=>0,
    "Y"=>3,
    "Z"=>6
)
loss_pairs = [
    ["A", "Z"],
    ["B", "X"],
    ["C", "Y"]
]
win_dict = Dict(x[1]=>x[2] for x in win_pairs)
tie_dict = Dict(x[1]=>x[2] for x in tie_pairs)
loss_dict = Dict(x[1]=>x[2] for x in loss_pairs)

outcome_score = map(x -> outcome_pairs[x[2]], pairs)

wins = map(x->x[2] .== "Z",pairs)
win_guess = map(x -> win_dict[x[1]], pairs[wins])

ties = map(x->x[2] .== "Y",pairs)
tie_guess = map(x -> tie_dict[x[1]], pairs[ties])

losses = map(x->x[2] .== "X",pairs)
loss_guess = map(x -> loss_dict[x[1]], pairs[losses])

all_guesses = vcat(win_guess, tie_guess, loss_guess)
guess_value = map(x -> values[x], all_guesses)

println(sum(outcome_score + guess_value))