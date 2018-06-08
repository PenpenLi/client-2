#include "main.h"
#include "SimulatorWin.h"
#include <shellapi.h>

SimulatorWin* simulator = nullptr;
int WINAPI _tWinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPTSTR    lpCmdLine,
	int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);
    simulator = SimulatorWin::getInstance();
    return simulator->run();
}

std::string get_cmdline(std::string str)
{
	static std::vector<string> args;
	if (args.empty()){
		for (int i = 0; i < __argc; ++i)
		{
			wstring ws(__wargv[i]);
			string s;
			s.assign(ws.begin(), ws.end());
			args.push_back(s);
		}
	}
	auto it = std::find(args.begin(), args.end(), str);
	if (it != args.end()){
		return "1";
	}
	return "";
}