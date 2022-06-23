//
//  ClimaManager.swift
//  GoClima
//
//  Created by Diego Carvalho on 20/06/22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ climaInfo: ClimaManager, weather: ClimaModel)
    func didFailWithError(error: Error)
}

struct ClimaManager {
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?appid=5e43851f2b544cd67736836f1a09fcf3&units=metric"
    var delegate: WeatherManagerDelegate?
    func buscaTemperatura(cidade: String){
        let linkClima = "\(apiUrl)&q=\(cidade)"
        performRequest(with: linkClima)
        
    }
    
    func buscaTemperatura(latitude: CLLocationDegrees , longitude: CLLocationDegrees) {
        let linkClima = "\(apiUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: linkClima)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ infoClima: Data) -> ClimaModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ClimaTypes.self, from: infoClima)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = ClimaModel(conditionID: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
