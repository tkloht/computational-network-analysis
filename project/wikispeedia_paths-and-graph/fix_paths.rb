#!/usr/bin/env ruby

# normalizes back clicks ("<") by replacing them with the actual article. 
# input paths taken from paths_finished.tsv,
# output will be paths_finished_fixed.tsv


require "csv"

nodes = Array.new

CSV.foreach("nodes.csv", { :col_sep => "," }) do |row|
	nodes.push(row[0])
end


File.open('paths_finished_fixed.tsv', 'a') do |file|
	CSV.foreach("paths_finished.tsv", { :col_sep => "\t" }) do |row|
	# use row here...
	edges = row[3].split(";")
	edges.each_with_index{ |x, i|
		if x == '<' && i < edges.length
			pivot = i-1 #save edge before first '<' as pivot element
			count = 1
			z = i
			# once a '<' edge has been found, find length of consecutive ones
			while edges[z+1] == '<'
			  count += 1
			  z += 1
			end
			# then replace each of these
			while count > 0
			  # if you are x elements right of the pivot element, replace with element x steps to the left it
			  edges[pivot + count] = edges[pivot - count]
			  count -= 1
			end
		end
	}
	edgeString = ""
	edges.each_with_index { |e, i| 
		edgeString << e
		if i < edges.length - 1
			edgeString << ";"
		end
	}
	row[3] = edgeString
	#puts "#{row[0]}\t#{row[1]}\t#{row[2]}\t#{row[3]}"
	file.puts "#{row[0]}\t#{row[1]}\t#{row[2]}\t#{row[3]}"
	end   

end


