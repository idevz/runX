import gdb
from subprocess import call


class sbps(gdb.Command):
    """This command takes a lua_State pointer and dumps all contents from
it's stack.
Usage: sbps (path/to/break/point/file)"""

    def __init__(self):
        super(sbps, self).__init__("sbps", gdb.COMMAND_USER)

    def invoke(self, args, from_tty):
        argv = gdb.string_to_argv(args)
        sbps_file = "/media/psf/runX/gdb/{}/.{}".format(
            call('hostname'), argv[0])
        # "table number: %s" % argv[0]
        if len(argv) != 1:
            raise gdb.GdbError(
                "1 argument expected!\nusage: ltb <lua_State *>")
        print("save breakpoints %s" % sbps_file)
        gdb.execute("save breakpoints %s" % argv[0])


sbps()
