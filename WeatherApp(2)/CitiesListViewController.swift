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
    var isFahrenheit = false 
    
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
    
        let weatherIconName = getWeatherSymbolName(for: cityWeather.current.condition.text)
                cell.weatherIcon.image = UIImage(systemName: weatherIconName)
        
        if cityWeather.isFahrenheit ?? false {
            cell.temp.text = "\(cityWeather.current.temp_f)°F"
        } else {
            cell.temp.text = "\(cityWeather.current.temp_c)°C"
        }

        return cell
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

}
