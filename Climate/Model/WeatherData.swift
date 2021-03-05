


import Foundation


struct WeatherData: Codable{
    var message: String
    var list: [WeatherList]
}
struct WeatherList: Codable {
    var name: String
    var main: WeatherMain
    var weather: [WeatherNum]
}
struct WeatherMain:Codable {
    var temp: Double
}
struct WeatherNum:Codable {
    var id: Int
   
}

