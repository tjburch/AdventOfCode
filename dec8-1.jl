
f = open("inputs/dec8-input.txt")

f_parse = function parse_instruction(line)
    operation, value = split(line)
    value = parse(Int, value)
    return operation, value
end

mutable struct Instruction
    operation::String
    value::Int
    completed::Bool
end

function run_prog(instruction_list)
    index = 1
    accumulation = 0
    finished = false
    # Check if instruction completed
    while finished != true
        # if this instruction is done already, set termination
        if instruction_list[index].completed == true
            finished = true
        # if this is an accumulate, add that value
        elseif instruction_list[index].operation == "acc"
            accumulation += instruction_list[index].value
            instruction_list[index].completed = true
            index +=1
        elseif instruction_list[index].operation == "jmp"
            instruction_list[index].completed = true
            index += instruction_list[index].value
        elseif instruction_list[index].operation == "nop"
            instruction_list[index].completed = true
            index +=1
        end


    end
    return accumulation
end


lines = readlines(f)

instruction_values = map(f_parse, lines)
instruction_list = []
for i in instruction_values
   push!(instruction_list , Instruction(i[1], i[2], false))
end
# Problem 1
accumulation = run_prog(instruction_list)
println("Acc = ", accumulation)

