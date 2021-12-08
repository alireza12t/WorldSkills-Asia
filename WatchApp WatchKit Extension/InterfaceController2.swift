//
//  File.swift
//  WatchApp WatchKit Extension
//
//  Created by Alireza on 12/8/21.
//

import WatchKit
import Foundation
import UIKit


class InterfaceController2: WKInterfaceController {

    @IBOutlet weak var group: WKInterfaceGroup!
    
    override func awake(withContext context: Any?) {
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        animate(withDuration: 0.2) {
            self.group.setBackgroundColor(.red)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
