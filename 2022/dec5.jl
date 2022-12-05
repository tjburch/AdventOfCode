# Day 5: Fail.

# Text: https://adventofcode.com/2022/day/5

input = readlines("2022/inputs/dec5-input.txt")
br = argmax(input .== "")
crates, instructions = input[1:br-1], input[br+1:end]

crate_line_to_arr(crates) = crates[2:4:end]
crate_arrays = crate_line_to_arr.(crates)[1:end-1]  # drop of 1-9 

# Convert to stacks
stacks = Vector{Union{String,Missing}}(missing, 9)
for i in range(1, 9)
    stacks[i] = getindex.(crate_arrays, i)|> join
end


instructions_to_arr(inst) = parse.(Int, split(inst, " ")[2:2:end])
instruction_arrs = instructions_to_arr.(instructions)


function execute_instruction(inst, stacks)

    n = inst[1]
    i_from = inst[2]
    i_to = inst[3]

    crates_to_move(n, stack) = lstrip(stack)[1:n]
    crates_to_move = crates_to_move(n, stacks[i_from])
    
    for t in crates_to_move
        stacks[i_from] = replace(stacks[i_from], t=>" ", count=1)
    end

    crates_to_move = reverse(crates_to_move)
   
    stacks[i_to] =  crates_to_move * lstrip(stacks[i_to])
    while length(stacks[i_to]) < 8
        stacks[i_to] = " " * stacks[i_to]
    end
    return stacks
end

solved_stacks = deepcopy(stacks)
for inst in instruction_arrs
    solved_stacks = execute_instruction(inst, solved_stacks)
end