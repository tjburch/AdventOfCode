#=
Part 1:
For example, suppose you have the following list:
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

How many passwords are valid according to their policies?

Part 2:
Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

Given the same example list from above:

1-3 a: abcde is valid: position 1 contains a and position 3 does not.
1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
How many passwords are valid according to the new interpretation of the policies?

=#

function get_range(line)
    range_reg = Regex("[0-9]{1,2}")
    range = [parse(Float64, m.match) for m in eachmatch(range_reg, line)]
    return range
end

function get_char(line)
    char_reg = Regex("[a-z]:")
    char_match = match(char_reg,line)
    return char_match.match[1]
end

function count_chars(line, char)
    return count(i->(i==char), line) # lambda count
end

function string_validity(password, char, range)
    # For part 2
    criterion_match = 0
    if password[Int(range[1])] == char
        criterion_match +=1
    end
    if password[Int(range[2])] == char
        criterion_match +=1
    end

    valid = false
    if criterion_match == 1
        valid = true
    end
    return valid
end


function main()
    valid_passwords = 0 
    string_valid_passwords = 0 # part 2
    # Iterate over lines
    for line in eachline("inputs/dec2-input.csv")
    
        range = get_range(line)
        char = get_char(line)
        password = last(split(line))
        count = count_chars(password, char)

        if count >= range[1] && count <= range[2]
            valid_passwords += 1
        end

        string_valid_passwords += Int(string_validity(password, char, range))
    end
    println("(Part 1) Final number of valid passwords: ", valid_passwords)
    println("(Part 2) Final number of sting-matchin passwords: ", string_valid_passwords)

end

main()