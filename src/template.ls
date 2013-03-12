{sync} = require "./magic"
fs = require \fs
path = require \path

module.exports = new class Renderer
	engines: {}
	render: (template)->
		out = (res,last)~>
			res{}headers.'content-type' = 'text/html'

			content = @folder ? path.resolve require.main.filename,"../templates"
			|> sync fs~readdir
			|> filter (== //^#{template}//)
			|> find path.extname>>tail>>(of this$.engines) #HAX

			if content?
				@folder ? path.resolve require.main.filename,"../templates"
				|> path.join _,that
				|> sync fs~read-file
				|> (.to-string \utf8)
				|> @engines[tail path.extname that].compile
				<| res{}locals import body:last
			else
				res.status-code = 404
				"Template #template not found."

		if @base is template or not @base? then out else [out] ++ @render @base