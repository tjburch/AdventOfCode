""" Solution one, just play the game as indicated """
function play_game(input, terminate_iter)
    # Step 1, "say all numbers"
    spoken = deepcopy(input)
    for _ in 1:terminate_iter-length(input)
        # Step 2, differential from last spoken
        spoken_indices = findall(x->x==spoken[end], spoken)
        if length(spoken_indices) > 1
            differential = spoken_indices[end] - spoken_indices[end-1]
            push!(spoken, differential)
        else
            push!(spoken, 0)
        end
    end
    spoken
end

""" Solution 2, save via dictionary """
function play_game_efficient(input, terminate_iter)

    prev = NaN
    usage_dict = Dict{Int, Int}()
    prev = 0
    
    for i in 1:terminate_iter
        if  i <= length(input)
            iter_value = input[i]
        elseif !haskey(usage_dict, prev)
            iter_value = 0
        else
            iter_value = i - 1 - usage_dict[prev]
        end

        usage_dict[prev] = i-1
        prev = iter_value
    end
    return prev
end


function main()
    input = [0,13,1,16,6,17]
    println("The 2020th number spoken is ", play_game(input, 2020)[end])
    println("The 30,000,000th number spoken is ",  play_game_efficient(input, 30000000))
end

main()