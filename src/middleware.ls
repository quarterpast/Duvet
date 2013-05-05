mime = require \mime
{extname,join,resolve,relative} = require \path
fs = require \fs
require! livewire.magic.sync
zlib = require \zlib
crypto = require \crypto

export
	locals: (...args)->(last)->@locals ...args
	set: (obj,val)->(last)->
		headers: switch typeof! obj
		| \Function => obj this
		| \Object   => obj
		| \String   => (obj): val

	static: (file)->
		stat = fs.stat-sync file
		exists = (file,cb)->
			fs.exists file, cb null _

		->
			path = match stat
			| (.is-directory!) => join file, relative @route,@pathname
			| otherwise => file
			type = mime.lookup extname path

			if (sync exists) path
				pstat = (sync fs.stat) path
				mod = @request.headers."if-modified-since"
				if not mod? or (new Date mod) < pstat.mtime
					headers:
						'Last-Modified': pstat.mtime.to-ISO-string!
						'Content-Type': type
					body: fs.create-read-stream path
				else
					body:"" status-code:304 headers: 'Content-Type':type
			else Error 404
