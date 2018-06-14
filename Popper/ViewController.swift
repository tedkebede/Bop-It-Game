//
//  ViewController.swift
//  Popper
//
//  Created by Alan Chen on 5/3/18.
//  Copyright © 2018 Alphie. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var timer1: UILabel!
    
    var audioPlayer : AVAudioPlayer!
    let soundArray = ["correct", "wrong", "over"]
    var selectedSoundFileName : String = ""
    
    let names = ["Twist!","Flip me!", "Shake me!"]
    var counter = 30
    var current = 0
    var scores = 0
    var timer = Timer()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        score.text = String(scores)
        print("\(self.scores)")
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        scores = 0
        self.score.text = String(self.scores)
        
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
    }
    
    func startReadingMotionData() {
        // set read speed
        motionManager.deviceMotionUpdateInterval = 0.3
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            if let mydata = data {
//                print("mydata.gravity", mydata.gravity)
                
//                print("pitch raw", mydata.attitude.pitch)
//                print("pitch", self.degrees(mydata.attitude.pitch))
//
//                print("roll raw", mydata.attitude.roll)
//                print("roll", self.degrees(mydata.attitude.roll))
                
//                var gravity: CMAcceleration { get }
                
//                print("roll raw", mydata.gravity)
//                print("roll", self.degrees(mydata.attitude.gravity)

            if self.degrees(mydata.attitude.pitch) > 50.0 {
                print("FLIPPED")
                self.scores += 1
                print("Current Score is: \(self.scores)")
//                self.score.text = String(self.scores)
                self.selectedSoundFileName = self.soundArray[0]
                self.playSound()
                }
                
            if self.degrees(mydata.attitude.roll) > 70.0 {
                print("TWISTED!")
                self.scores += 1
                print("Current Score is: \(self.scores)")
//                self.score.text = String(self.scores)
                self.selectedSoundFileName = self.soundArray[0]
                self.playSound()
            }
//            else if self.degrees(mydata.attitude.roll) != 70.0 && self.degrees(mydata.attitude.pitch) != 50.0{
//                self.selectedSoundFileName = self.soundArray[1]
//                self.playSound()
//                }
                
                
//                  if mydata.userAcceleration.z > 0.06 {
//                    self.randSoundNum = Int(arc4random_uniform(UInt32(4)))
//                    print(self.randSoundNum)
//                    self.selectedSoundFileName = self.soundArray[self.randSoundNum]
//                    print(self.selectedSoundFileName)
//                    self.playSound()
            }
        }
    }
    
    func playSound() {
        let soundURL = Bundle.main.url(forResource: selectedSoundFileName, withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }

    @IBAction func buttonPress(_ sender: UIButton) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
//        current = Int(arc4random_uniform(UInt32(names.count-1)))
        print("CLICKED")
        if current < names.count-1
        {
            current += 1
        }
        else {
            current = 0
        }
        update()
    }
    @IBAction func reset(_ sender: UIButton) {
     
    }
    
    @objc func update() {
        current = Int(arc4random_uniform(UInt32(names.count)))
        action.text = names[current]
        print(names[current])
        if (counter > 0) {
            counter -= 1
            score.text = String(scores)
        }
        else {
            action.textColor = UIColor.red
            action.text = "GAME OVER"
            selectedSoundFileName = soundArray[2]
            playSound()
            
        }
        if (counter < 5){
            timer1.textColor = UIColor.red
            timer1.text = "\(counter)"
        }
        else {
            timer1.text = "\(counter)"
        }
    }
}



