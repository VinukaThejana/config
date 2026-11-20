"""Build an unsigned "Convert to PDF" Finder Quick Action shortcut.

Usage: build_shortcut.py <script.zsh> <out.shortcut>
The shortcut runs the zsh script with the selected files as arguments.
"""
import plistlib
import sys
from pathlib import Path

script_path, out_path = sys.argv[1:]

shortcut_input = {
    "Value": {"Type": "ExtensionInput"},
    "WFSerializationType": "WFTextTokenAttachment",
}

doc = {
    "WFWorkflowMinimumClientVersion": 900,
    "WFWorkflowMinimumClientVersionString": "900",
    "WFWorkflowIcon": {"WFWorkflowIconStartColor": 4282601983, "WFWorkflowIconGlyphNumber": 59511},
    "WFWorkflowTypes": ["QuickActions"],
    "WFQuickActionSurfaces": ["Finder"],
    "WFWorkflowInputContentItemClasses": ["WFGenericFileContentItem"],
    "WFWorkflowHasShortcutInputVariables": True,
    "WFWorkflowImportQuestions": [],
    "WFWorkflowActions": [
        {
            "WFWorkflowActionIdentifier": "is.workflow.actions.runshellscript",
            "WFWorkflowActionParameters": {
                "Script": Path(script_path).read_text(),
                "Shell": "/bin/zsh",
                "InputMode": "as arguments",
                "Input": shortcut_input,
            },
        }
    ],
}

Path(out_path).write_bytes(plistlib.dumps(doc, fmt=plistlib.FMT_BINARY))
