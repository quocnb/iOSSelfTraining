//
//  ViewController.swift
//  DynamicDemo
//
//  Created by Quoc Nguyen on 2018/06/08.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var  animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!

    var square: UIView!
    var snap: UISnapBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.gray
        view.addSubview(square)

        let barrier = UIView(frame: CGRect(x: 0, y: 400, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)

        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])

        collision = UICollisionBehavior(items: [square])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))

        animator.addBehavior(gravity)
        animator.addBehavior(collision)

        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3) {
            collidingView.backgroundColor = UIColor.gray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        let touch = Array(touches)[Int(arc4random_uniform(UInt32(touches.count)))]
        snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }
}

