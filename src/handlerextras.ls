require! {
	"livewire".HandlerContext
}

HandlerContext ::=
	locals: (obj,val)-> switch typeof! obj
		| \Function => @locals obj this
		| \Object   => @locals import obj
		| \String   => @locals[obj] = val

	