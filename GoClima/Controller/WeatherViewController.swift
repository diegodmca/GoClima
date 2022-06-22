//
//  ViewController.swift
//  GoClima
//
//  Created by Diego Carvalho on 18/06/22.
//
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var imagemCondicaoTemp: UIImageView!
    @IBOutlet weak var labelTemperatura: UILabel!
    @IBOutlet weak var labelCidade: UILabel!
    
    @IBOutlet weak var campoBusca: UITextField!
    
    var climaInfo = ClimaManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        climaInfo.delegate = self
        campoBusca.delegate = self
    }
    
    
    @IBAction func buttonLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func botaoProcurar(_ sender: UIButton) {
        campoBusca.endEditing(true)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(campoBusca.text!)
        campoBusca.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if campoBusca.text != ""{
            return true
        }else{
            campoBusca.placeholder = "Digite algo..."
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cidade = campoBusca.text{
            climaInfo.buscaTemperatura(cidade: cidade)
        }
    }
    
}

//MARK: - Weather Delegate


extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ climaInfo: ClimaManager, weather: ClimaModel) {
        DispatchQueue.main.async {
            self.labelTemperatura.text = weather.temperatureString
            self.imagemCondicaoTemp.image = UIImage(systemName: weather.conditionName)
            self.labelCidade.text = weather.cityName
            
        }
    }
    
    func didFailWithError(error: Error) {
            print(error)
        }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            climaInfo.buscaTemperatura(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
