# APPlayMIDI
_A simple MIDI file player for MacOS._

Ever since 2009, when Apple deprecated the 32-bit QuickTime framework in favour of the newer AVKit, the Mac's flagship media player, QuickTime Player X has refused to play MIDI files. (Despite MIDI file types being associated with the app!)

The AVKit framework contains a perfectly good player for MIDI files: AVMIDIPlayer, so there's no excuse for not having an app that plays MIDI files. Here's my lightweight implementation.

![alt text](img/window.png)

Runs on Sierra (10.12) and above. (It could conceivably be 'updated' to support older OSes, as there's nothing particularly new in it.)  
Each document window contains a slider that both indicates and sets the current play position, and a 'rewind' button to return to the start of the track. Numerical counters show the play position and total duration.

The app contains one other feature: it can Copy the MIDI data from a document to the clipboard, so it can be pasted into apps that support pasting MIDI data.

Known apps that support MIDI pasteboard include: Finale. (Let me know of others.)

### Installation ###
Click on the Releases link above, or here: https://github.com/benwiggy/APPlayMIDI/releases. Download, unzip and move to the /Applications folder. You may want to make APPlayMIDI the default file for opening MIDI files. Select a MIDI file, then _Get Info_ (File menu or Command I) select "APPlayMIDI", and then click "Change All".

The source files are included, for anyone who wants to add functionality or use them as the basis of a new app.

### Future ###  
It would be nice to offer QuickLook previews of MIDI files in the Finder, but currently, QL plug-ins cannot be written in Swift.

v.1.01 fixes an issue where document windows did not cascade.
v.1.02 The app has been code-signed and so should launch more easily when first installed. 

### Licence ###  
The binary and source code are made available under the terms of the MIT Licence:

(c) 2019 Ben Byram-Wigfield

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
