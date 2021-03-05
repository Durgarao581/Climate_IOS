
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ watherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/find?&units=metric&appid=c430a63d6dce1726e3cd35b2d9ef55c1"
    var delegate: WeatherManagerDelegate?
   
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        //1.Create a URL
        if let url = URL(string: urlString){
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData =  data {
                   if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                   }
                }
            }
            //4. start the task
            task.resume()
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            let name = decodedData.list[0].name
            let weather = WeatherModel(conditionId: id, cityName: name, temparature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}


