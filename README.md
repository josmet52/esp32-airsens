# AirSens — partie Raspberry Pi

> Fait partie du dépôt [airsens](../README.md). Capteurs et centrale : [esp32-airsens-v3](../esp32-airsens-v3/README.md). Outils PC : [PC-airsens](../PC-airsens/README.md).

Le Raspberry Pi (192.168.1.165) héberge le broker MQTT et la base de données, et enregistre en continu les mesures des capteurs.

## Services sur le Pi

| Service | Rôle |
|---|---|
| `mosquitto` | Broker MQTT (topic `airsens_v3`) |
| `mariadb` | Base `airsens`, table `airsens_v3` |
| `airsens_v3` | Lance `airsens_v3.py` : abonné MQTT → MariaDB |

## Contenu

| Fichier | Rôle |
|---|---|
| `airsens_v3.py` | Script lancé par le service : reçoit les messages MQTT et les enregistre dans MariaDB |
| `airsens_v3.service` | Fichier systemd (copie de référence, l'actif est dans `/etc/systemd/system/`) |
| `airsens_v3_mqtt_monitor.py` | Ancienne version du script MQTT avec alerte e-mail |
| `airsens_bat_graph.ipynb` | Notebook de graphiques (batteries, température, humidité, pression) |
| `airsens_graph_batt.py`, `airsens_v3_graph_batt-*.py` | Scripts autonomes de graphiques batterie (variantes axe en jours / en dates) |
| `doc_airsens_notebook.md` | Mode d'emploi du notebook via VS Code Remote-SSH |
| `sql/` | Scripts de création de la base et des tables |
| `backup_pi.sh`, `sync_kdrive.sh` | Scripts de sauvegarde et de synchronisation kDrive |
| `requirements_rpi.txt` | Modules Python nécessaires |

## Format des données

Message MQTT : `topic/sensor_mac/sensor_name/sensor_type/{'temp': .., 'hum': .., 'pres': .., 'bat': ..}`

Chaque grandeur devient une ligne de `airsens_v3` : `id`, `time_stamp`, `sensor_mac`, `sensor_name`, `sensor_type`, `measure` (`bat`, `temp`, `hum`, `pres`), `value`.

## Installation du service

sudo cp airsens_v3.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now airsens_v3
sudo systemctl status airsens_v3
journalctl -u airsens_v3 -f


Le service utilise le Python du système (`/usr/bin/python3`) : les modules sont installés avec `pip install ... --break-system-packages`.

## Graphiques

Voir [doc_airsens_notebook.md](doc_airsens_notebook.md) : ouvrir `airsens_bat_graph.ipynb` dans VS Code connecté en Remote-SSH au Pi.
