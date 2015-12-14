map = {}

def get_operator(name)
    case name
    when "AND" 
        return lambda { |a,b| a & b }
    when "OR"
        return lambda { |a,b| a | b }
    when "LSHIFT"
        return lambda { |a,b| a << b }
    when "RSHIFT"
        return lambda { |a,b| a >> b }
    when "NOT"
        return lambda { |a,b| ~b }
    end
end

def get_function(tgt, args, map)
    if args.length == 1
        int = Integer(args[0]) rescue nil
        return lambda { ||
            if int
                return int
            else
                result = map[args[0]].call()
                map[tgt] = lambda { || result }
                return result
            end
        }
    end

    if args.length == 2
        return lambda { || 
            operator = get_operator(args[0])
            param2 = get_function(args[1], [args[1]], map).call
            result = operator.call(nil, param2)
            map[tgt] = lambda { || result }
            return result
        }
    end

    if args.length == 3
        return lambda { || 
            operator = get_operator(args[1])
            param1 = get_function(args[0], [args[0]], map).call
            param2 = get_function(args[2], [args[2]], map).call
            result = operator.call(param1, param2)
            map[tgt] = lambda { || result }
            return result
        }
    end

    raise Error
end

File.foreach("input.txt") { |line| 
    front, target = line.split(" -> ")
    target.chomp!
    if target == "b"
        front = "16076"
    end

    args = front.split
    map[target] = get_function(target, args, map)
}

puts "On wire a: " + map["a"].call.to_s