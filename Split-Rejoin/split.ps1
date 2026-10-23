param([string]$Path = $PWD)

$ErrorActionPreference = 'Stop'
$chunk = 50MB
$magic = [Text.Encoding]::ASCII.GetBytes('PBSPLIT1')

# Embedded source name of a part, or $null for anything that is not one or cannot be read
function Get-PartName([string]$file) {
    try {
        $r = [IO.BinaryReader]::new([IO.File]::OpenRead($file))
        try {
            if ($r.BaseStream.Length -lt 84) { return $null }
            if (-not [Linq.Enumerable]::SequenceEqual([byte[]]$r.ReadBytes(8), $magic)) { return $null }
            $nameLen = $r.ReadInt32()
            if ($nameLen -lt 1 -or $nameLen -gt 1024) { return $null }
            [IO.Path]::GetFileName([Text.Encoding]::UTF8.GetString($r.ReadBytes($nameLen)))
        } finally { $r.Dispose() }
    } catch { $null }
}

Get-ChildItem -LiteralPath $Path -Filter *.pbix -File | ForEach-Object {
    $src       = $_
    $sha256    = [Security.Cryptography.SHA256]::Create()
    $nameBytes = [Text.Encoding]::UTF8.GetBytes($src.Name)
    $header    = 8 + 4 + $nameBytes.Length + 4 + 4 + 64
    $payload   = $chunk - $header                    # header + data = exactly 50MB per part
    $buf       = [byte[]]::new($payload)

    # Parts from any earlier split of this file, in either naming scheme, replaced once the new set is complete
    $stale = @(Get-ChildItem -LiteralPath $src.DirectoryName -Filter *.part* -File |
        Where-Object { [string]::Equals((Get-PartName $_.FullName), $src.Name, [StringComparison]::OrdinalIgnoreCase) })

    # Write the new set under .tmp names; on any failure remove it and leave the earlier parts alone
    $tmp = @()
    try {
        $in = [IO.File]::OpenRead($src.FullName)  # closed to writers, so the hash and the parts see the same bytes
        try {
            if ($in.Length -eq 0) { throw 'file is empty' }
            $total = [int][math]::Ceiling($in.Length / $payload)
            $sha   = [BitConverter]::ToString($sha256.ComputeHash($in)).Replace('-', '')
            $in.Position = 0
            # Part names never contain the source name, and stay the same while the name and content do
            $id    = [BitConverter]::ToString($sha256.ComputeHash([Text.Encoding]::UTF8.GetBytes($src.Name + $sha))).Replace('-', '').Substring(0, 12).ToLower()
            $i = 0
            while (($n = $in.Read($buf, 0, $buf.Length)) -gt 0) {
                $part = Join-Path $src.DirectoryName ('{0}.part{1:D3}.tmp' -f $id, $i)
                $w = [IO.BinaryWriter]::new([IO.File]::Create($part))
                $tmp += $part
                try {
                    $w.Write($magic)
                    $w.Write([int]$nameBytes.Length)
                    $w.Write($nameBytes)
                    $w.Write([int]$i)
                    $w.Write([int]$total)
                    $w.Write([Text.Encoding]::ASCII.GetBytes($sha))
                    $w.Write($buf, 0, $n)
                } finally { $w.Dispose() }
                $i++
            }
            if ($i -ne $total) { throw "wrote $i of $total part(s)" }
        } finally { $in.Dispose() }
    } catch {
        $err = $_
        $tmp | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | ForEach-Object { Remove-Item -LiteralPath $_ -Force }
        Write-Warning "Skipping '$($src.Name)': $($err.Exception.Message). Earlier parts left as they were"
        return
    }

    try {
        $stale | Where-Object { $tmp -notcontains $_.FullName } | Remove-Item -Force
        foreach ($t in $tmp) { [IO.File]::Move($t, ($t -replace '\.tmp$')) }
    } catch {
        Write-Warning "Could not finish '$($src.Name)': $($_.Exception.Message). Run split again once the parts are free"
        return
    }
    Write-Host "Split $($src.Name) into $total part(s): $id.part*"
}
