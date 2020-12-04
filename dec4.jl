using DelimitedFiles

ALL_KEYS = ["byr","iyr","eyr","hgt","hcl","ecl","pid","cid"]
NEEDED_KEYS = ["byr","iyr","eyr","hgt","hcl","ecl","pid"]
VALID_EYES = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

# Load file
s = read("inputs/dec4-input.txt", String)
# split into component dictionary proposals
spl = split(s, "\n\n")

function string_to_int(value_str)
    # Check validity
    try
        parse(Int64,value_str)
    catch
        return false
    end
    # return
    return parse(Int64,value_str)
end

function check_height(height_str)
    #hgt (Height) - a number followed by either cm or in:
    #If cm, the number must be at least 150 and at most 193.
    #If in, the number must be at least 59 and at most 76.

    # Check cm or in
    unit = height_str[end-1:end]
    # Get values
    value = parse(Int64, height_str[1:end-2])
    # control flow implement
    if unit == "cm"
        if value < 150 || value > 193
            return false
        end
    elseif unit == "in" 
        if value > 59 || value < 76
            return false
        end
    else
        return false
    end
end


function dict_validation(proposal)
    #= Part 2 requirements =#

    #byr (Birth Year) - four digits; at least 1920 and at most 2002.
    byr_local = string_to_int(proposal["byr"])
    if byr_local < 1920 || byr_local > 2002 || length(proposal["byr"]) != 4
        return false
    end
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    iyr_local = string_to_int(proposal["iyr"])
    if iyr_local < 2010 || iyr_local > 2020
        return false
    end
    println("b")

    #eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    eyr_local = string_to_int(proposal["eyr"])
    if eyr_local < 2010 || eyr_local > 2020
        return false
    end
    println("c")

    #hgt (Height) - a number followed by either cm or in:
    #If cm, the number must be at least 150 and at most 193.
    #If in, the number must be at least 59 and at most 76.
    if !check_height(proposal["hgt"])
        return false
    end
    println("d")

    #hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    r = Regex("#[a-f0-9]{9}")
    if typeof(match(r,"#1234567q9")) == Nothing
        return false
    end
    println("e")

    #ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    if ! proposal["ecl"] in VALID_EYES
        return false
    end
    println("f")

    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    # cast as int, then back to string for leading zeros
    if length( string(parse(Int64,proposal["pid"])) ) != 9
        return false
    end
    println("g")

    # cid (Country ID) - ignored, missing or not.


    return true
    
end


valid_element_passports = 0
valid_value_passports = 0 
for d in spl
    # clean newlines
    d = replace(d, "\n"=>" ")
    
    # Split by spaces to get key-values
    element_propsals = split(d, " ")
    
    # Populate a dictionary of elements
    this_dict = Dict()
    for element in element_propsals
        components = split(element,":")
        this_dict[components[1]] = components[2]        
    end

    # Count valid elements (Part 1)
    diff = setdiff(NEEDED_KEYS, keys(this_dict))
    if length(diff) == 0
        valid_element_passports += 1
        valid_value_passports += dict_validation(this_dict)
    end


end

println("There are ", valid_element_passports," passports with valid elements")
println("There are ", valid_value_passports," passports with valid values")
