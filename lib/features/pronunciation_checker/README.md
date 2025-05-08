Add preLaunchTask launch.json

launch.json:
{
  "launch": {
    "configurations": [
        {
        "name": "Flutter",
        "request": "launch",
        "type": "dart",
        "program": "lib/main.dart",
        "preLaunchTask": "Run Python API"
      }
    ]
  }
}


Phải chỉnh tasks.json để chạy preLaunchTask pronunciation_checker_api.py

tasks.json:
        {
            "label": "Run Python API",
            "type": "shell",
            "command": "python",
            "args": ["lib/features/pronunciation_checker/models/api.py"],
            "problemMatcher": [],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "Task to run the Python API script"
        }
