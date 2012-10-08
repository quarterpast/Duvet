{sync} = require "./magic"
fs = require \fs
path = require \path

module.exports = new class Renderer
	engines: {}
	render: (template)->(res,last)~>
		res@headers.'content-type' = 'text/html'

		template = @folder ? path.resolve require.main.filename,"../templates"
		|> sync fs~readdir
		|> filter (== //^#{template}//)
		|> find path.extname>>(of this$.engines) #HAX

		if template?
			that
			|> sync fs~read-file
			|> (.to-string \utf8)
			|> @engines[path.extname that].compile
			<| res@locals import body:last
		else
			res.status-code = 404
			"Template #template not found."