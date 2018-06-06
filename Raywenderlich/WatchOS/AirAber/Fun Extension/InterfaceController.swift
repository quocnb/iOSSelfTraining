//
//  InterfaceController.swift
//  Fun Extension
//
//  Created by Quoc Nguyen on 2018/06/06.
//  Copyright © 2018 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

  @IBOutlet var flightLabel: WKInterfaceLabel!
  @IBOutlet var routeLabel: WKInterfaceLabel!
  @IBOutlet var boardingLabel: WKInterfaceLabel!
  @IBOutlet var boardTimeLabel: WKInterfaceLabel!
  @IBOutlet var statusLabel: WKInterfaceLabel!
  @IBOutlet var gateLabel: WKInterfaceLabel!
  @IBOutlet var seatLabel: WKInterfaceLabel!

  var flight: Flight? {
    // 2
    didSet {
      // 3
      guard let flight = flight else { return }
      // 4
      flightLabel.setText("Flight \(flight.shortNumber)")
      routeLabel.setText(flight.route)
      boardingLabel.setText("\(flight.number) Boards")
      boardTimeLabel.setText(flight.boardsAt)
      // 5
      if flight.onSchedule {
        statusLabel.setText("On Time")
      } else {
        statusLabel.setText("Delayed")
        statusLabel.setTextColor(.red)
      }
      gateLabel.setText("Gate \(flight.gate)")
      seatLabel.setText("Seat \(flight.seat)")
    }
  }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
      if let flight = context as? Flight {
        self.flight = flight
      } else {
        flight = Flight.allFlights().random()
      }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
