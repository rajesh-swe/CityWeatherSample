//
//  CountrySearchVC.swift
//  WeatherApp
//
//  Created by LP-221 on 06/11/16.
//  Copyright © 2016 LP-221. All rights reserved.
//

import UIKit

let ACTIVITY_TAG: Int = 9834

class CountrySearchVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var countryCities = CountryCities()
    var enteredCountryName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.showActivityIndicator()        
        let parser = XMLCityParser()
        DispatchQueue.global().async {
            self.enteredCountryName = searchBar.text!
            parser.parseXMLForCountry(country: self.enteredCountryName, onSuccess: { (citiesList) in
            
                self.countryCities = citiesList
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.prepareCitiesList(citiesData: self.countryCities)
                }
            })
        }
    }
    
    func prepareCitiesList(citiesData : CountryCities) {
        
        if citiesData.citiesList.count > 0 {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let cityVC: CitiesListVC = storyBoard.instantiateViewController(withIdentifier: "CitiesListVC") as! CitiesListVC
            cityVC.citiesData = citiesData
            self.navigationController?.pushViewController(cityVC, animated: true)
        }
        else {
            Helper.getErrorAlertWithMessage("Cities data not found for \(self.enteredCountryName)", perentController: self)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
