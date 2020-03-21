// tar_mydll.cpp : Defines the entry point for the DLL application.
//

#include <stdio.h>
#include "tar_mydll.h"

static HWND MainWindow = 0;

BOOL APIENTRY DllMain( HANDLE /*hModule*/, 
                       DWORD  ul_reason_for_call, 
                       LPVOID /*lpReserved*/ )
{
    switch( ul_reason_for_call ) {
    case DLL_PROCESS_ATTACH:
        break;
    case DLL_THREAD_ATTACH:
        break;
    case DLL_THREAD_DETACH:
        break;
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

void __cdecl Load( HWND mainWindow ) {
    MainWindow = mainWindow;
}

void __cdecl UnLoad() {
    return;
}

static TInfo Info = { sizeof( Info ),
                      "Hello! I am the TypeAndRun plugin.",
                      "Test plugin",
                      "4.5",
                      "description",
                      "author",
                      "copyright",
                      "www.homepage.com"
};

TInfo __cdecl GetInfo() {
    return Info;
}

int __cdecl GetCount() {
    return 1;
}

char* __cdecl GetString( int num ) {
    if( num == 0 )
        return "sample";
    else
        return "";
}


static TExec Executed = {sizeof( Executed ), 1, 0, 0, 0};
static TExec Skipped = {sizeof( Skipped ), 0, "", 0, 0};

TExec __cdecl RunString( char* exec ) {
    char sample[7];
    lstrcpyn( sample, exec, sizeof( sample ) / sizeof( *sample ) );
    if( !lstrcmp( sample, "sample" ) )
    {
        MessageBox( MainWindow, exec, "Sample Execution", 0 );
        return Executed;
    }
    else
        return Skipped;
}
