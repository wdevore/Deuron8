# ---------------------------------------------------
module Sim
# ---------------------------------------------------
using ..Deuron
using ..Config
using ..Logs

# Main sim entry point
function entry()
    trace = try
        if Config.exit_state(Deuron.core.config) == "Paused"
            Logs.log_to_app(Deuron.core.logs, "Simulation resuming", true)
        else
            Logs.log_to_app(Deuron.core.logs, "Simulation starting", true)
        end
    
        while true
            if !Deuron.paused
                Logs.log_to_app(Deuron.core.logs, ".", true)
                sleep(1)
            else
                Logs.log_to_app(Deuron.core.logs, "--paused--", true)
                sleep(1)
            end

            if Deuron.reset
                Logs.log_to_app(Deuron.core.logs, "Sim resetting...", true)
                Deuron.resume()
                Deuron.reset_complete()
                Logs.log_to_app(Deuron.core.logs, "Reset complete", true)
            end

            if Deuron.stopped
                break
            end         
        end

        exit()

        nothing
    catch ex
        bt = catch_backtrace()
        msg = sprint(showerror, ex, bt)

        Logs.log_to_err(Deuron.core.logs, msg)

        # Set flag and exit
        Deuron.set_crashed()
        exit()

        # println("### Exception ###:\n", ex)
        # stacktrace(catch_backtrace())
        # Base.exit(3)
    end

    # Not sure if this will ever trigger. TODO research...
    if trace ≠ nothing
        println(trace)
        println("\n################ Exception ####################")
        println("Goodbye.")
        Base.exit(2)
    end
end

function exit()
    msg = "============================================="
    Logs.log_to_app(Deuron.core.logs, msg, true)
    println("\n", msg)

    # Do exit stuff
    if Deuron.suspended
        Logs.log_to_app(Deuron.core.logs, "Suspending...", true)
        Logs.log_to_app(Deuron.core.logs, "Suspend complete", true)
        Config.set_exit_state(Deuron.core.config, "Paused")
    elseif Deuron.crashed
        Logs.log_to_app(Deuron.core.logs, "Crashed!!! See error.log", true)
        Config.set_exit_state(Deuron.core.config, "Crashed")
    else
        msg = "Exiting..."
        Logs.log_to_app(Deuron.core.logs, msg, true)
        Config.set_exit_state(Deuron.core.config, "Terminated")
    end

    Config.save(Deuron.core.config)

    Deuron.stop()

    msg = "Goodbye."
    Logs.log_to_app(Deuron.core.logs, msg, true)

    Logs.close_logs(Deuron.core.logs)

    println(msg)
    Base.exit(1)
end

end # End module -----------------