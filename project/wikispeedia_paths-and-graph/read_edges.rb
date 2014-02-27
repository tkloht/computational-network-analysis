#!/usr/bin/env ruby

require "csv"
#parsed_file = CSV.read("paths_finished.tsv", { :col_sep => "\t" })
nodes = Array.new

CSV.foreach("nodes.csv", { :col_sep => "," }) do |row|
  # use row here...
  #puts row[0]
  
  
  nodes.push(row[0])
  #nodes.sort!
  #puts nodes
end

#CSV.foreach("paths_finished.tsv", { :col_sep => "\t" }) do |row|
#  # use row here...
#  row[3].split(";").each{ |x|
#    #nodes.push(x)
#    puts x
#  }
#  puts "+++++++++++++++++++++++++++++++++++++"
#end

File.open('network', 'a') do |file|
  nodes.each { |x| 
    nodeEdges = Array.new
    CSV.foreach("paths_finished.tsv", { :col_sep => "\t" }) do |row|
      # use row here...
      edges = row[3].split(";")
      edges.each_with_index{ |y, i|
        if x == y && i+1 < edges.length
         # puts "found edge" << y << " to " << edges[i+1] 
          nodeEdges.push(edges[i+1])
        end
      }
    end
    nodeEdges.each_with_object(Hash.new(0)) { |edge,counts| counts[edge] += 1 }
    file.puts "# #{x}"
    nodeEdges.uniq.each { |e| 
      z = nodeEdges.find_all { |x|  x == e }.length
      file.puts "#{e}\t#{z}" 
    }
    

  }
end


#CSV.open("nodes.csv", "wb") do |csv|
#	nodes.each_with_index { |x, i| 
#		csv << [x, i]}
#  # ...
#end