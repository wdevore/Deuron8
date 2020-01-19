# ---------------------------------------------------
module Config
# ---------------------------------------------------
using JSON

# using ..Deuron
using ..CoreInterfaces

# Simulation writes to several files, not including the sim data files:
# app.log      - Smaller more frequent messages
# progress.log - Larger report size messages and information
# sim.log      - Stores the current state of the simulation. For example,
#                if it was paused or terminated.
# error.log    - Errors prior at the time of failures.

mutable struct SConfig <: CoreInterfaces.IConfig
    json::Dict{String,Any}

    function SConfig()
        o = new()
        o.json = JSON.parsefile("config.json")
        o
    end
end

function app_log(config::CoreInterfaces.IConfig)
    config.json["AppLog"]
end
function progress_log(config::CoreInterfaces.IConfig)
    config.json["ProgressLog"]
end
function sim_log(config::CoreInterfaces.IConfig)
    config.json["SimLog"]
end
function err_log(config::CoreInterfaces.IConfig)
    config.json["ErrLog"]
end

# Indicates what the last state the simulation was in when deuron exited.
# Values:
#   Terminated
#   Completed
#   Crashed
#   Paused
function exit_state(config::CoreInterfaces.IConfig)
    config.json["ExitState"]
end

# function exit_state(core::CoreInterfaces.ICore)
#     Deuron.get_config(core).json["ExitState"]
# end

end # End module -----------------