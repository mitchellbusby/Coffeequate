define ["generateInfo"], (generateInfo) ->

	# Basic nodes for the expression tree.

	class BasicNode
		# A basic node for the expression tree.
		# All nodes inherit from this.
		constructor: (@label) ->

		getChildren: ->
			# Return an array of children.
			return []

		getAllVariables: ->
			return []

		toDrawingNode: ->
			throw new Error("toDrawingNode not implemented for #{self.toString()}")

		toLaTeX: ->
			return @toDrawingNode().renderLaTeX()

		toString: ->
			return @toDrawingNode().renderString()

		toMathML: ->
			@toDrawingNode().renderMathML()

		stringEqual: (other) ->
			return other.toString() == @toString()

		# monteCarloEqual: (other) ->
		# 	myVars = @getAllVariables().sort()
		# 	otherVars = other.getAllVariables().sort()

		# 	if @getAllVariables().sort() == other.getAllVariables().sort()

	return {

		BasicNode: BasicNode

		RoseNode: class extends BasicNode
			# A node with any number of children.

			constructor: (label, @children=null) ->
				unless @children?
					@children = []

				super(label)

			getChildren: ->
				@children

			toLisp: ->
				childrenStrings = @children.map((x) -> if x.toLisp then x.toLisp() else x)
				"(#{@label}#{if @children then " " else ""}#{childrenStrings.join(" ")})"


		BinaryNode: class extends BasicNode
			# A node with exactly two children, a left and a right child.
			constructor: (@label, left, right) ->
				@children =
					left: left
					right: right

			getChildren: ->
				# Return an array of children.
				[@children.left, @children.right]

			toLisp: ->
				lispify = (x) -> if x.toLisp then x.toLisp() else x
				"(#{@label} #{lispify(@children.left)} #{lispify(@children.right)})"

	}