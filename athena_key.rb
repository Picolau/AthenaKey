def get_arrangements(names, group, index = 0)
  arrangements = []

  if group == 1
    arrangements << names[index]
    if names[index].size != 1
      arrangements << names[index].upcase
    end
    arrangements << names[index].capitalize
  else
    i = index + 1

    while i+group-2 < names.size
      get_arrangements(names, group-1, i).each_with_index do |s, ind|
        connectors.each do |connector|
          main_arrangement = names[index] + connector + s

          if ind == 0
            comparators_variations = get_variations(match_comparators(main_arrangement))
            comparators_variations.delete_at -1

            comparators_variations.each do |c_variation| # => c_variation = ["e", "a", "o"] 
              replaced_arrangements = replaced_arrangements(main_arrangement, c_variation)
              
              replaced_arrangements.each do |replaced_arrangement|
                arrangements << replaced_arrangement
              end
            end
          end

          arrangements << main_arrangement                                   # => nothing capitalized
          if names[index].size != 1
            arrangements << names[index].upcase + connector + s              # => first uppercased
          end
          arrangements << names[index].capitalize + connector + s            # => first capitalized
        end
      end

      i += 1
    end

    arrangements
  end
end

def match_comparators(str)
  main_arrangement = str

  match_comparators = []

  replacers.keys.each do |comparator|
    r = Regexp.new comparator
    if main_arrangement =~ r
      match_comparators << [comparator, ""]
    end
  end

  match_comparators
end


def connectors
  ["", ".", "_"]
end

def replacers
  { "e" => ["3"], "a" => ["4", "@"], "i" => ["1"], "o" => ["0"], "g" => ["9"], "z" => ["2"],
    "1" => ["i", "I"], "0" => ["o", "O"], "b" => ["8"], "t" => ["7"], "s" => ["5", "$"], "2" => ["z"] }
end

def get_variations(variation_names, index = 0)
  if index == variation_names.size
    [[]]
  else
    variation_name_arrangements = []

    get_variations(variation_names, index + 1).each do |variation|
      variation_names[index].each do |variation_name|
        if variation_name == ""
          variation_name_arrangements << variation
        else
          variation_name_arrangements << [variation_name].concat(variation)
        end
      end
    end

    variation_name_arrangements
  end
end

def replaced_arrangements(main_arrangement, comparator_variation, index = 0)
  replaced_arrangements = []

  if comparator_variation.size == index
    replaced_arrangements = [main_arrangement]
  else
    replaced_arrangements(main_arrangement, comparator_variation, index+1).each do |replaced_arrangement|
      comparator = comparator_variation[index]
      comparator_exp = Regexp.new comparator

      replacers[comparator].each do |replacer|   
        replaced_arrangements << replaced_arrangement.gsub(comparator_exp, replacer)
      end
    end
  end

  replaced_arrangements
end

def names_arrangements_with_connectors
  names = ["fellipe", "picoli"]
  nicks = ["fe", "feh", "fezinho"]

  names_arrangements = names.clone
  names_arrangements.concat nicks
  names_arrangements_aux = names_arrangements.clone

  names_arrangements_aux.each do |name|
    comparators_variations = get_variations(match_comparators(name))
    comparators_variations.delete_at -1

    comparators_variations.each do |c_variation| # => c_variation = ["e", "a", "o"] 
      replaced_arrangements = replaced_arrangements(name, c_variation)
      
      replaced_arrangements.each do |replaced_arrangement|
        names_arrangements << replaced_arrangement
      end
    end

    names_arrangements << name
    names_arrangements << name.upcase
    names_arrangements << name.capitalize
  end

  variation_first_name_with_other_names = names.clone.map { |name| [name, name[0]] } # => [["l", "leonardo"], ["g", "greco"], ["p", "picoli"]]
  variation_first_name_with_other_names[0].concat nicks

  names_arrangementes_with_names_initials = get_variations(variation_first_name_with_other_names)

  names_arrangementes_with_names_initials.each do |names|
    names.size.times do |i|
      if (i > 0)
        a = get_arrangements(names, i+1)
        names_arrangements.concat a
      end
    end
  end

  names_arrangements
end

print (names_arrangements_with_connectors).size
















