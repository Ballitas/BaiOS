import os
import json
import configparser

def get_wallpapers():
    config_path = os.path.expanduser("~/.config/waypaper/config.ini")
    wallpaper_dir = os.path.expanduser("~/documentos/Wallpapers")
    current_wallpaper = ""
    
    if os.path.exists(config_path):
        try:
            config = configparser.ConfigParser()
            config.read(config_path)
            if 'Settings' in config:
                if 'folder' in config['Settings']:
                    folder = config['Settings']['folder']
                    wallpaper_dir = os.path.expanduser(folder)
                if 'wallpaper' in config['Settings']:
                    current_wallpaper = os.path.abspath(os.path.expanduser(config['Settings']['wallpaper']))
        except Exception:
            pass

    wallpapers = []
    if os.path.exists(wallpaper_dir) and os.path.isdir(wallpaper_dir):
        for f in os.listdir(wallpaper_dir):
            if f.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
                path = os.path.abspath(os.path.join(wallpaper_dir, f))
                is_active = (path == current_wallpaper)
                wallpapers.append({
                    "name": f,
                    "path": path,
                    "active": is_active
                })
    
    wallpapers.sort(key=lambda x: x["name"].lower())
    return wallpapers

if __name__ == "__main__":
    print(json.dumps(get_wallpapers()))
