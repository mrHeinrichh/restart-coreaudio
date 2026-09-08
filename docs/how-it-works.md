# How the original script works

## Execution flow

The `on run` handler executes when the script or exported application is run. AppleScript's `do shell script` runs the enclosed shell command. `with administrator privileges` requests privileged execution through macOS authorization.

The command is:

```sh
kill -9 $(ps ax | grep 'coreaudio[a-z]' | awk '{print $1}' )
```

| Part | Purpose |
| --- | --- |
| `ps ax` | Lists processes, including processes without a controlling terminal. |
| `grep 'coreaudio[a-z]'` | Selects lines containing `coreaudio` immediately followed by a lowercase letter. This matches `coreaudiod`, but is not an exact executable-name check. |
| `awk '{print $1}'` | Extracts the first whitespace-separated field, which is the PID in this process listing. |
| `$(...)` | Substitutes the resulting PIDs into the surrounding command. |
| `kill -9` | Sends signal 9 (`SIGKILL`) to each selected PID. |

The bracket expression also avoids matching the literal `coreaudio[a-z]` text in the filter command itself. It does not make the filter an exact process-name match: other command lines containing matching text can be selected.

## Why stopping the process can help

The intended mechanism is to discard a stuck audio-service process so macOS can start a fresh instance of its managed service. The script itself only sends a signal; it does not implement service supervision or guarantee recovery. This is why the project describes the action as a restart attempt and the result as a workaround.

## Privileges and data handling

The shell command runs with administrator privileges. The source contains no credential storage, network requests, telemetry, file writes, installation steps, or persistent background agent. It reads the local process list and signals matching processes. The elevated process selection should be reviewed before use.

## Failure behavior

There is no explicit error handler, retry, logging, completion notification, or post-run health check. AppleScript can surface errors from authorization or the shell command. With an empty match set, `kill` receives no process arguments and may report an error. A process can also exit between listing and signaling. With several targets, an error does not mean every signal failed: some processes may already have been stopped.

`SIGKILL` does not allow graceful cleanup. Save work and stop audio sessions before use. The script does not restore application state or select an output device.

## Scope of this publication

This publication preserves the original behavior. Exact process matching, clearer error handling, and recovery verification are possible future improvements, not features currently implemented. Proposed changes should be reviewed separately from the archived original.
