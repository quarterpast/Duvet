require! {
	Duvet: "./lib"
	"buster-minimal"
}
buster = new buster-minimal
{expect,assert,refute} = buster.assertions

buster.add-case "Duvet" {
	"is a thing": -> assert Duvet?
}

buster.run!