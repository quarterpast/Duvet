require! {
	Duvet: "./lib"
	"buster-minimal"
	http, sync
}
buster = new buster-minimal
{expect,assert,refute} = buster.assertions

async = (fn)->
	as = fn.async!
	(done)->
		as.call this, (err,r)->
			do done ~>
				throw that if err?

async-get = (url,cb)->
	http.get url,(res)->
		body = []
		res.on \data body~push
		res.on \error cb
		res.on \end ->cb null {body: (Buffer.concat body)to-string \utf8} import res
	.on \error cb

get = (->async-get.sync null,...&).async!

buster.add-case "Duvet" {
	"has routes courtesy Livewire": async ->
		Duvet.route.GET "/" -> "hello"
		server = http.create-server Duvet.route.app .listen 8000
		"hello" `assert.same` (get "http://localhost:8000/")body
		server.close!
}

buster.run!