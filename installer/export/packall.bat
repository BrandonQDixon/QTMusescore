call electron-packager "../" "Quarter-Tone-Plugin-Musescore" --all

call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-darwin-x64.zip .\Quarter-Tone-Plugin-Musescore-darwin-x64\*
call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-linux-arm64.zip .\Quarter-Tone-Plugin-Musescore-linux-arm64\*
call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-linux-arm71.zip .\Quarter-Tone-Plugin-Musescore-linux-arm71\*
call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-linux-ia32.zip .\Quarter-Tone-Plugin-Musescore-linux-ia32\*
call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-linux-x64.zip .\Quarter-Tone-Plugin-Musescore-linux-x64\*
call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-mas-x64.zip .\Quarter-Tone-Plugin-Musescore-mas-x64\*

call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-win32-x64.7z .\Quarter-Tone-Plugin-Musescore-win32-x64\*
call "C:\Program Files\7-Zip\7z.exe" a Quarter-Tone-Plugin-Musescore-win32-ia32.7z .\Quarter-Tone-Plugin-Musescore-win32-ia32\*
copy /b 7zS.sfx + config.txt + Quarter-Tone-Plugin-Musescore-win32-x64.7z Quarter-Tone-Plugin-Musescore-win32-x64.exe
copy /b 7zS.sfx + config.txt + Quarter-Tone-Plugin-Musescore-win32-ia32.7z Quarter-Tone-Plugin-Musescore-win32-ia32.exe