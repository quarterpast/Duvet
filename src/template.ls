Handlebars = require \handlebars
{sync} = require "./magic"
fs = require \fs
path = require \path

module.exports = new class Renderer
	render: (template)->
		| @engine? => (res,last)->
			res@headers.'content-type' = 'text/html'
			path.resolve __dirname,"../templates",template+'.html'
			|> sync fs~read-file
			|> (.to-string \utf8)
			|> that.compile
			|> (<| res@locals import body:last)
		| otherwise => throw new Error "Assign to renderer.engine first."