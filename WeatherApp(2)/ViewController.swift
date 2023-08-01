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
    var models = [Weather]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("hello?")
        setupLocation()
        
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func search(_ sender: Any) {
        print(searchText.text)
        let text1 = searchText.text?.lowercased()
        let text2 = text1!.replacingOccurrences(of: " ", with: "_")
        let url = "https://api.weatherapi.com/v1/current.json?key=2e5069421ef94f68bc4235330233107&q=\(String(text2))"
        
        print(url)
        
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
            
            print(result)
        }).resume()
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
            
            print(result)
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
}

