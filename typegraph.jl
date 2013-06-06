using JSON

guarded_subtypes(t) = filter(t -> t != Any, subtypes(t))

function typegraph(io::IO)
	types = Array(Any, 0)
	push!(types, Any)

	nodes = Array(Dict, 0)
	indices = Dict()
	links = Array(Dict, 0)

	i = 0
	indices[Any] = i
	i += 1

	while !isempty(types)
		t = shift!(types)

		push!(nodes, {"name" => string(t)})

		for next_t in guarded_subtypes(t)
			push!(types, next_t)

			indices[next_t] = i
			i += 1

			push!(links,
				  {"source" => indices[t],
				  "target" => indices[next_t],
				  "value" => 1})
		end
	end

	output = Dict()
	output["nodes"] = nodes
	output["links"] = links

	print_to_json(io, output)
end

io = open(joinpath("vega", "examples", "data", "julia.json"), "w")
typegraph(io)
close(io)
