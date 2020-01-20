# This is the main module that encompasses everything.

# ---------------------------------------------------
module Deuron
# ---------------------------------------------------
using JSON

include("./core_interfaces.jl")

include("./core.jl")
include("./config.jl")
include("./file_io/logs.jl")

include("./sim/sim.jl")

core = Core()

paused = false
stopped = false
reset = false

function boot()
    println("Welcome to Deuron8")
    print_help()

    while true
        print(">")
        input = readavailable(stdin)
        # println("input: ", input)
        
        msg = String(input[1:length(input) - 1])

        if msg == "q"  # 0x71 # "q" == quit
            global paused = true
            Logs.log_to_app(Deuron.core.logs, "Stopping...", true)
            global stopped = true
        elseif msg == "r"
            global paused = false
            @async Sim.go()
        elseif msg == "p"
            Logs.log_to_app(Deuron.core.logs, "Pausing...", true)
            global paused = true
        elseif msg == "u"
            Logs.log_to_app(Deuron.core.logs, "Resuming...", true)
            global paused = false
        elseif msg == "s"
            global paused = true
            global reset = true
        end

        print_help()
    end
end

function print_help()
    println("--------------------------------------------")
    println("Commands:")
    println("  q: quit")
    # "r" either resumes any previous sim that was in progress or starts a new one.
    # The config file identifies which.
    println("  r: run simulation")
    println("  p: pause simulation")
    println("  u: resume simulation")
    println("  s: reset simulation")
    println("  h: this help menu")
    println("--------------------------------------------")
end

function resume()
    global paused = false
end

function reset_complete()
    global reset = false
end


end # End module -------------------------------------
