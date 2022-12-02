# Day 1:
# Sucess! Time elapsed = 9 minutes

# Text: https://adventofcode.com/2022/day/1

f = open("2022/inputs/dec1-input.txt")
lines = readlines(f)

total_elfs = sum(lines .== "") + 1
elfs = zeros(total_elfs)
i = 1
for l in lines
    if l != ""
        elfs[i] += parse(Int, l)
    else
        i += 1
    end
end

# Part 1
elfs |> maximum |> Int |> println

# Part 2
sort(elfs)[end-2:end] |> sum |> Int |> println