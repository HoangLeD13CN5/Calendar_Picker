//
//  ViewController.swift
//  libSelectCalendar
//
//  Created by Ominext on 9/10/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showPickCalendar(_ sender: Any) {
        let windowNew = UIWindow.init(frame: UIScreen.main.bounds)
        windowNew.isOpaque = false;
        windowNew.windowLevel = 10000;
        windowNew.rootViewController = self;
        windowNew.makeKeyAndVisible();
        
        let vc: PopupDatePicker = PopupDatePicker(nibName: "PopupDatePicker", bundle: nil)
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        windowNew.rootViewController?.present(vc, animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

