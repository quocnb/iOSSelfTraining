//
//  FlightRowController.swift
//  Fun Extension
//
//  Created by Quoc Nguyen on 2018/06/06.
//  Copyright © 2018 Mic Pringle. All rights reserved.
//

import WatchKit

class FlightRowController: NSObject {
  @IBOutlet var separator: WKInterfaceSeparator!
  @IBOutlet var originLabel: WKInterfaceLabel!
  @IBOutlet var destinationLabel: WKInterfaceLabel!
  @IBOutlet var flightNumberLabel: WKInterfaceLabel!
  @IBOutlet var statusLabel: WKInterfaceLabel!
  @IBOutlet var planeImage: WKInterfaceImage!

  var flight: Flight? {
    // 2
    didSet {
      // 3
      guard let flight = flight else { return }
      // 4
      originLabel.setText(flight.origin)
      destinationLabel.setText(flight.destination)
      flightNumberLabel.setText(flight.number)
      // 5
      if flight.onSchedule {
        statusLabel.setText("On Time")
      } else {
        statusLabel.setText("Delayed")
        statusLabel.setTextColor(.red)
      }
    }
  }

  
}
