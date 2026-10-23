param([string]$Path = $PWD)

$Path  = (Resolve-Path -LiteralPath $Path).ProviderPath
$magic = [Text.Encoding]::ASCII.GetBytes('PBSPLIT1')

# Probe every file for the magic header; anything else is skipped, whatever it is called
$parts = foreach ($f in Get-ChildItem -LiteralPath $Path -File) {
    $r = [IO.BinaryReader]::new([IO.File]::OpenRead($f.FullName))
    try {
        if ($r.BaseStream.Length -lt 84) { continue }
        if (-not [Linq.Enumerable]::SequenceEqual([byte[]]$r.ReadBytes(8), $magic)) { continue }
        $nameLen = $r.ReadInt32()
        if ($nameLen -lt 1 -or $nameLen -gt 1024) { continue }
        [pscustomobject]@{
            Path   = $f.FullName
            Name   = [IO.Path]::GetFileName([Text.Encoding]::UTF8.GetString($r.ReadBytes($nameLen)))
            Index  = $r.ReadInt32()
            Total  = $r.ReadInt32()
            Sha    = [Text.Encoding]::ASCII.GetString($r.ReadBytes(64))
            Offset = 84 + $nameLen
        }
    } finally { $r.Dispose() }
}

$parts | Group-Object Name | ForEach-Object {
    if (@($_.Group.Sha | Select-Object -Unique).Count -gt 1) {
        Write-Warning "Skipping '$($_.Name)': parts from more than one version of the file, keep one set and delete the other"
        return
    }
    $set  = @($_.Group | Sort-Object Index)          # @() so a one-part set still has a Count in PowerShell 5.1
    $want = $set[0].Total
    if ($set.Count -ne $want -or ($set.Index -join ',') -ne ((0..($want - 1)) -join ',')) {
        Write-Warning "Skipping '$($_.Name)': have $($set.Count) of $want part(s), or bad sequence"
        return
    }
    $dst = Join-Path $Path $_.Name
    $out = [IO.File]::Create($dst)
    try {
        foreach ($p in $set) {
            $in = [IO.File]::OpenRead($p.Path)
            try { $in.Position = $p.Offset; $in.CopyTo($out) } finally { $in.Dispose() }
        }
    } finally { $out.Dispose() }

    if ((Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash -eq $set[0].Sha) {
        Write-Host "OK: $($_.Name) reassembled, hash verified"
    } else {
        Write-Warning "HASH MISMATCH: $($_.Name), do not trust this file"
    }
}
