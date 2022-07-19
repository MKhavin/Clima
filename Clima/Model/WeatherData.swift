import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: WeatherMain
    let weather: [Weather]
}

struct WeatherMain: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
