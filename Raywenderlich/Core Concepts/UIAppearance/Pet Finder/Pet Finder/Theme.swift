//
//  Theme.swift
//  Pet Finder
//
//  Created by Quoc Nguyen on 2018/06/11.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

enum Theme: Int {
  case `default`, dark, graphical

  private enum Keys {
    static let selectedTheme = "SelectedTheme"
  }

  static var current: Theme {
    let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
    return Theme(rawValue: storedTheme) ?? .default
  }

  var mainColor: UIColor {
    switch self {
    case .default:
      return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    case .dark:
      return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    case .graphical:
      return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    }
  }

  var barStyle: UIBarStyle {
    switch self {
    case .default, .graphical:
      return .default
    case .dark:
      return .black
    }
  }

  var backgroundColor: UIColor {
    switch self {
    case .default, .graphical:
      return UIColor.white
    case .dark:
      return UIColor(white: 0.4, alpha: 1.0)
    }
  }

  var textColor: UIColor {
    switch self {
    case .default, .graphical:
      return UIColor.black
    case .dark:
      return UIColor.white
    }
  }

  var navigationBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "navBackground") : nil
  }

  var tabBarBackgroundImage: UIImage? {
    return self == .graphical ? UIImage(named: "tabBarBackground") : nil
  }

  func apply() {
    UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
    UserDefaults.standard.synchronize()

    UIApplication.shared.delegate?.window??.tintColor = mainColor
    customNavigationBar()
    customTabbar()
    customSegmentControl()
    customStepper()
    customSlider()
    customSwitch()
    customTableviewCell()
  }

  func customNavigationBar() {
    let navBarAppearance = UINavigationBar.appearance()
    navBarAppearance.barStyle = barStyle
    navBarAppearance.setBackgroundImage(navigationBackgroundImage, for: .default)
    navBarAppearance.backIndicatorImage = UIImage(named: "backArrow")
    navBarAppearance.backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
  }

  func customTabbar() {
    let tapBarAppearance = UITabBar.appearance()
    tapBarAppearance.barStyle = barStyle
    tapBarAppearance.backgroundImage = tabBarBackgroundImage

    let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
    let tabResizableIndicator = tabIndicator?.resizableImage(
      withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
    tapBarAppearance.selectionIndicatorImage = tabResizableIndicator
  }

  func customSegmentControl() {
    let controlBackground = UIImage(named: "controlBackground")?
      .withRenderingMode(.alwaysTemplate)
      .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

    let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
      .withRenderingMode(.alwaysTemplate)
      .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

    UISegmentedControl.appearance().setBackgroundImage(
      controlBackground, for: .normal, barMetrics: .default
    )
    UISegmentedControl.appearance().setBackgroundImage(
      controlSelectedBackground, for: .selected, barMetrics: .default
    )
  }

  func customStepper() {
    let appearance = UIStepper.appearance()
    let controlBackground = UIImage(named: "controlBackground")?
      .withRenderingMode(.alwaysTemplate)
      .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    appearance.setBackgroundImage(controlBackground, for: .normal)
    appearance.setBackgroundImage(controlBackground, for: .disabled)
    appearance.setBackgroundImage(controlBackground, for: .highlighted)
    appearance.setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
    appearance.setIncrementImage(UIImage(named: "morePaws"), for: .normal)
  }

  func customSlider() {
    let appearance = UISlider.appearance()
    appearance.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
    appearance.setMaximumTrackImage(UIImage(named: "maximumTrack")?
      .resizableImage(withCapInsets:UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)

    appearance.setMinimumTrackImage(UIImage(named: "minimumTrack")?
      .withRenderingMode(.alwaysTemplate)
      .resizableImage(withCapInsets:UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)

  }

  func customSwitch() {
    UISwitch.appearance().onTintColor = mainColor.withAlphaComponent(0.3)
    UISwitch.appearance().thumbTintColor = mainColor
  }

  func customTableviewCell() {
    UITableViewCell.appearance().backgroundColor = backgroundColor
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
  }
}
