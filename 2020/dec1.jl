#=
Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

For example, suppose your expense report contained the following:

1721
979
366
299
675
1456
In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.
=#
using CSV
using DelimitedFiles

data = readdlm("inputs/dec1-1_input.csv", '\n', Float64)

# Just do an exhaustive search
function find_combination(data, value)
    loops = count
    for i in data
        for j in data
            if i+j == value
                return i, j
            end
        end
    end
    println("Failed to find values")
    return 0,0
end

val1, val2 = find_combination(data, 2020)
println("Two entries are ", val1, " and ", val2)
println("Multiplying them gives: ", val1 * val2)

#= Output:
Two entries are 16.0 and 2004.0
Multiplying them gives: 32064.0
=#

#= 
--- Part Two ---
The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?
=# 


# Since I'm a bit time strapped today, I'll just do the exhaustive method since the list of values is short
# This is a pretty ungeneralizable and ugly solution though
# A nicer way to make this generic would be to pass a count of elements to find the sum
function find_combination_three(data, value)
    for i in data
        for j in data
            for k in data
                if i+j+k == value
                    return i, j, k
                end
            end
        end
    end
    println("Failed to find values")
    return 0,0,0
end

val1, val2, val3 = find_combination_three(data, 2020)
println("Three entries are ", val1, ", ", val2, ", ", val3)
println("Multiplying them gives: ", BigInt(val1 * val2 * val3))

#=
Three entries are 248.0, 820.0, 952.0
Multiplying them gives: 193598720
=#