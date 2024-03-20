//
//  IconScrollView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 2/6/24.
//

import UIKit

class IconScrollView: UIScrollView {
    var shouldSetContentOffset = false
    var borders = [CAShapeLayer]()
    
    override var contentOffset: CGPoint {
        didSet {
            if !shouldSetContentOffset {
                super.contentOffset = oldValue
            }
        }
    }
    
    func configure(maxHeight: CGFloat) {
        let contentView = UIView()
        addSubview(contentView)
        layoutIfNeeded()
        
        let numUniqueImages = 50
        let multiplier = 5
        let totalImages = numUniqueImages * multiplier
        
        let iconWidth: CGFloat = 65
        let padding: CGFloat = 5
        let stride = iconWidth + padding * 3
        let numRows = Int(maxHeight / stride)
        
        let adjustedHeight = CGFloat(numRows) * stride
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: adjustedHeight)
        ])
        
        var outerArray: [[UIImage]] = Array(repeating: [], count: numRows)
        
        for imageIndex in 0..<totalImages {
            let image = UIImage(named: "Icon\(imageIndex % numUniqueImages)")!
            let index = imageIndex % numRows
            
            outerArray[index].append(image)
        }
        
        var xScan: CGFloat = 0
        var yScan: CGFloat = padding
        
        var startingX: CGFloat = 0
        
        for array in outerArray {
            xScan = startingX
            
            for image in array {
                let rectangleView = UIView()
                rectangleView.backgroundColor = UIColor.smokyCharcoal.withAlphaComponent(0.4)
                rectangleView.translatesAutoresizingMaskIntoConstraints = false
                
                rectangleView.frame = CGRect(x: xScan, y: yScan, width: iconWidth + (padding * 2), height: iconWidth + (padding * 2))
                rectangleView.layer.cornerRadius = 10
                
                let border = CAShapeLayer()
                border.path = UIBezierPath(roundedRect: rectangleView.bounds, cornerRadius: 10).cgPath
                border.strokeStart = 0
                border.strokeEnd = 0
                border.strokeColor = UIColor.azureBlue.cgColor
                border.lineWidth = 2
                border.fillColor = nil
                
                borders.append(border)
                
                rectangleView.layer.addSublayer(border)
                
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                rectangleView.addSubview(imageView)
                imageView.frame = CGRect(x: padding, y: padding, width: iconWidth, height: iconWidth)
                
                contentView.addSubview(rectangleView)
                
                xScan += stride
            }
            
            yScan += stride
            startingX -= 50
        }
    }
    
    func animateBorders(completion: @escaping () -> ()) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            completion()
        }
        
        for border in borders {
            border.strokeEnd = 1
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.byValue = 0.1
            animation.duration = 1.5
            border.add(animation, forKey: "line")
        }
        
        CATransaction.commit()
    }
    
    func startAnimating() {
        for border in borders {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 2
            animation.autoreverses = true
            animation.repeatCount = .infinity
            border.add(animation, forKey: "line")
        }
    }
    
    func stopAnimating() {
        for border in borders {
            border.removeAllAnimations()
            border.strokeEnd = 1
        }
    }
    
    func animateScrollView() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.shouldSetContentOffset = true
                self.setContentOffset(CGPoint(x: self.contentOffset.x + 1, y: self.contentOffset.y), animated: false)
                self.shouldSetContentOffset = false
            }, completion: nil)
        }
    }
}
