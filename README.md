# Restart CoreAudio

A small AppleScript utility that force-stops matching Core Audio processes on macOS, allowing the system to recover its audio service.

## Why this exists

I made this because audio on my MacBook with Apple silicon would sometimes stop working correctly. Restarting Core Audio was the workaround that restored audio for me. Saving the command as a desktop application made it convenient to repeat when the problem returned.

This repository shares that original script so others can inspect it, use it, and improve it. It is a recovery workaround, not a diagnosis or a permanent fix for the underlying problem. The experience above is the author's report; this project does not establish that every M-series Mac has the same issue or that restarting Core Audio is the only possible solution.

## Original code

```applescript
on run
    do shell script "kill -9 $(ps ax | grep 'coreaudio[a-z]' | awk '{print $1}' )" with administrator privileges
end run
```

The original compiled AppleScript is preserved byte-for-byte in [`original/main.scpt`](original/main.scpt). The readable [`src/restart-coreaudio.applescript`](src/restart-coreaudio.applescript) was extracted from it with macOS `osadecompile`. Its behavior has not been modified.

## Requirements

- macOS, with its built-in AppleScript tools or Script Editor.
- An administrator account or administrator credentials for the authorization prompt.
- An audio session you can interrupt: stop recordings, calls, and playback before running it.

The author's use case is an M-series MacBook. No macOS-version or hardware compatibility matrix has been verified. Windows and Linux are not supported by this AppleScript.

## Get the source

```sh
git clone https://github.com/mrHeinrichh/restart-coreaudio.git
cd restart-coreaudio
```

## Run from Terminal

Review the source first, then run:

```sh
osascript src/restart-coreaudio.applescript
```

macOS may request administrator authorization. Credentials are handled by macOS, not stored by the script. Cancelling authorization prevents the privileged command from running.

Running the archived original is also possible:

```sh
osascript original/main.scpt
```

Both commands perform the restart attempt; they are not preview or diagnostic commands.

## Make a desktop application

1. Open `src/restart-coreaudio.applescript` in Script Editor.
2. Choose **File → Export**.
3. Set the file format to **Application** and name it **Restart CoreAudio**.
4. Save it to your Desktop. Leave **Stay open after run handler** disabled.
5. Double-click the exported app whenever you want to run the workaround.

Alternatively, build an application from Terminal without running it:

```sh
mkdir -p build
osacompile -o "build/Restart CoreAudio.app" src/restart-coreaudio.applescript
```

You can then move the generated application to your Desktop. This builds a local app; the project does not provide a notarized release or installer.

## What to expect

The script requests privileged execution and sends `SIGKILL` to PIDs selected by its process-list filter. Audio may stop briefly; the intended recovery relies on macOS restarting its managed audio service. The script does not explicitly launch the service, wait for recovery, or verify that sound works afterward.

Once it finishes, test playback and check your selected output device. Some audio applications may need to be reopened. There is no custom success dialog. Completion alone does not prove audio recovered.

## Limitations and troubleshooting

- The original filter matches process command lines containing `coreaudio` followed by a lowercase letter. It is broader than an exact match for `coreaudiod`.
- `kill -9` force-stops processes without graceful cleanup. Active calls, recordings, and playback can be interrupted.
- If no PIDs match, the command can fail with a shell error. Authorization or process-exit races can also cause errors.
- If audio remains broken, check the output device and connections, reopen the affected app, and consider restarting macOS or contacting Apple Support. Repeatedly running this script does not fix an underlying hardware or software fault.
- No runtime recovery test was performed during repository preparation because that would interrupt the current computer's audio.

See [technical details](docs/how-it-works.md) for the command breakdown and [provenance](docs/provenance.md) for preservation and validation details.

## Contributing and license

See [CONTRIBUTING.md](CONTRIBUTING.md) for bug reports and changes. Project code and documentation are released under the [MIT License](LICENSE). The Apple-generated application wrapper is not included in this repository.
