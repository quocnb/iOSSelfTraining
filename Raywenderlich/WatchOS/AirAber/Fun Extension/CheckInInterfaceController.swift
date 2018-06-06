//
//  CheckInInterfaceController.swift
//  Fun Extension
//
//  Created by Quoc Nguyen on 2018/06/06.
//  Copyright © 2018 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class CheckInInterfaceController: WKInterfaceController {

  @IBOutlet var backgroundGroup: WKInterfaceGroup!
  @IBOutlet var originLabel: WKInterfaceLabel!
  @IBOutlet var destinationLabel: WKInterfaceLabel!

  var flight: Flight? {
    didSet {
      guard let flight = flight else { return }

      originLabel.setText(flight.origin)
      destinationLabel.setText(flight.destination)
    }
  }

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    if let flight = context as? Flight {
      self.flight = flight
    }
  }

  @IBAction func checkInButtonTapped() {
    let duration = 0.35
    let delay = DispatchTime.now() + (duration + 0.15)
    backgroundGroup.setBackgroundImageNamed("Progress")
    backgroundGroup.startAnimatingWithImages(in: NSRange(location: 0, length: 10),
                                             duration: duration,
                                             repeatCount: 1)
    DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
      self?.flight?.checkedIn = true
      self?.dismiss()
    }
  }
}
