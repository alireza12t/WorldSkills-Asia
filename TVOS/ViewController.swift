//
//  ViewController.swift
//  TVOS
//
//  Created by Alireza on 12/8/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: - Remote Contol
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
//        let tap = UIGestureRecognizer(target: self
//                                      , action: #selector(tapped))
//        view.addGestureRecognizer(tap)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)];
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        //MARK: - Time
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChanged), userInfo: nil, repeats: true)
    }
    
    @objc func timeChanged() {
        let text = getTimeText(date: Date())
        if let secondText = text.last,
           let second = Int("\(secondText)")  {
            if second % 2 == 0 {
                label.text = text.replacingOccurrences(of: ":", with: " ")
            } else {
                label.text = text
            }
        } else {
            label.text = text
        }
    }
    
    @objc func swipedRight() {
        print("Swipped Right")
        UIView.animate(withDuration: 80, delay: 0, options: .curveEaseIn) { [self] in
            imageView.image = UIImage(systemName: "chevron.right")!
        }
        
        //MARK: - Decode Json
        let json = "{\"name\" : \"asghar\"}"
        
        do {
        let model = try JSONDecoder().decode(Model.self, from: json.data(using: .utf8)!)
        } catch(let err) {
            print(err)
        }
    }
    
    @objc func tapped() {
        print("Tapped")
    }
    
    func getTimeText(date: Date)  -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
}

struct Model: Codable {
    let name: String
}
