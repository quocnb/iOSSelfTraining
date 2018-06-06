//
//  ScheduleInterfaceController.swift
//  Fun Extension
//
//  Created by Quoc Nguyen on 2018/06/06.
//  Copyright © 2018 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {

  @IBOutlet var tableView: WKInterfaceTable!

  var flights = Flight.allFlights()
  var selectedIndex = -1

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    tableView.setNumberOfRows(flights.count, withRowType: "FlightRow")
    for index in 0..<tableView.numberOfRows {
      guard let controller = tableView.rowController(at: index) as? FlightRowController else { continue }
      controller.flight = flights[index]
    }
  }

  override func didAppear() {
    super.didAppear()
    // 1
    guard selectedIndex >= 0, flights[selectedIndex].checkedIn,
      let controller = tableView.rowController(at: selectedIndex) as? FlightRowController else {
        return
    }
    animate(withDuration: 0.35) {
      controller.updateForCheckIn()
    }
  }

  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    selectedIndex = rowIndex
    let flight = flights[rowIndex]
//    pushController(withName: "Flight", context: flight)
    let controllers = ["Flight", "CheckIn"]
    presentController(withNames: controllers, contexts: [flight, flight])
  }
}
