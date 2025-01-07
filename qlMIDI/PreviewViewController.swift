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

    @IBOutlet weak var currentPlaybackTimeLabel: NSTextField!
    @IBOutlet weak var totalTimeLabel: NSTextField!
    @IBOutlet weak var filenameLabel: NSTextField!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var theSlider: NSProgressIndicator!

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
        preferredContentSize = CGSize(width: 800, height: 350)
    }

    @IBAction func playSwitch(_ sender: NSButton) {
        if (viewMIDIPlayer!.isPlaying) {
            viewMIDIPlayer!.stop()
        } else {
            viewMIDIPlayer!.play(self.completed())
        }
    }

    @IBAction func backToStart(_ sender: Any) {
        if viewMIDIPlayer != nil {
            viewMIDIPlayer!.currentPosition = TimeInterval(0)
            playButton.state = NSControl.StateValue.on
            viewMIDIPlayer!.prepareToPlay()
            viewMIDIPlayer!.play(self.completed())
        }
    }

    func completed() -> AVMIDIPlayerCompletionHandler {
        return {
            self.playButton.state = NSControl.StateValue.off
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
        preferredContentSize = NSSize(width: 600, height: 400)
        
        do {
            currentPlaybackTimeLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
            totalTimeLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
            
            viewMIDIPlayer = try AVMIDIPlayer.init(contentsOf: url, soundBankURL: nil)
            viewMIDIPlayer?.prepareToPlay()
            theSlider.maxValue = Double(self.viewMIDIPlayer?.duration ?? 0.0)
            filenameLabel.stringValue = url.lastPathComponent
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
        viewMIDIPlayer?.play(self.completed())
        playButton.state = .on
    }

    @objc func updateDisplay(){
        if viewMIDIPlayer != nil {
            if viewMIDIPlayer!.currentPosition <= viewMIDIPlayer!.duration {
                theSlider.doubleValue = Double((viewMIDIPlayer!.currentPosition))
                if let currentPosition = self.viewMIDIPlayer?.currentPosition {
                    let minutes = Int(currentPosition / 60)
                    let seconds = Int((currentPosition)) % 60
                    currentPlaybackTimeLabel.stringValue =  String(format: "%01d:%02d", minutes, seconds)
                }
            }
        }
    }
}
