#pragma once
#include "windows.h"
#include <string>
#include <Psapi.h>

void terminate_multi_opened_process(std::string fname)
{
	DWORD exclude_pid = GetCurrentProcessId();
	DWORD aProcesses[1024], cbNeeded, cbMNeeded;
	HMODULE hMods[1024];
	HANDLE hProcess;
	char szProcessName[MAX_PATH];
	
	if ( !EnumProcesses( aProcesses, sizeof(aProcesses), &cbNeeded ) )  return;
	for(int i=0; i< (int) (cbNeeded / sizeof(DWORD)); i++)
	{
		hProcess = OpenProcess(  PROCESS_QUERY_INFORMATION | PROCESS_VM_READ | PROCESS_TERMINATE, FALSE, aProcesses[i]);
		if (hProcess){
			DWORD pid = GetProcessId(hProcess);
			EnumProcessModules(hProcess, hMods, sizeof(hMods), &cbMNeeded);
			GetModuleFileNameExA( hProcess, hMods[0], szProcessName, sizeof(szProcessName));
			if (fname == szProcessName){
				if (pid != exclude_pid){
					::TerminateProcess(hProcess, -1);
				}
			}
		}
	}
}
