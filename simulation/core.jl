mutable struct Core <: CoreInterfaces.ICore
    config::CoreInterfaces.IConfig
    logs::CoreInterfaces.ILog

    function Core()
        o = new()
        o.config = Config.SConfig()

        println("Previous run state: ", Config.exit_state(o.config))
        o.logs = Logs.SLog(o.config)
        Logs.configure(o.logs)

        o
    end
end

# function get_config(core::CoreInterfaces.ICore)
#     core.config
# end

