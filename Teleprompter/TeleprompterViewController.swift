//
//  TeleprompterViewController.swift
//  Teleprompter
//
//  Created by Olivia Bishop on 9/27/19.
//  Copyright © 2019 Olivia Bishop. All rights reserved.
//

import UIKit



struct Orientation {
    let x: CGFloat
    let y: CGFloat
}

enum State {
    case stopped
    case playing
    case paused
}

class TeleprompterViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    
    var scrollTimer: Timer?
    
    
    var scrollState = State.stopped
    
    var orientations = [Orientation(x: 1, y: 1), Orientation(x: 1, y: -1)]
    
    var orientationIndex = 0
    
   
    var initialOffset: CGFloat = 0.0
    var bottomOffset: CGFloat = 0.0
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        textView.delegate = self as UITextViewDelegate
        
       
        
        let orientation = orientations[orientationIndex]
        
        textView.transform = CGAffineTransform(scaleX: orientation.x, y: orientation.y)
        
}
    
    
    override func viewDidAppear(_ animated: Bool) {
        Scroll()
    }
    
    func wiewDidScroll(_ scrollView: UIScrollView) {
        self.initialOffset = scrollView.contentOffset.y
    }
    
    
    @IBAction func playButton(_ sender: Any) {
        
        start()
        
    }
    
    @IBAction func pauseButton(_ sender: Any) {

        pause()

    }
    
    @IBAction func stopButton(_ sender: Any) {
        
        stop()
    }
    
    
    @IBAction func flipButton(_ sender: Any) {
 
        orientationIndex += 1
        if (orientationIndex >= orientations.count) {
            orientationIndex = 0
        }
        
        let orientation = orientations[orientationIndex]
        
        textView.transform = CGAffineTransform(scaleX: orientation.x, y: orientation.y)
        
    }
    
    
    func start() {
        
        if (scrollState == .paused) {
            scrollState = .playing
        } else {
            startScroll()
        }
    }
    
    func pause() {
       
        scrollState = .paused
    }
    
    func stop() {
        
        stopScroll()
    }
    
    func Scroll() {
        self.bottomOffset = textView.contentSize.height
        let height = textView.bounds.height
        self.initialOffset = -(height/4)
        self.textView.setContentOffset(CGPoint(x: 0, y: self.initialOffset), animated: false)
        
    }
    
    func startScroll() {
        
        Scroll()
        
        self.scrollTimer?.invalidate()
        
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {
            (timer) in
            if (self.scrollState == .paused) { return }
            self.initialOffset += 0.5
            if (self.initialOffset > self.bottomOffset) {
                self.scrollTimer?.invalidate()
                self.scrollState = .stopped
                return
            }
            self.timer.text = "\(self.initialOffset)"
            self.textView.setContentOffset(CGPoint(x: 0, y: self.initialOffset), animated: false)
        })
    }
    
    func stopScroll() {
        scrollTimer?.invalidate()
        self.scrollState = .stopped
        Scroll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

