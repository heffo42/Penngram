//
//  ViewController.swift
//  Parsegram
//
//  Created by David Heffernan on 11/4/17.
//  Copyright © 2017 David Heffernan. All rights reserved.
//

import UIKit

class ViewControllerPannable: UIViewController {
    var panGestureRecognizer: UIPanGestureRecognizer?

    
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    
    @objc func tapGestureAction(_ tapAction: UITapGestureRecognizer){
        cutstomTapAction()
    }
    
    func cutstomTapAction(){
        print("tapped")
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            print("\(view.frame.origin.y)")
            view.frame.origin = CGPoint(
                x: view.frame.origin.x,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}
