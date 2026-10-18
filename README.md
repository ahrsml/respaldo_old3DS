# Respaldo Old 3DS XL

Partidas, configs y capturas de mi Old 3DS XL (Luma3DS + TWiLight Menu++).
Los juegos, las ROMs y el respaldo de la NAND no van aquí: pesan demasiado
para GitHub. Están en `~/3ds-respaldo/` en el ThinkPad.

## Cómo respaldar

1. En la consola, abre **Checkpoint** y respalda las partidas de los juegos de
   3DS (botón Y en cada juego, o seleccionar varios). Las partidas de los
   juegos instalados quedan cifradas en la SD y solo sirven si pasan por
   Checkpoint.
2. Apaga la consola, saca la SD y conéctala al ThinkPad.
3. Corre `./guardar.sh`. Busca la SD sola, copia todo y lo sube.

Para guardar algo más, agrega su ruta a `lista.txt`.

## Qué hay

| Carpeta | Qué es |
|---|---|
| `sd/3ds/Checkpoint/` | Partidas de 3DS exportadas con Checkpoint |
| `sd/roms/nds/saves/` | Partidas de los juegos de DS |
| `sd/luma/config.ini` | Config de Luma3DS |
| `sd/_nds/` | Config de TWiLight Menu++ y nds-bootstrap |
| `sd/gm9/scripts/` | Scripts de GodMode9 |
| `sd/DCIM/` | Capturas y videos de la consola |
| `juegos.md` | Lista de juegos instalados y ROMs, para saber qué reinstalar |

## Cómo restaurar una partida

- **3DS:** copia la carpeta del juego a `3ds/Checkpoint/saves/` en la SD, abre
  Checkpoint, elige el juego y la partida, y aprieta X para restaurar.
- **DS:** copia el `.sav` a `roms/nds/saves/` con el mismo nombre que la ROM.
