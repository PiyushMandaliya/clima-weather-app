//
//  WeatherManager.swift
//  Clima
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
}


struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=702be6eef8edd5695508235a07a1aeb4&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(with: urlString)
    }
    
    func fetchWeather(lattitude: CLLocationDegrees,longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lattitude)&lon=\(longitude)"
        self.performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
            }
            
            //4 Start the task
            task.resume()
        }
    }
    
    
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(name: cityName, conditionId: id, temperature: temp)
            return weather
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
