//
//  PreviewViewController.swift
//  qlMIDI
//
//  Created by Ben on 04/07/2022.
//  Copyright © 2022 Ben. All rights reserved.
//

import Cocoa
import Quartz
import AVFoundation

class PreviewViewController: NSViewController, QLPreviewingController {


    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }

    var viewMIDIPlayer: AVMIDIPlayer!

    @IBOutlet weak var finderView: NSView!

    @IBOutlet weak var quickLookView: NSView!
    
    @IBOutlet weak var currentPlaybackTimeLabel: NSTextField!
    @IBOutlet weak var totalTimeLabel: NSTextField!
    @IBOutlet weak var filenameLabel: NSTextField!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var theSlider: NSProgressIndicator!

    @IBOutlet weak var restartButton: NSButton!
    
    @IBOutlet weak var finderRestartButton: NSButton!
    @IBOutlet weak var finderPlayButton: NSButton!
    @IBOutlet weak var finderProgressCircle: NSProgressIndicator!
    


    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
        preferredContentSize = CGSize(width: 800, height: 350)

        let v = (self.view as? QLPreviewView)
        v?.autostarts = false

        finderPlayButton.target = self
        finderPlayButton.action = #selector(self.playPause)
        finderRestartButton.target = self
        finderRestartButton.action = #selector(self.restart)

        playButton.target = self
        playButton.action = #selector(self.playPause)
        restartButton.target = self
        restartButton.action = #selector(self.restart)
    }

    @objc func playPause() {
        if (viewMIDIPlayer!.isPlaying) {
            viewMIDIPlayer!.stop()
            playButton.state = NSControl.StateValue.off
            finderPlayButton.state = NSControl.StateValue.off
        } else {
            viewMIDIPlayer!.play(self.completed())
            playButton.state = NSControl.StateValue.on
            finderPlayButton.state = NSControl.StateValue.on
        }
    }

    @objc func restart() {
        if viewMIDIPlayer != nil {
            viewMIDIPlayer!.currentPosition = TimeInterval(0)
            playButton.state = NSControl.StateValue.on
            finderPlayButton.state = NSControl.StateValue.on
            viewMIDIPlayer!.prepareToPlay()
            viewMIDIPlayer!.play(self.completed())
        }
    }

    func completed() -> AVMIDIPlayerCompletionHandler {
        return {
            self.playButton.state = NSControl.StateValue.off
            self.finderPlayButton.state = NSControl.StateValue.off
         }
    }

    /*
     * Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.
     *
    func preparePreviewOfSearchableItem(identifier: String, queryString: String?, completionHandler handler: @escaping (Error?) -> Void) {
        // Perform any setup necessary in order to prepare the view.
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        handler(nil)
     */

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {

        do {
            currentPlaybackTimeLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
            totalTimeLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
            
            viewMIDIPlayer = try AVMIDIPlayer.init(contentsOf: url, soundBankURL: nil)
            viewMIDIPlayer?.prepareToPlay()
            theSlider.maxValue = Double(self.viewMIDIPlayer?.duration ?? 0.0)
            finderProgressCircle.maxValue = Double(self.viewMIDIPlayer?.duration ?? 0.0)
            filenameLabel.stringValue = url.lastPathComponent
            filenameLabel.frame.size.width = CGFloat(filenameLabel.stringValue.count * 13)
            currentPlaybackTimeLabel.stringValue = "0:00"

            if let time = self.viewMIDIPlayer?.duration {
                let minutes = Int(time / 60)
                let seconds = Int((time)) % 60
                totalTimeLabel.stringValue =  String(format: "%01d:%02d", minutes, seconds)
            }
        } catch {
            let _ = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }

        // Add the supported content types to the QLSupportedContentTypes array in the Info.plist of the extension.
        // Perform any setup necessary in order to prepare the view.
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.

        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateDisplay), userInfo: nil, repeats: true)

        handler(nil)
    }

    override func viewWillDisappear() {
        if (viewMIDIPlayer!.isPlaying) {
            viewMIDIPlayer!.stop()
        }
        super.viewWillDisappear()
    }

    override func viewDidAppear() {
        if let width = self.view.window?.frame.width, width < 600.0 {
            //Finder View
            self.finderView.isHidden = false
            self.quickLookView.isHidden = true
        } else {
            // QuickLook Window
            self.finderView.isHidden = true
            self.quickLookView.isHidden = false

            self.viewMIDIPlayer?.play(self.completed())
            self.playButton.state = .on
        }
    }

    @objc func updateDisplay(){
        if viewMIDIPlayer != nil {
            if viewMIDIPlayer!.currentPosition <= viewMIDIPlayer!.duration {
                theSlider.doubleValue = Double((viewMIDIPlayer!.currentPosition))
                if let currentPosition = self.viewMIDIPlayer?.currentPosition {
                    let minutes = Int(currentPosition / 60)
                    let seconds = Int((currentPosition)) % 60
                    currentPlaybackTimeLabel.stringValue =  String(format: "%01d:%02d", minutes, seconds)
                    finderProgressCircle.doubleValue = Double((viewMIDIPlayer!.currentPosition))
                }
            }
        }
    }
}
