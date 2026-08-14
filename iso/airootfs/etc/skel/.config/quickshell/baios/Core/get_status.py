import subprocess
import json
import os

def get_volume():
    try:
        res = subprocess.run(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"], capture_output=True, text=True, check=True)
        line = res.stdout.strip()
        parts = line.split()
        if len(parts) >= 2:
            vol = float(parts[1])
            return vol
    except Exception:
        pass
    return 1.0

def get_wifi():
    try:
        res = subprocess.run(["nmcli", "radio", "wifi"], capture_output=True, text=True, check=True)
        return res.stdout.strip() == "enabled"
    except Exception:
        return False

def get_network():
    try:
        res = subprocess.run("nmcli -t -f name connection show --active | grep -v '^lo$' | head -n 1", shell=True, capture_output=True, text=True)
        net = res.stdout.strip()
        if net:
            return net
    except Exception:
        pass
    return "Disconnected"

def get_bluetooth():
    # Fallback to local state file to remember bluetooth toggle status
    state_file = "/tmp/baios_bluetooth_state"
    if os.path.exists(state_file):
        try:
            with open(state_file, "r") as f:
                return f.read().strip() == "on"
        except Exception:
            pass
    return False

def get_brightness():
    state_file = "/tmp/baios_brightness"
    if os.path.exists(state_file):
        try:
            with open(state_file, "r") as f:
                return float(f.read().strip())
        except Exception:
            pass
    return 1.0

def main():
    status = {
        "volume": get_volume(),
        "wifi": get_wifi(),
        "network": get_network(),
        "bluetooth": get_bluetooth(),
        "brightness": get_brightness()
    }
    print(json.dumps(status))

if __name__ == "__main__":
    main()
