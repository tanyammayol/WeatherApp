//
//  ViewController.swift
//  Weather App
//
//  Created by Tanya Marion Mayol on 7/31/23.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    var models = [Weather]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var tempC = "0";
    var tempF = "0";
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("hello?")
        setupLocation()
    }
    
    @IBAction func currentLocationBtn(_ sender: Any) {
    }
    @IBAction func searchBtn(_ sender: Any) {
    }
    @IBAction func search(_ sender: Any) {
    
        let text = (searchText.text?.lowercased())!.replacingOccurrences(of: " ", with: "_")
        let url = "https://api.weatherapi.com/v1/current.json?key=2e5069421ef94f68bc4235330233107&q=\(String(text))"
        
        print(url)
        
        
        URLSession.shared.dataTask(with: URL(string: url)!,completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var json: Weather?
            do{
                json = try JSONDecoder().decode(Weather.self, from: data)
            }
            catch {
                print("error \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            tempC = String(result.current.temp_c)
            print(tempC)
        }).resume()
        
        print("temp: \(tempC)")
        if tempC != "0" {
            tempLabel.text = tempC
        }
        
    }
    
    //Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print(locationManager)
        print("setting up location . . .")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.last
            print("???? \(locations)")
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    
    
    func requestWeatherForLocation() {
        print("requesting")
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
               
        
        print("\(long) \(lat)")
        
        let url = "https://api.weatherapi.com/v1/current.json?key=2e5069421ef94f68bc4235330233107&q=\(lat),\(long)"
        
        URLSession.shared.dataTask(with: URL(string: url)!,completionHandler: {data, response, error in
            
            //validation
            //convert data to models/some object
            //update user interface
            print("here????")
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var json: Weather?
            do{
                json = try JSONDecoder().decode(Weather.self, from: data)
            }
            catch {
                print("error \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            print("result")
            print(result.current.temp_c)
        }).resume()
    }
 
 
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

struct Weather: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let lon:  Float
    let name: String
    let region: String
    let country: String
}

struct Current: Codable {
    let temp_c: Float
    let temp_f: Float
    let condition: Condition
}

struct Condition:  Codable {
    let text: String
    let code: Int
}

