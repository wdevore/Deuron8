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
running = false

function boot()
    println("Welcome to Deuron8")
    msg = string("Previous run state: ", Config.exit_state(Deuron.core.config))
    println(msg)
    print_help()

    Logs.log_to_app(Deuron.core.logs, "---------------------------------------------", true)
    Logs.log_to_app(Deuron.core.logs, "******************* Ready *******************", true)
    Logs.log_to_app(Deuron.core.logs, "---------------------------------------------", true)
    Logs.log_to_app(Deuron.core.logs, msg, true)

    while true
        input = readavailable(stdin)
        # println("input: ", input)
        
        # Strip newline off
        msg = String(input[1:length(input) - 1])

        if msg == "q"  # quit
            if paused
                Logs.log_to_app(Deuron.core.logs, "Stopping...", true)
                global stopped = true
            else
                println("** Pause sim first before quitting **")
            end
        elseif msg == "r"   # run/start
            if running || paused
                println("** Sim is paused or already running **")
            else
                global paused = false
                global running = true
                @async Sim.go()
            end
        elseif msg == "p"   # pause
            if paused
                println("** Already paused **")
            else
                Logs.log_to_app(Deuron.core.logs, "Pausing...", true)
                global paused = true
            end
        elseif msg == "u"  # resume
            if !paused
                println("** Sim isn't paused **")
            else
                Logs.log_to_app(Deuron.core.logs, "Resuming...", true)
                global paused = false
            end
        elseif msg == "a"   # status
            if paused
                println("-- Simulation is paused --")
            elseif running
                println("-- Simulation is running --")
            elseif !running
                println("-- Simulation is idle --")
            end
        elseif msg == "s"   # reset
            global paused = true
            global reset = true
        end

        print_help()
    end
end

function print_help()
    # "r" either resumes any previous sim that was in progress or starts a new one.
    # The config file identifies which.

    println("--------------------------------------------")
    println("Commands:")
    println("  q: quit")
    println("  r: run simulation")
    println("  p: pause simulation")
    println("  u: resume simulation")
    println("  s: reset simulation")
    println("  a: status of simulation")
    println("  h: this help menu")
    println("--------------------------------------------")
    print(">")
end

function resume()
    global paused = false
end

function reset_complete()
    global reset = false
end

function stop()
    global running = false
end

end # End module -------------------------------------
