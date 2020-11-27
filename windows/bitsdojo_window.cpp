#include <stdio.h>
#include <windows.h>
#include <windowsx.h>
#include <dwmapi.h>
#include "bitsdojo_window.h"
#include "./include/bitsdojo_window/bitsdojo_window_plugin.h"

HWND flutter_window = nullptr;
HWND flutter_child_window = nullptr;
HHOOK flutterWindowMonitor = nullptr;
BOOL during_minimize = FALSE;
BOOL during_maximize = FALSE;
BOOL during_restore = FALSE;
BOOL bypass_wm_size = FALSE;
BOOL has_custom_frame = FALSE;
BOOL visible_on_startup = TRUE;
SIZE min_size = {0, 0};
SIZE max_size = {0, 0};

int bitsdojo_window_init();
auto bdw_init = bitsdojo_window_init();

LRESULT CALLBACK main_window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR subclassID, DWORD_PTR refData);
LRESULT CALLBACK child_window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR subclassID, DWORD_PTR refData);

LRESULT CALLBACK monitorFlutterWindowsProc(
    _In_ int code,
    _In_ WPARAM wparam,
    _In_ LPARAM lparam)
{
    if (code == HCBT_CREATEWND)
    {
        auto createParams = reinterpret_cast<CBT_CREATEWND *>(lparam);
        if (!createParams->lpcs->lpCreateParams)
        {
            return 0;
        }
        if (wcscmp(createParams->lpcs->lpszClass, L"FLUTTER_RUNNER_WIN32_WINDOW") == 0)
        {
            flutter_window = (HWND)wparam;
            SetWindowSubclass(flutter_window, main_window_proc, 1, NULL);
        }
        else if (wcscmp(createParams->lpcs->lpszClass, L"FLUTTERVIEW") == 0)
        {
            flutter_child_window = (HWND)wparam;
            SetWindowSubclass(flutter_child_window, child_window_proc, 1, NULL);
        }
    }
    if ((flutter_window != nullptr) && (flutter_child_window != nullptr))
    {
        UnhookWindowsHookEx(flutterWindowMonitor);
    }
    return 0;
}

void monitorFlutterWindows()
{
    DWORD threadID = GetCurrentThreadId();
    flutterWindowMonitor = SetWindowsHookEx(WH_CBT, monitorFlutterWindowsProc, NULL, threadID);
}

enum class AppState
{
    Unknown = 0,
    Starting,
    Ready,
};

AppState app_state = AppState::Unknown;

int bitsdojo_window_init()
{
    app_state = AppState::Starting;
    monitorFlutterWindows();
    return 1;
}

int bitsdojo_window_configure(unsigned int flags)
{
    has_custom_frame = (flags & BDW_CUSTOM_FRAME);
    visible_on_startup = !(flags & BDW_HIDE_ON_STARTUP);
    return 1;
}

extern "C" __declspec(dllexport) void setMinSize(int width, int height)
{
    min_size.cx = width;
    min_size.cy = height;
}

extern "C" __declspec(dllexport) void setMaxSize(int width, int height)
{
    max_size.cx = width;
    max_size.cy = height;
}

LRESULT CALLBACK main_window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR subclassID, DWORD_PTR refData);

extern "C" __declspec(dllexport)
    UINT8 getAppState()
{
    return (UINT8)app_state;
}

extern "C" __declspec(dllexport) void setAppState(UINT8 newState)
{
    app_state = AppState(newState);
}

extern "C" __declspec(dllexport)
    HWND getFlutterWindow()
{
    return flutter_window;
}

void forceChildRefresh()
{
    if (flutter_child_window == nullptr)
        return;

    RECT rc;
    GetClientRect(flutter_window, &rc);
    int width = rc.right - rc.left;
    int height = rc.bottom - rc.top;
    SetWindowPos(flutter_child_window, 0, 0, 0, width + 1, height + 1, SWP_NOMOVE | SWP_NOACTIVATE);
    SetWindowPos(flutter_child_window, 0, 0, 0, width, height, SWP_NOMOVE | SWP_NOACTIVATE);
}

int getResizeMargin(HWND window)
{
    UINT currentDpi = GetDpiForWindow(window);
    int resizeBorder = GetSystemMetricsForDpi(SM_CXSIZEFRAME, currentDpi);
    int borderPadding = GetSystemMetricsForDpi(SM_CXPADDEDBORDER, currentDpi);
    return resizeBorder + borderPadding;
}

void extendIntoClientArea(HWND hwnd)
{
    MARGINS margins = {0, 0, 1, 0};
    DwmExtendFrameIntoClientArea(hwnd, &margins);
}

LRESULT handle_nchittest(HWND window, WPARAM wparam, LPARAM lparam)
{
    POINT pt = {GET_X_LPARAM(lparam), GET_Y_LPARAM(lparam)};
    ScreenToClient(window, &pt);
    RECT rc;
    GetClientRect(window, &rc);
    int resizeMargin = getResizeMargin(window);
    if (pt.y < resizeMargin)
    {
        if (pt.x < resizeMargin)
        {
            return HTTOPLEFT;
        }
        if (pt.x > (rc.right - resizeMargin))
        {
            return HTTOPRIGHT;
        }
        return HTTOP;
    }
    if (pt.y > (rc.bottom - resizeMargin))
    {
        if (pt.x < resizeMargin)
        {
            return HTBOTTOMLEFT;
        }
        if (pt.x > (rc.right - resizeMargin))
        {
            return HTBOTTOMRIGHT;
        }
        return HTBOTTOM;
    }
    if (pt.x < resizeMargin)
    {
        return HTLEFT;
    }
    if (pt.x > (rc.right - resizeMargin))
    {
        return HTRIGHT;
    }
    return HTCLIENT;
}

LRESULT handle_nccalcsize(HWND window, WPARAM wparam, LPARAM lparam)
{
    if (wparam == FALSE)
    {
        return 0;
    }

    auto params = reinterpret_cast<NCCALCSIZE_PARAMS *>(lparam);

    auto initialRect = params->rgrc[0];
    DefSubclassProc(window, WM_NCCALCSIZE, wparam, lparam);
    params->rgrc[0] = initialRect;
    bool isMaximized = IsZoomed(window);
    if (isMaximized)
    {
        int resizeMargin = getResizeMargin(window);
        params->rgrc[0].left += resizeMargin;
        params->rgrc[0].top += resizeMargin;
        params->rgrc[0].right -= resizeMargin;
        params->rgrc[0].bottom -= resizeMargin;
    }
    return 0;
}

LRESULT CALLBACK child_window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR subclassID, DWORD_PTR refData)
{
    switch (message)
    {
    case WM_NCHITTEST:
    {
        if (has_custom_frame == FALSE)
        {
            break;
        }
        LRESULT result = handle_nchittest(window, wparam, lparam);
        if (result != HTCLIENT)
        {
            return HTTRANSPARENT;
        }
        break;
    }
    }
    return DefSubclassProc(window, message, wparam, lparam);
}

void adjustChildWindowSize()
{
    RECT clientRect;
    GetClientRect(flutter_window, &clientRect);
    int width = clientRect.right - clientRect.left;
    int height = clientRect.bottom - clientRect.top;
    SetWindowPos(flutter_child_window, 0, 0, 0, width, height, SWP_NOMOVE | SWP_NOACTIVATE);
}

void getSizeOnScreen(SIZE *size)
{
    UINT dpi = GetDpiForWindow(flutter_window);
    double scale_factor = dpi / 96.0;
    size->cx = static_cast<int>(size->cx * scale_factor);
    size->cy = static_cast<int>(size->cy * scale_factor);
}

bool centerOnMonitorContainingMouse(HWND window, int width, int height)
{
    MONITORINFO monitorInfo = {};
    monitorInfo.cbSize = DWORD(sizeof(MONITORINFO));

    POINT mousePosition;
    if (GetCursorPos(&mousePosition) == FALSE)
    {
        return false;
    }
    auto monitor = MonitorFromPoint(mousePosition, MONITOR_DEFAULTTONEAREST);
    if (GetMonitorInfoW(monitor, static_cast<LPMONITORINFO>(&monitorInfo)) == FALSE)
    {
        return false;
    }
    auto monitorWidth = monitorInfo.rcWork.right - monitorInfo.rcWork.left;
    auto monitorHeight = monitorInfo.rcWork.bottom - monitorInfo.rcWork.top;
    auto x = (monitorWidth - width) / 2;
    auto y = (monitorHeight - height) / 2;
    x += monitorInfo.rcWork.left;
    y += monitorInfo.rcWork.top;
    SetWindowPos(window, 0, x, y, 0, 0, SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE);
    return true;
}

LRESULT CALLBACK main_window_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR subclssID, DWORD_PTR refData)
{
    switch (message)
    {
    case WM_ERASEBKGND:
    {
        return 1;
    }
    case WM_NCCREATE:
    {
        flutter_window = window;
        auto style = GetWindowLongPtr(window, GWL_STYLE);
        style = style | WS_CLIPCHILDREN;
        SetWindowLongPtr(window, GWL_STYLE, style);
        SetProp(window, L"BitsDojoWindow", (HANDLE)(1));
        break;
    }
    case WM_NCHITTEST:
    {
        if (has_custom_frame == FALSE)
        {
            break;
        }
        return handle_nchittest(window, wparam, lparam);
    }
    case WM_NCCALCSIZE:
    {
        if (has_custom_frame == FALSE)
        {
            break;
        }
        return handle_nccalcsize(window, wparam, lparam);
    }
    case WM_CREATE:
    {
        auto createStruct = reinterpret_cast<CREATESTRUCT *>(lparam);
        LRESULT result = DefSubclassProc(window, message, wparam, lparam);
        if (has_custom_frame == TRUE)
        {
            extendIntoClientArea(window);
            SetWindowPos(window, nullptr, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_DRAWFRAME);
        }
        centerOnMonitorContainingMouse(window, createStruct->cx, createStruct->cy);
        if (visible_on_startup == TRUE)
        {
            setAppState((UINT8)AppState::Ready);
            forceChildRefresh();
        }
        return result;
    }
    case WM_DPICHANGED:
    {
        forceChildRefresh();
        break;
    }
    case WM_SIZE:
    {
        if (during_minimize == TRUE) {
                return 0;
        }
        if (bypass_wm_size == TRUE)
        {
            return DefWindowProc(window, message, wparam, lparam);
        }
        break;
    }
    case WM_SYSCOMMAND:
    {
        if (wparam == SC_MINIMIZE)
        {
            during_minimize = TRUE;
        }
        if (wparam == SC_MAXIMIZE)
        {
            during_maximize = TRUE;
        }
        if (wparam == SC_RESTORE)
        {
            during_restore = TRUE;
        }
        LRESULT result = DefSubclassProc(window, message, wparam, lparam);
        during_minimize = FALSE;
        during_maximize = FALSE;
        during_restore = FALSE;
        return result;
    }
    case WM_WINDOWPOSCHANGING:
    {
        auto winPos = reinterpret_cast<WINDOWPOS *>(lparam);

        BOOL isShowWindow = ((winPos->flags & SWP_SHOWWINDOW) == SWP_SHOWWINDOW);
        if ((isShowWindow == TRUE) && (app_state != AppState::Ready) && (visible_on_startup == FALSE))
        {
            winPos->flags &= ~SWP_SHOWWINDOW;
        }

        break;
    }
    case WM_WINDOWPOSCHANGED:
    {
        auto winPos = reinterpret_cast<WINDOWPOS *>(lparam);
        bool isResize = !(winPos->flags & SWP_NOSIZE);

        if (app_state != AppState::Ready)
        {
            break;
        }
        if (bypass_wm_size == TRUE)
        {
            if (isResize && (!during_minimize) && (winPos->cx != 0))
            {
                adjustChildWindowSize();
            }
        }
        break;
    }
    case WM_GETMINMAXINFO:
    {
        auto info = reinterpret_cast<MINMAXINFO *>(lparam);
        if ((min_size.cx != 0) && (min_size.cy != 0))
        {
            SIZE minSize = min_size;
            getSizeOnScreen(&minSize);
            info->ptMinTrackSize.x = minSize.cx;
            info->ptMinTrackSize.y = minSize.cy;
        }
        if ((max_size.cx != 0) && (max_size.cy != 0))
        {
            SIZE maxSize = max_size;
            getSizeOnScreen(&maxSize);
            info->ptMaxTrackSize.x = maxSize.cx;
            info->ptMaxTrackSize.y = maxSize.cy;
        }
        return 0;
    }
    case WM_EXITSIZEMOVE:
    {
        forceChildRefresh();
        break;
    }
    default:
        break;
    }
    return DefSubclassProc(window, message, wparam, lparam);
}

bool dragAppWindow()
{
    if (flutter_window == nullptr)
    {
        return false;
    }
    ReleaseCapture();
    SendMessage(flutter_window, WM_SYSCOMMAND, SC_MOVE | HTCAPTION, 0);
    return true;
}
