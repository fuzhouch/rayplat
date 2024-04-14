#include "raymain.h"

#if defined(_WIN32)
#include <windows.h>
int WinMain(HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR lpCmdLine,
    int nShowCmd)
#else
int main(int argc, char* argv[])
#endif
{
    return rayMain();
}
