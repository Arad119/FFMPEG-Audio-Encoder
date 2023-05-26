@echo off

setlocal enabledelayedexpansion

:input_filename_selection
cls
set /p "input_file=Enter the input filename (without extension): "

rem Check if the input file exists
if not exist "!input_file!.mkv" (
    echo Input file does not exist.
    timeout /t 2 >nul
    goto input_filename_selection
)

:channel_selection
cls
echo Select the number of audio channels:
echo 1. Stereo (2 channels)
echo 2. 5.1 Surround (6 channels)
set /p "channel_choice=Enter your choice (1 or 2): "

if "!channel_choice!"=="1" (
    set "audio_channels=2"
) else if "!channel_choice!"=="2" (
    set "audio_channels=6"
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto channel_selection
)

:output_filename_selection
cls
echo Select the output filename (with suffix if it's the same as input name):
echo 1. Same as input name
echo 2. Fixed name: output
echo 3. Custom name
set /p "output_option=Enter your choice (1, 2, or 3): "

if "!output_option!"=="1" (
    set "output_filename=!input_file!"
    if "!output_filename!"=="!input_file!" (
        set "output_filename=!input_file!_modified"
    )
    set "output_filename=!output_filename!.mkv"
) else if "!output_option!"=="2" (
    set "output_filename=output"
    if "!output_filename!"=="!input_file!" (
        set "output_filename=!input_file!_modified"
    )
    set "output_filename=!output_filename!.mkv"
) else if "!output_option!"=="3" (
    set /p "output_filename=Enter the custom output filename (without extension): "
    if "!output_filename!"=="!input_file!" (
        set "output_filename=!input_file!_modified"
    )
    set "output_filename=!output_filename!.mkv"
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto output_filename_selection
)

rem Run ffmpeg command
ffmpeg -i "!input_file!.mkv" -map 0:v -map 0:a -c:v copy -c:a aac -ac !audio_channels! -b:a 384k "!output_filename!"

endlocal
pause
