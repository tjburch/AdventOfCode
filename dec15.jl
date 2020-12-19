function play_game(input, terminate_iter)
    spoken = deepcopy(input)
    for _ in 1:terminate_iter-length(input)
        # Step 1, "say all numbers"
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

function main()
    # Part 1
    input = [0,13,1,16,6,17]
    spoken_part1 = play_game(input, 2020)
    println("The 2020th number spoken is ", spoken_part1[end])
end

main()