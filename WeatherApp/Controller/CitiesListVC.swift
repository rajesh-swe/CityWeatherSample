//
//  CitiesListVC.swift
//  WeatherApp
//
//  Created by LP-221 on 06/11/16.
//  Copyright © 2016 LP-221. All rights reserved.
//

import UIKit

class CitiesListVC: UITableViewController {

    var citiesData = CountryCities()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = citiesData.country
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSouce
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return citiesData.citiesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).row < (citiesData.citiesList.count) {
            
            let cityCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            cityCell.textLabel?.text = citiesData.citiesList[(indexPath as NSIndexPath).row]
            cityCell.detailTextLabel?.text = ""
            return cityCell
        }
        return UITableViewCell()
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row < (citiesData.citiesList.count) {
            
            let cityName = citiesData.citiesList[(indexPath as NSIndexPath).row]
            getWeatherInfo(cityName: cityName)
        }
    }
    
    func getWeatherInfo(cityName : String) {
        
        self.showActivityIndicator()
        let parser = XMLCityWeatherParser()
        DispatchQueue.global().async {
            parser.parseXMLForCityWeather(city: cityName, country: self.citiesData.country!, onSuccess: { (weatherData) in
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    if weatherData == nil {
                        
                        Helper.getErrorAlertWithMessage("Weather data not found for \(cityName)", perentController: self)
                    }
                    else {
                        self.prepareForWeatherInfo(weatherData: weatherData!)
                    }
                }
            })
        }
    }
    
    func prepareForWeatherInfo(weatherData : WeatherInfo) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let weatherInfoVC: WeatherInfoVC = storyBoard.instantiateViewController(withIdentifier: "WeatherInfoVC") as! WeatherInfoVC
        weatherInfoVC.weatherData = weatherData
        self.navigationController?.pushViewController(weatherInfoVC, animated: true)
    }
}
