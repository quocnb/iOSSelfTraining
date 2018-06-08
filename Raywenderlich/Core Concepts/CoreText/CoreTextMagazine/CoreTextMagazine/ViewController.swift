//
//  ViewController.swift
//  CoreTextMagazine
//
//  Created by Quoc Nguyen on 2018/06/08.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreText

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }

        do {
            let text = try String(contentsOfFile: file, encoding: .utf8)
            // 2
            let parser = MarkupParse()
            parser.parseMarkup(text)
            (view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: [])
        } catch _ {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

