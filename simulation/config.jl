# ---------------------------------------------------
module Config
# ---------------------------------------------------
using JSON

using ..CoreInterfaces

# Simulation writes to several files, not including the sim data files:
# app.log      - Smaller more frequent messages
# progress.log - Larger report size messages and information
# sim.log      - Stores the current state of the simulation. For example,
#                if it was paused or terminated.
# error.log    - Errors prior at the time of failures.

CONFIG_FILE = "config.json"

mutable struct SConfig <: CoreInterfaces.IConfig
    json::Dict{String,Any}

    function SConfig()
        o = new()
        o.json = JSON.parsefile(CONFIG_FILE)
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

function save(config::CoreInterfaces.IConfig)
    open(CONFIG_FILE, "w") do f
        JSON.print(f, config.json, 2)
    end
end

# -----------------------------------------------------------------
# Set/Gets
# -----------------------------------------------------------------

# Indicates what the last state the simulation was in when deuron exited.
# Values:
#   Terminated => user quit simulation while it was inprogress
#   Completed = sim terminated on its own
#   Crashed = sim died
#   Paused = user paused simulation
function exit_state(config::CoreInterfaces.IConfig)
    config.json["ExitState"]
end

function set_exit_state(config::CoreInterfaces.IConfig, state::String)
    config.json["ExitState"] = state
end


end # End module -----------------