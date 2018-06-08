//
//  FunViewController.swift
//  ClassicPhotos
//
//  Created by Quoc Nguyen on 2018/06/07.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit

class FunViewController: UIViewController {

    @IBAction func down(_ sender: Any) {
        print("Down")
    }
    @IBOutlet var control: UIControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
