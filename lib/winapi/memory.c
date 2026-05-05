// SPDX-License-Identifier: MIT

// SPDX-FileCopyrightText: 2019-2020 Stefan Schmidt
// SPDX-FileCopyrightText: 2026 John Grogan

#include <assert.h>

#include <memoryapi.h>
#include <winbase.h>
#include <winerror.h>
#include <xboxkrnl/xboxkrnl.h>

LPVOID VirtualAlloc (LPVOID lpAddress, SIZE_T dwSize, DWORD flAllocationType, DWORD flProtect)
{
    NTSTATUS status;

    assert(KeGetCurrentIrql() < DISPATCH_LEVEL);

    status = NtAllocateVirtualMemory(&lpAddress, 0, &dwSize, flAllocationType, flProtect);
    if (!NT_SUCCESS(status)) {
        SetLastError(RtlNtStatusToDosError(status));
        return NULL;
    }

    return lpAddress;
}

BOOL VirtualFree (LPVOID lpAddress, SIZE_T dwSize, DWORD dwFreeType)
{
    NTSTATUS status;

    if ((dwFreeType & MEM_RELEASE) && dwSize != 0) {
        SetLastError(ERROR_INVALID_PARAMETER);
        return FALSE;
    }

    status = NtFreeVirtualMemory(&lpAddress, &dwSize, dwFreeType);
    if (!NT_SUCCESS(status)) {
        SetLastError(RtlNtStatusToDosError(status));
        return FALSE;
    }

    return TRUE;
}

SIZE_T VirtualQuery (LPCVOID lpAddress, PMEMORY_BASIC_INFORMATION lpBuffer, SIZE_T dwLength)
{
    NTSTATUS status;

    status = NtQueryVirtualMemory((LPVOID)lpAddress, lpBuffer);

    if (!NT_SUCCESS(status)) {
        SetLastError(RtlNtStatusToDosError(status));
        return 0;
    }

    return sizeof(MEMORY_BASIC_INFORMATION);
}

VOID WINAPI ZeroMemory (PVOID Destination, SIZE_T length)
{
    RtlZeroMemory(Destination, length);
}

BOOL VirtualProtect (LPVOID lpAddress, SIZE_T dwSize, DWORD flNewProtect, PDWORD lpflOldProtect)
{
    NTSTATUS status;
    DWORD flOldProtect;

    assert(KeGetCurrentIrql() < DISPATCH_LEVEL);
    
    if (!lpflOldProtect || dwSize == 0) {
        SetLastError(ERROR_INVALID_PARAMETER);
        return FALSE;
    }

    status = NtProtectVirtualMemory(&lpAddress, &dwSize, flNewProtect, &flOldProtect);
    if (!NT_SUCCESS(status)) {
        SetLastError(RtlNtStatusToDosError(status));
        return FALSE;
    }

    *lpflOldProtect = flOldProtect;
    return TRUE;
}

SIZE_T GetLargePageMinimum (VOID)
{
    // NtAllocateVirtualMemory treats MEM_LARGE_PAGES as an invalid param
    return 0;
}
