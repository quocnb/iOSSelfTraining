//
//  CTView.swift
//  CoreTextExample
//
//  Created by Quoc Nguyen on 2018/06/05.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreText

class CTView: UIView {

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1, y: -1)
        let path = CGMutablePath()
        path.addRect(self.bounds)
        let attStr = NSAttributedString(string: "Hello World")
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attStr.length), path, nil)
        CTFrameDraw(frame, context)
    }

}
