//
//  MarkupParse.swift
//  CoreTextExample
//
//  Created by Quoc Nguyen on 2018/06/05.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreText

class MarkupParse: NSObject {
    // MARK: - Properties
    var color: UIColor = .black
    var fontName: String = "Arial"
    var attrString: NSMutableAttributedString!
    var images: [[String: Any]] = []

    // MARK: - Initializers
    override init() {
        super.init()
    }

    // MARK: - Internal
    func parseMarkup(_ markup: String) {

    }
}
