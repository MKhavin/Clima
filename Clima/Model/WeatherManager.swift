import Foundation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManaher: WeatherManager, weather: WeatherModel)
    func didFailWith(error: Error)
}

struct WeatherManager {
    private lazy var weatherURL: URLComponents = {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.openweathermap.org"
        url.path = "/data/2.5/weather"
        url.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        return url
    }()
    
    private var apiKey: String {
        let key: [UInt8] = [0x30, 0x35, 0x30, 0x37, 0x61, 0x35, 0x65, 0x38,
                            0x30, 0x38, 0x35, 0x32, 0x37, 0x63, 0x32, 0x31,
                            0x39, 0x64, 0x30, 0x35, 0x32, 0x61, 0x33, 0x32,
                            0x62, 0x32, 0x63, 0x63, 0x30, 0x36, 0x39, 0x34]
        let data = Data(key)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    var weather: WeatherModel?
    weak var delegate: WeatherManagerDelegate?
    
    mutating func fetchWeather(cityName: String) {
        weatherURL.queryItems?.removeAll { item in
            item.name == "q"
        }
        weatherURL.queryItems?.append(URLQueryItem(name: "q",
                                                   value: cityName))
        guard let url = weatherURL.url else {
            return
        }
    
        performRequest(with: url)
    }
    
    private func performRequest(with urlString: URL) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlString) { data, response, error in
            guard error == nil else {
                delegate?.didFailWith(error: error!)
                return
            }
            
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(cityName: decodedData.name,
                                   conditionId: decodedData.weather[0].id,
                                   temperature: decodedData.main.temp)
        } catch {
            delegate?.didFailWith(error: error)
            return nil
        }
    }
}
