//
//  EmitterView.swift
//  MyNTORewards
//
//  Created by Damodaram Nandi on 26/10/23.
//

import UIKit

class EmitterView: UIView {
    var emitter: CAEmitterLayer!
    var timeDuration: Double = 2.0
    private var active: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        // initialization
        active = false
        emitter = CAEmitterLayer()
    }
    
    func startConfetti() {
        active = true
        emitter.emitterPosition = CGPoint(x: self.center.x, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.birthRate = 1
        emitter.emitterCells = generateEmitterCells()
        emitter.frame = self.bounds
        self.layer.addSublayer(emitter)
        perform(#selector(stopConfetti), with: nil, afterDelay: timeDuration)
    }
    
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<15 {
            let cell = CAEmitterCell()
            cell.birthRate = 50
            cell.lifetime = 5
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = .pi * 2
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            cells.append(cell)
        }
        return cells
    }
    
    private func getRandomVelocity() -> Double {
        return Double.random(in: 100...200)
    }
    
    private func getNextColor(i: Int) -> CGColor {
        let colors = [UIColor.red,
                      UIColor.blue,
                      UIColor.yellow,
                      UIColor.systemPink,
                      UIColor.brown,
                      UIColor.purple,
                      UIColor.green,
                      UIColor.cyan,
                      UIColor.darkGray,
                      UIColor.orange,
                      UIColor.systemBlue,
                      UIColor.systemMint,
                      UIColor.systemTeal,
                      UIColor.systemIndigo]
        if let randomColor = colors.randomElement() {
            return randomColor.cgColor
        }
        return UIColor.systemIndigo.cgColor
    }
    
    private func getNextImage(i: Int) -> CGImage? {
        let images = [UIImage(named: "confetti1"),
                      UIImage(named: "confetti2"),
                      UIImage(named: "confetti3")]
        if let randomImage = images.randomElement(), let cgImage = randomImage?.cgImage {
            return cgImage
        }
        return UIImage(named: "confetti1")?.cgImage
    }
    
    @objc func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }
    
    internal func isActive() -> Bool {
        return self.active
    }
}
