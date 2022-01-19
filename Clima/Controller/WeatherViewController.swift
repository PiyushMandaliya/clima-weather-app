//
//  ViewController.swift
//  Clima
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextFiled: UITextField!
    
    let locataionManager = CLLocationManager()
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locataionManager.delegate = self

        
       
        weatherManager.delegate = self
        searchTextFiled.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        locataionManager.requestWhenInUseAuthorization()
        locataionManager.requestLocation()
    }
    
    
}

//MARK: -  UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextFiled.endEditing(true)
        if let searchCity = searchTextFiled.text {
            print(searchCity)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextFiled.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextFiled.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextFiled.text = ""
        textField.placeholder = "Search"

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type Something"
            return false
        }
    }
}

//MARK: -  WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.name
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: -  CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate
{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location data received.")
            print(location.coordinate)
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lattitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
