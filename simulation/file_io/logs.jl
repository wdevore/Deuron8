# ---------------------------------------------------
module Logs
# ---------------------------------------------------
using Dates

using ..CoreInterfaces
using ..Config

# Simulation writes to several files, not including the sim data files:
# app.log - Smaller more frequent messages
# progress.log - Larger report size messages and information
# sim.log - Stores the current state of the simulation. For example,
#           if it was paused or terminated.
# error.log - Errors prior at the time of failures.

mutable struct SLog <: CoreInterfaces.ILog
    start_time::String
    config::CoreInterfaces.IConfig

    appLog::IOStream
    dtFormat::DateFormat

    function SLog(config::CoreInterfaces.IConfig)
        o = new()
        # println("Applog: ", Config.appLog(config))
        o.dtFormat = dateformat"Y-mm-dd II:MM:SS"
        o.start_time = Dates.format(Dates.now(), o.dtFormat)
        o.config = config
        o
    end
end

function configure(log::CoreInterfaces.ILog)
    # inspect config file to determine how log files are open
    # If Paused then we open most of the logs for "append"
    if Config.exit_state(log.config) == "Paused"
        log.appLog = open(Config.app_log(log.config), "a")
    else
        log.appLog = open(Config.app_log(log.config), "w")
    end

    log_to_app(log, "Log configured at ", true)
end

function log_to_app(log::CoreInterfaces.ILog, msg::String, stamp::Bool = false)
    if stamp
        write(log.appLog, Dates.format(Dates.now(), log.dtFormat), " ")
    end

    write(log.appLog, msg, "\n")
    flush(log.appLog)
end

function close_logs(log::CoreInterfaces.ILog)
    close(log.appLog)
end

end # End module -----------------