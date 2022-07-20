import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    // MARK: Properties
    private lazy var weatherManager: WeatherManager = {
        var manager = WeatherManager()
        manager.delegate = self
        return manager
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: Life cycle
    override func loadView() {
        let mainView = WeatherView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setSubViewsDelegatesAndActions()
        locationManager.requestWhenInUseAuthorization()
//        weatherManager.fetchWeather(cityName: "Moscow")
    }
    
    // MARK: Sub functions
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
    
    private func setSubViewsDelegatesAndActions() {
        guard let currentView = view as? WeatherView else {
            return
        }
        
        currentView.searchBar.delegate = self
        
        currentView.searchButton.addTarget(self,
                                           action: #selector(searchButtonTouched(_:)),
                                           for: .touchUpInside)
        
        currentView.searchCurrentLocationButton.addTarget(self,
                                                          action: #selector(locationButtonTouched(_:)),
                                                          for: .touchUpInside)
    }
    
    // MARK: Actions
    @objc private func searchButtonTouched(_ sender: UIButton) {
        guard let currentView = view as? WeatherView else {
            return
        }
        
        weatherManager.fetchWeather(cityName: currentView.searchBar.text ?? "")
        currentView.searchButton.resignFirstResponder()
    }
    
    @objc private func locationButtonTouched(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        weatherManager.fetchWeather(cityName: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.placeholder = "Search"
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = "Type something..."
        return true
    }
}

// MARK: WeatherManager Delegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            guard let currentView = self.view as? WeatherView else {
                return
            }
            
            currentView.cityLabel.text = weather.cityName
            currentView.temperatureLabel.text = weather.formattedTemperature
            currentView.weatherConditionImageView.image = UIImage(systemName: weather.conditionImage)
        }
    }
    
    func didFailWith(error: Error) {
        print(error)
    }
}

// MARK: CoreLocationDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .notDetermined:
            break
        case .restricted, .denied:
            guard let currentView = view as? WeatherView else {
                break
            }
            
            currentView.cityLabel.text = "Nah"
            currentView.temperatureLabel.text = "Nah"
            currentView.weatherConditionImageView.image = UIImage(systemName: "questionmark.app")
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            fatalError("Authorization status isn't exist.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else {
            return
        }
        
        manager.stopUpdatingLocation()
        if let location = locations.last {
            weatherManager.fetchWeather(latitude: location.coordinate.latitude.description,
                                        longtitude: location.coordinate.longitude.description)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
