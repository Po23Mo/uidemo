import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor,
            UIColor.systemPink.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func animateGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor,
            UIColor.systemPink.withAlphaComponent(0.1).cgColor,
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        ]
        animation.duration = 3.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "gradientAnimation")
    }
    
    func stopAnimation() {
        gradientLayer.removeAnimation(forKey: "gradientAnimation")
    }
} 