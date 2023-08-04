//
//  CitiesListViewController.swift
//  WeatherApp(2)
//
//  Created by Manmohan Singh on 2023-08-04.
//

import UIKit

class CitiesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var searchedCitiesWeather: [weatherResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
                tableView.dataSource = self
       
        // Do any additional setup after loading the view.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchedCitiesWeather.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherCell", for: indexPath) as! WeatherTableViewCell

        let cityWeather = searchedCitiesWeather[indexPath.row]
        cell.cityName.text = cityWeather.location.name
        
        if cityWeather.isFahrenheit {
            cell.temp.text = "\(cityWeather.current.temp_f)°F"
        } else {
            cell.temp.text = "\(cityWeather.current.temp_c)°C"
        }

        return cell
    }

}
