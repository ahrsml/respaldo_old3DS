#!/bin/bash
# Copia de la SD de la 3DS al repo lo que no se puede volver a bajar
# (partidas, configs, capturas), anota qué juegos hay y sube los cambios.
# Uso: ./guardar.sh [carpeta de la SD]   (sin carpeta, la busca sola)
set -e
repo="$(cd "$(dirname "$0")" && pwd)"

sd="$1"
if [[ -z "$sd" ]]; then
    for m in /run/media/"$USER"/*; do
        [[ -d "$m/Nintendo 3DS" && -d "$m/luma" ]] && sd="$m" && break
    done
fi
if [[ -z "$sd" || ! -d "$sd/Nintendo 3DS" ]]; then
    echo "No encuentro la SD de la 3DS. Conéctala o pasa la carpeta: ./guardar.sh /ruta/a/la/sd"
    exit 1
fi
echo "SD: $sd"

rm -rf "$repo/sd"
mkdir -p "$repo/sd"
while IFS= read -r ruta; do
    [[ -z "$ruta" || "$ruta" == \#* ]] && continue
    [[ -e "$sd/$ruta" ]] || continue
    mkdir -p "$repo/sd/$(dirname "$ruta")"
    cp -a "$sd/$ruta" "$repo/sd/$ruta"
done < "$repo/lista.txt"

# GitHub no acepta archivos de más de 100 MB: los que pasen de 50 MB se avisan y se sacan
find "$repo/sd" -type f -size +50M -print -delete | sed 's|^|Muy grande, no se sube: |'

# Lista de juegos (los juegos en sí no se suben)
{
    echo "# Juegos en la SD ($(date '+%Y-%m-%d'))"
    echo
    echo "## 3DS instalados"
    echo
    declare -A nombres
    for d in "$sd/3ds/Checkpoint/saves"/* "$sd/3ds/Checkpoint/extdata"/*; do
        [[ -d "$d" ]] || continue
        b="$(basename "$d")"
        nombres["${b%% *}"]="${b#* }"
    done
    for t in "$sd/Nintendo 3DS"/*/*/title/00040000/*; do
        [[ -d "$t" ]] || continue
        id="$(basename "$t")"
        clave="0x$(echo "${id:2:5}" | tr a-f A-F)"
        printf -- "- 00040000%s  %s  %s\n" "$id" "$(du -sh "$t" | cut -f1)" "${nombres[$clave]:-(sin nombre: no tiene respaldo en Checkpoint)}"
    done
    for carpeta in nds gba dsi; do
        roms=$(find "$sd/roms/$carpeta" -maxdepth 1 -type f ! -name 'Place *' -printf '%f\n' 2>/dev/null | sort)
        [[ -z "$roms" ]] && continue
        echo
        echo "## ROMs de ${carpeta^^}"
        echo
        echo "$roms" | sed 's/^/- /'
    done
} > "$repo/juegos.md"

cd "$repo"
git add -A
if git diff --cached --quiet; then
    echo "No hay cambios."
    exit 0
fi
git commit -q -m "Respaldo $(date '+%Y-%m-%d %H:%M')"
git pull -q --rebase origin main 2>/dev/null || true
git push -q -u origin main && echo "Listo, respaldo subido."
