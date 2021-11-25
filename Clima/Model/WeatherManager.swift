//
//  WeatherManager.swift
//  Clima
//
//  Created by Marc Cadag on 10/18/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager: NetworkManager {
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0b83809980b6be41dca9564eb328e534&units=metric"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        fetchData(urlString: urlString, WeatherData.self) { weatherData in
            let weather = self.getWeatherModel(from: weatherData)
            self.delegate?.didUpdateWeather(self, weather: weather)
        } onError: { error in
            self.delegate?.didFailWithError(error: error)
        }
    }
    
    private func getWeatherModel(from weatherData: WeatherData) -> WeatherModel {
        let id = weatherData.weather[0].id
        let temp = weatherData.main.temp
        let name = weatherData.name
        
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        
        return weather
    }
}


