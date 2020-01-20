mutable struct Core <: CoreInterfaces.ICore
    config::CoreInterfaces.IConfig
    logs::CoreInterfaces.ILog

    function Core()
        o = new()
        o.config = Config.SConfig()

        o.logs = Logs.SLog(o.config)
        Logs.configure(o.logs)
        o
    end
end


