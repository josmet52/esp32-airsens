# AirSens — Notebook graphiques VS Code

## Projet
Capteurs ESP32 sans fil (WiFi/MQTT) qui mesurent température, humidité, pression et tension batterie.  
Les données sont stockées dans MariaDB sur le Pi via MQTT.

## Base de données

| Paramètre | Valeur |
|---|---|
| IP | `192.168.1.165` |
| User | `pi` |
| Password | `mablonde` |
| DB | `airsens` |
| Table | `airsens_v3` |

**Colonnes de `airsens_v3` :**
- `id`, `time_stamp` — identifiant et horodatage
- `sensor_mac`, `sensor_name`, `sensor_type` — identification du capteur
- `measure` — type de mesure : `bat`, `temp`, `hum`, `pres`
- `value` — valeur numérique

## Capteurs actifs

| sensor_name | Description |
|---|---|
| `mtl-2` | BME280, Li-Ion 1S2P, intervalle 5 min |
| `myst` | HDC1080, Li-Ion 1S1P, intervalle 5 min |
| `solar` | BME280, Li-Ion 1S1P, intervalle 5 min |
| `first_1` | HDC1080, Li-Ion 1S1P, intervalle 5 min |

## Ouvrir le notebook dans VS Code

1. `Ctrl+Shift+P` → **Remote-SSH: Connect to Host** → `pi@192.168.1.165`
2. Vérifier barre verte en bas : `SSH: 192.168.1.165`
3. Ouvrir `/home/pi/projets_jo/rpi-airsens/airsens_bat_graph.ipynb`
4. Sélectionner kernel Python 3 (bouton en haut à droite)
5. **Ctrl+F9** pour tout lancer

## Contenu du notebook `airsens_bat_graph.ipynb`

| Cellule | Graphique |
|---|---|
| 1 | Import + connexion DB + résumé des mesures |
| 2 | Batteries — durée de vie complète (tous capteurs, axe en jours) |
| 3 | Batteries — dernières 24h (axe en dates) |
| 4 | Température & Humidité — dernières 24h |
| 5 | Pression atmosphérique — dernières 24h (BME280 uniquement) |

## Modifier la période

Changer `HOURS = 24` dans chaque cellule :
- `HOURS = 48` → 2 jours
- `HOURS = 168` → 1 semaine

## Librairies requises (à installer sur le Pi une seule fois)

```bash
pip install ipykernel pymysql pandas matplotlib --break-system-packages
pip install "matplotlib_inline<0.2" --break-system-packages
```

## Dépannage

| Problème | Solution |
|---|---|
| `ModuleNotFoundError: pymysql` | `pip install pymysql --break-system-packages` |
| `AttributeError: RcParams._get` | `pip install "matplotlib_inline<0.2" --break-system-packages` |
| Kernel non trouvé | `pip install ipykernel --break-system-packages` |
| Pas de données | Vérifier que `airsens_v3.service` tourne : `sudo systemctl status airsens_v3` |
| Bouton "Install additional debugger" | Installer l'extension Python côté SSH dans VS Code |

## Script original

`airsens_graph_batt.py` — script autonome (sans notebook) qui affiche les mêmes graphiques batterie. Nécessite un écran connecté au Pi (utilise `screeninfo` + `plt.show()`). Le notebook est préférable via VS Code Remote SSH.
