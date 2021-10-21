//
//  ViewController.swift
//  BongoBongo
//
//  Created by Simonarde Lima on 20/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var board: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
            board.isUserInteractionEnabled = true
            board.addGestureRecognizer(tap)
            animator = UIDynamicAnimator(referenceView: board)
            behavior = SquareBehavior()
            animator?.addBehavior(behavior!)
            
            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
                self.explodeSquares()
            }
        }
    }
    
    private var animator: UIDynamicAnimator?
    private var behavior: SquareBehavior?
    private var squares = [UIView]()
    weak var timer: Timer?
    
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        let pointTapped = sender.location(in: board)
        createSquare(at: pointTapped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSquare(_ sender: UIButton) {
        let x = arc4random() % UInt32(board.bounds.size.width)
        let point = CGPoint(x: Int(x), y: 0)
        createSquare(at: point)
    }
    
    @IBAction func onExplode(_ sender: UIButton) {
        guard squares.count > 0 else { return }
        
        explodeSquares()
        
        /*
        squares.forEach({behavior?.removeItem($0)})
        
        UIView.animate(withDuration: 1) {
            self.explodeSquares()
        } completion: { (finished) in
            self.squares.forEach({$0.removeFromSuperview()})
            self.squares.removeAll()
        }
        */
    }
    
    private func explodeSquares() {
        squares.forEach({behavior?.removeItem($0)})
        
        UIView.animate(withDuration: 1) {
            for sq in self.squares {
                let x = arc4random() % UInt32(self.board.bounds.size.width)
                let y = self.board.bounds.size.height
                sq.center = CGPoint(x: CGFloat(x), y: -y)
            }
        } completion: { (finished) in
            self.squares.forEach({$0.removeFromSuperview()})
            self.squares.removeAll()
        }
    }
    
    private func createSquare(at point: CGPoint) {
        let frame = CGRect(origin: point, size: CGSize(width: 30, height: 30))
        
        let square = UIView(frame: frame)
        square.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        
        board.addSubview(square)
        squares.append(square)
        behavior?.addItem(square)
    }
}

