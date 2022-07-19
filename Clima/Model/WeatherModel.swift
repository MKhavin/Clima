import Foundation

struct WeatherModel {
    let cityName: String
    private let conditionId: Int
    private let temperature: Double
    
    var formattedTemperature: String {
        String(format: "%.0f", temperature)
    }
    var conditionImage: String {
        switch conditionId {
        case 200...202: return "cloud.bolt.rain"
        case 210...221, 230...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        default: return "cloud"
        }
    }
    
    init(cityName: String, conditionId: Int, temperature: Double) {
        self.cityName = cityName
        self.conditionId = conditionId
        self.temperature = temperature
    }
}
