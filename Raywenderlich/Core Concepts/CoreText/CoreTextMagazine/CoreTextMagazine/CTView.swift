//
//  CTView.swift
//  CoreTextMagazine
//
//  Created by Quoc Nguyen on 2018/06/08.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit
import CoreText

class CTView: UIScrollView {

    func buildFrames(withAttrString attrString: NSAttributedString,
                     andImages images: [[String: Any]]) {
        //3
        isPagingEnabled = true
        //4
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        //4
        var pageView = UIView()
        var textPos = 0
        var columnIndex: CGFloat = 0
        var pageIndex: CGFloat = 0
        let settings = CTSettings()
        //5
        while textPos < attrString.length {
            //1
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
                columnIndex = 0
                pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex * bounds.width, dy: 0))
                addSubview(pageView)
                //2
                pageIndex += 1
            }
            //3
            let columnXOrigin = pageView.frame.size.width / settings.columnsPerPage
            let columnOffset = columnIndex * columnXOrigin
            let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)
            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: columnFrame.size))
            let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, nil)
            //2
            let column = CTColumnView(frame: columnFrame, ctframe: ctframe)
            pageView.addSubview(column)
            //3
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length
            //4
            columnIndex += 1
        }
        contentSize = CGSize(width: CGFloat(pageIndex) * bounds.size.width,
                             height: bounds.size.height)
    }
}
