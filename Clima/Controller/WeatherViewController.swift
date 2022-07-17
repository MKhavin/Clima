import UIKit

class WeatherViewController: UIViewController {
    // MARK: Life cycle
    override func loadView() {
        let mainView = WeatherView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let currentView = view as? WeatherView else {
            return
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            currentView.backgroundImageView.image = UIImage(named: "backgroundDark")
        } else {
            currentView.backgroundImageView.image = UIImage(named: "backgroundLight")
        }
    }
}

