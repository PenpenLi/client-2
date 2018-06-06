--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local VersionCompare = {}

function VersionCompare:check_version(exe, localp, remotep)
	return vsp_check_version(exe, localp, remotep);
end

function VersionCompare:install_update()
	return vsp_install_update();
end

function VersionCompare:is_working()
	return vsp_is_working();
end

function VersionCompare:clean()
	return vsp_clean();
end

function VersionCompare:query_version_status()
	return vsp_query_version_status();
end

function VersionCompare:copy_dir(from, to)
	return vsp_copy_dir(from, to);
end

return VersionCompare;
--endregion
