//
//  ViewController.swift
//  Weather App
//
//  Created by Tanya Marion Mayol, Manmohan Singh, Pranav Malhotra on 7/31/23.
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
    
    let imageview: UIImageView = {
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageview.contentMode = .scaleAspectFit
        return imageview
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageview)
        imageview.center = CGPoint(x: 200, y: 240)
        let customColor = UIColor(red: 101/255, green: 94/255, blue: 176/255, alpha: 1.0)
        
        let config = UIImage.SymbolConfiguration(paletteColors: [customColor, .white])
        imageview.preferredSymbolConfiguration = config
        
        searchText.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func currentLocationBtn(_ sender: Any) {
        checkLocationPermission()
            }
            
            func checkLocationPermission() {
                let status = CLLocationManager.authorizationStatus()
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    // Location services authorized, fetch the current location here
                    locationManager.requestLocation()
                case .denied, .restricted:
                    // Location services denied or restricted, show an alert to the user
                    showLocationPermissionDeniedAlert()
                case .notDetermined:
                    // Location permission not determined, request permission
                    locationManager.requestWhenInUseAuthorization()
                @unknown default:
                    // Handle any future authorization status cases
                    break
                }
            }


            // MARK: - CLLocationManagerDelegate
    func showLocationPermissionDeniedAlert() {
           let alert = UIAlertController(title: "Location Permission Required", message: "Please go to Settings and allow location access for this app.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")

           // Fetch weather data using location coordinates
           loadWeather(search: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to get location: \(error.localizedDescription)")
       }
    
        
    func loadWeatherSymbol(for condition: String) {
        DispatchQueue.main.async {
            let symbolName = self.getWeatherSymbolName(for: condition)
            self.imageview.image = UIImage(systemName: symbolName)
        }
    }
    
    func getWeatherSymbolName(for condition: String) -> String {
        let cleanedCondition = condition.lowercased().trimmingCharacters(in: .whitespaces)
        let weatherSymbols: [String: String] = [
            "sunny": "sun.max",
            "partly cloudy": "cloud.sun",
            "cloudy": "cloud",
            "overcast": "smoke",
            "mist": "cloud.fog",
            "patchy rain possible": "cloud.drizzle",
            "patchy snow possible": "cloud.snow",
            "patchy sleet possible": "cloud.sleet",
            "patchy freezing drizzle possible": "cloud.drizzle",
            "thundery outbreaks possible": "cloud.bolt.rain",
            "blowing snow": "wind.snow",
            "blizzard": "wind.snow",
            "fog": "cloud.fog",
            "freezing fog": "cloud.fog",
            "patchy light drizzle": "cloud.drizzle",
            "light drizzle": "cloud.drizzle",
            "freezing drizzle": "cloud.drizzle",
            "heavy freezing drizzle": "cloud.hail",
            "patchy light rain": "cloud.drizzle",
            "light rain": "cloud.rain",
            "moderate rain at times": "cloud.rain",
            "moderate rain": "cloud.rain",
            "heavy rain at times": "cloud.rain",
            "heavy rain": "cloud.rain",
            "light freezing rain": "cloud.hail",
            "moderate or heavy freezing rain": "cloud.hail",
            "light sleet": "cloud.sleet",
            "moderate or heavy sleet": "cloud.sleet",
            "patchy light snow": "cloud.snow",
            "light snow": "cloud.snow",
            "patchy moderate snow": "cloud.snow",
            "moderate snow": "cloud.snow",
            "patchy heavy snow": "cloud.snow",
            "heavy snow": "cloud.snow",
            "ice pellets": "cloud.hail",
            "light rain shower": "cloud.drizzle",
            "moderate or heavy rain shower": "cloud.rain",
            "torrential rain shower": "cloud.heavyrain",
            "light sleet showers": "cloud.sleet",
            "moderate or heavy sleet showers": "cloud.sleet",
            "light snow showers": "cloud.snow",
            "moderate or heavy snow showers": "cloud.snow",
            "light showers of ice pellets": "cloud.hail",
            "moderate or heavy showers of ice pellets": "cloud.hail",
            "patchy light rain with thunder": "cloud.bolt.rain",
            "moderate or heavy rain with thunder": "cloud.bolt.rain",
            "patchy light snow with thunder": "cloud.bolt.snow",
            "moderate or heavy snow with thunder": "cloud.bolt.snow",
            "clear": "sun.min"
        ]
        
        return weatherSymbols[cleanedCondition] ?? "questionmark"
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
                    citiesListVC.isFahrenheit = isFahrenheit
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
                    self.loadWeatherSymbol(for: weatherResponse.current.condition.text)
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
        catch let error {
                print("Error decoding JSON: \(error)")
                return nil
        }
        return weather
    }
 

    
}

struct weatherResponse: Decodable {
    let location: Location
    let current: weather
    var isFahrenheit: Bool?
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

