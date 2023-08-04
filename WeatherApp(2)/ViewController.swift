//
//  ViewController.swift
//  Weather App
//
//  Created by Tanya Marion Mayol on 7/31/23.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

//    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var tempUnit: UISegmentedControl!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var searchedCitiesWeather: [weatherResponse] = []
    
    var isFahrenheit = false
    var clickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func currentLocationBtn(_ sender: Any) {
        locationManager.requestLocation()
            }

            // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")

        // Fetch weather data using location coordinates
        loadWeather(search: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
    }

            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("Failed to get location: \(error.localizedDescription)")
            }
    


    @IBAction func searchBtn(_ sender: Any) {
        loadWeather(search: searchText.text)
    }
    @IBAction func searchCities(_ sender: Any) {
        if let searchQuery = searchText.text {
            loadWeather(search: searchQuery)
                   performSegue(withIdentifier: "ShowCitiesListSegue", sender: nil)
               }
               searchText.resignFirstResponder()
    }
    @IBAction func tempControl(_ sender: UISegmentedControl) {
        clickCount += 1
        
        if sender.selectedSegmentIndex == 0 {
            isFahrenheit = false
        } else {
            isFahrenheit = true
        }
        loadWeather(search: searchText.text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowCitiesListSegue" {
                if let citiesListVC = segue.destination as? CitiesListViewController {
                    citiesListVC.searchedCitiesWeather = searchedCitiesWeather
                }
            }
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print(textField.text ?? "")
        loadWeather(search: searchText.text)
       
        return true
        
    }
    
    //Location
    private func loadWeather(search: String?){
        guard let search = search else{
            return
        }
        
        guard  let url = getURL(query: search) else {
            print("Could not get URL")
            return
        }
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) {data, response, error in
            print("Network call completed")
            
            guard error == nil else{
                print("recieved error")
                return
            }
            guard let data = data else{
                print("No data found")
                return
            }
            
            if let weatherResponse = self.parseJson(data: data) {
                print(weatherResponse.location.name)
                print(weatherResponse.current.temp_c)
                print(weatherResponse.current.condition.text)
//                print(weatherResponse.current.condition.code.image)
                
                DispatchQueue.main.sync {
                    self.cityLabel.text = weatherResponse.location.name
                    if self.isFahrenheit {
                        print(weatherResponse.current.temp_f)
                        self.tempLabel.text = "\(weatherResponse.current.temp_f)F"
                    } else {
                        print(weatherResponse.current.temp_c)
                        self.tempLabel.text = "\(weatherResponse.current.temp_c)C"
                    }
                    self.weatherConditionLabel.text = weatherResponse.current.condition.text
                    
//                    self.image1.image = weatherResponse.current.condition.code.image
                    let existingCity = self.searchedCitiesWeather.first { city in
                                        return city.location.name == weatherResponse.location.name
                                    }

                                    // If the city does not exist in the array, add it
                                    if existingCity == nil {
                                        self.searchedCitiesWeather.append(weatherResponse)
                                    }
                                  
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    
    private func getURL(query: String) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "aac7791fc2cf4990914142821221612"
        guard let url = "\(baseUrl)\(currentEndpoint)?key=\(apiKey)&q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        print(url)
        return URL(string: url)
    }
    private func parseJson(data: Data) -> weatherResponse? {
        let decoder = JSONDecoder()
        var weather: weatherResponse?
        
        do{
            weather = try decoder.decode(weatherResponse.self, from: data)
        }
        catch{
            print("Error decoding")
        }
        return weather
    }
 

    
}

struct weatherResponse: Decodable {
    let location: Location
    let current: weather
}
struct Location: Decodable {
    let name: String
}
struct weather: Decodable {
    let temp_c: Float
    let temp_f: Float
    let condition: weatherCondition
}
struct weatherCondition: Decodable {
let text: String
}

