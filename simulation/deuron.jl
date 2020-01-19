# This is the main simulation base.

# ---------------------------------------------------
module Deuron
# ---------------------------------------------------
include("./core_interfaces.jl")

include("./core.jl")
include("./config.jl")
include("./file_io/logs.jl")

using JSON

core = Core()

loop = true

function boot()
    println("Welcome to Deuron8")
    print_help()

    while true
        print(">")
        input = readavailable(stdin)
        # println("input: [", input, "]")
        
        msg = String(input[1:length(input) - 1])
        if msg == "q"  # 0x71 # "q" == quit
            println("############################################")
            loop = false
            println("Goodbye.")
            Base.exit(1)
        elseif msg == "r"
            @async go()
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
    println("  h: this help menu")
    println("--------------------------------------------")
end

function go()

    if Config.exit_state(core) == "Paused"
        println("\nSimulation environment resuming...")
    else
        println("\nSimulation environment starting...")
    end

    while loop
        print(".")
        sleep(0.1)
    end

end

    function exit()
    Logs.close_logs(core.logs)

    println("Exiting...")
    println("Done")
end

end # End module -------------------------------------
