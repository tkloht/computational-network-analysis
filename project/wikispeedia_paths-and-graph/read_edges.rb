#!/usr/bin/env ruby

# For each vertex, find neighboring vertices and store both in the LGL format

require "csv"

nodes = Array.new

CSV.foreach("nodes.csv", { :col_sep => "," }) do |row|
  nodes.push(row[0])

end


File.open('network_fixed', 'a') do |file|
  # for each vertex/article
  nodes.each { |x| 
    nodeEdges = Array.new
    # iterate over all paths
    CSV.foreach("paths_finished_fixed.tsv", { :col_sep => "\t" }) do |row|
      # navigation paths are stored in column 4
      edges = row[3].split(";")
      edges.each_with_index{ |y, i|
        # iterate over all articles visited by user
        if x == y && i+1 < edges.length
         # if article matching current node is found, next list entry is a neighboring vertex -> add to temporary list 
          nodeEdges.push(edges[i+1])
        end
      }
    end
    # lgl file is constructed here
    file.puts "# #{x}"
    nodeEdges.uniq.each { |e| 
      # find edge weight
      z = nodeEdges.find_all { |x|  x == e }.length
      file.puts "#{e}\t#{z}" 
    }
    

  }
end


