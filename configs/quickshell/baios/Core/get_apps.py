import os
import re
import json

def get_apps():
    apps = []
    seen = set()
    dirs = [
        "/usr/share/applications",
        os.path.expanduser("~/.local/share/applications")
    ]
    for d in dirs:
        if not os.path.exists(d):
            continue
        for f in os.listdir(d):
            if not f.endswith(".desktop"):
                continue
            path = os.path.join(d, f)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as file:
                    content = file.read()
                
                # Check for NoDisplay
                if re.search(r"^NoDisplay\s*=\s*true", content, re.MULTILINE | re.IGNORECASE):
                    continue
                
                # Extract Name
                name_match = re.search(r"^Name\s*=\s*(.+)", content, re.MULTILINE)
                exec_match = re.search(r"^Exec\s*=\s*(.+)", content, re.MULTILINE)
                
                if name_match and exec_match:
                    name = name_match.group(1).strip()
                    cmd_str = exec_match.group(1).strip()
                    
                    # Clean up exec command (remove %u, %F, %U, %f, etc.)
                    cmd_str = re.sub(r"%[fFuUivDd]", "", cmd_str).strip()
                    
                    if not name or not cmd_str:
                        continue
                        
                    import shlex
                    try:
                        cmd = shlex.split(cmd_str)
                    except Exception:
                        cmd = cmd_str.split()
                        
                    if not cmd:
                        continue
                        
                    app_key = name.lower()
                    if app_key not in seen:
                        seen.add(app_key)
                        apps.append({"name": name, "command": cmd})
            except Exception as e:
                pass
                
    apps.sort(key=lambda x: x["name"].lower())
    return apps

if __name__ == "__main__":
    print(json.dumps(get_apps()))
