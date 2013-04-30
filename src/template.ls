{sync} = require "./magic"
fs = require \fs
path = require \path

module.exports = new class Renderer
	engines: {}
	render: (template,vars = {})->
		content = @folder ? path.resolve require.main.filename,"../templates"
		|> sync fs~readdir
		|> filter (== //^#{template}//)
		|> find compose do
			path.extname
			tail
			~> it of @engines

		if content?
			rendered = @folder ? path.resolve require.main.filename,"../templates"
			|> path.join _,that
			|> sync fs~read-file
			|> (.to-string \utf8)
			|> @engines[tail path.extname that].compile
			<| @locals import vars

			headers: 'content-type':'text/html'
			body: if @base is template or not @base? then out else @render @base, {...vars, body:out}

		else Error 404
