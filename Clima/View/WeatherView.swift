import UIKit

class WeatherView: UIView {
    // MARK: UI Elements
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "background"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            backgroundImageView
        ])
        setUpSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Sub functions
    private func setUpSubviewsLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
