def get_arrangements(names, group, index = 0)
  arrangements = []

  if group == 1
    arrangements << names[index]
  else
    i = index + 1

    while i+group-2 < names.size
      get_arrangements(names, group-1, i).each do |s|
        connectors.each do |connector|
          main_arrangement = names[index] + connector + s

          comparators_variations = get_variations(match_comparators(main_arrangement))

          comparators_variations.each do |c_variation| # => c_variation = ["e", "a", "o"] 
            replaced_arrangements(main_arrangement, c_variation).each do |replaced_arrangement|
              arrangements << replaced_arrangement
            end
          end

          arrangements << main_arrangement                                   # => nothing capitalized
          arrangements << names[index].capitalize + connector + s            # => first capitalized
          arrangements << names[index] + connector + s.capitalize            # => second capitalized
          arrangements << names[index].capitalize + connector + s.capitalize # => both capitalized
          arrangements << names[index].upcase + connector + s                # => first uppercased
          arrangements << names[index] + connector + s.upcase                # => second uppercased
          arrangements << names[index].upcase + connector + s.upcase         # => both uppercased
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
  { "e" => ["3"], "a" => ["4", "@"], "i" => ["1"], "o" => ["0"], "g" => ["9"]
    "1" => ["i", "I"], "0" => ["o", "O"], "b" => ["8"], "t" => ["7"], "s" => ["5", "$"]}
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
  replaced_arrangements = [main_arrangement]

  comparator_variation[index..-1].each do |comparator|
    replaced_arrangements(main_arrangement, comparator_variation, index+1).each do |replaced_arrangement|
      replacers[comparator].each do |replacer|
        comparator_exp = Regexp.new comparator
        
        replaced_arrangements << replaced_arrangement.gsub(comparator_exp, replacer)
      end
    end
  end

  replaced_arrangements
end

def names_arrangements_with_connectors
  names = ["fellipe", "picoli"]

  names_arrangements = names.clone

  variation_first_name_with_other_names = names.clone.map { |name| [name, name[0]] } # => [["l", "leonardo"], ["g", "greco"], ["p", "picoli"]]
  variation_first_name_with_other_names[0] << names[0][0..1] # => ["l", "leonardo", "le"]
  variation_first_name_with_other_names[0] << names[0][0..2] # => ["l", "leonardo", "le", "leo"]
  variation_first_name_with_other_names[0] << names[0][0..3] # => ["l", "leonardo", "le", "leo", "leon"]


  names_arrangementes_with_names_initials = get_variations(variation_first_name_with_other_names)
  
  names_arrangementes_with_names_initials.each do |names|
    names.size.times do |i|
      if i > 0
        a = get_arrangements(names, i+1)
        names_arrangements.concat a
      end
    end
  end

  names_arrangements
end

def nickname_arrangements_with_connectors
  names = ["feh", "picoli"]

  names_arrangements = names.clone

  variation_nickname_with_other_names = names.clone.map { |name| [name, name[0]] } # => [["f", "feh"], ["g", "greco"], ["p", "picoli"]]
  variation_nickname_with_other_names[0].delete_at(1) # => [["feh"], ["g", "greco"], ["p", "picoli"]]

  names_arrangementes_with_names_initials = get_variations(variation_nickname_with_other_names)
  
  names_arrangementes_with_names_initials.each do |names|
    names.size.times do |i|
      if i > 0
        a = get_arrangements(names, i+1)
        names_arrangements.concat a
      end
    end
  end

  names_arrangements
end


print nickname_arrangements_with_connectors.concat(names_arrangements_with_connectors)

















