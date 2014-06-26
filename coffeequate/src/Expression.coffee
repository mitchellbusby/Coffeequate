define ["parse", "nodes"], (parse, nodes) ->

	# Public interface for nodes.

	class Expression
		constructor: (val) ->
			if val instanceof String or typeof val == "string"
				# The string we pass in is just a representation to parse.
				@expr = parse.stringToExpression(val)
			else if val.copy?
				@expr = val.copy()
			else
				console.log("Received argument: ", val)
				throw new Error("Unknown argument: `#{val}'.")

		toString: ->
			@expr.toString()

		toMathML: ->
			@expr.toMathML()

		toLaTeX: ->
			@expr.toLaTeX()

		solve: (variable) ->
			# TODO: Equivalencies.
			(new Expression(solution) for solution in @expr.solve(variable))

		sub: (substitutions) ->
			# TODO: Uncertainties, equivalencies, options.
			# TODO: Seems that the way I implemented substituting expressions was different last time for no real reason. Fix.

			# If there are any Expressions in here, we should remove them.
			newsubs = {}
			for key of substitutions
				if substitutions[key] instanceof Expression
					newsubs[key] = substitutions[key].expr
				else
					newsubs[key] = substitutions[key]

			return new Expression(@expr.sub(newsubs, null, null).simplify())

		copy: ->
			new Expression(@expr.copy())

		simplify: ->
			new Expression(@expr.simplify())
		expand: ->
			new Expression(@expr.expand())

		toFunction: (params...) =>
			console.log("Blah")
			return (innerParams...) =>
				dict = {}
				console.log("Hi")
				for variable, index in params
					console.log("hello")
					dict[variable]=innerParams[index]
				console.log("About to finish sub")
				@sub(dict).toString()
				console.log("Finished sub")

	return Expression