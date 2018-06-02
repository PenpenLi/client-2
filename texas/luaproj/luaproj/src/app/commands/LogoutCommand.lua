local LogoutCommand = {}

function LogoutCommand.execute()
	SOCKET_MANAGER.closeToAccountServer()
	SOCKET_MANAGER.closeToCoordinateServer()
    SOCKET_MANAGER.closeToGameServer()
end

return LogoutCommand