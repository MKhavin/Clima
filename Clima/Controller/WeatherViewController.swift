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
    }
}

