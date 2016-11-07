//
//  XMLParser.swift
//  WeatherApp
//
//  Created by LP-221 on 07/11/16.
//  Copyright © 2016 LP-221. All rights reserved.
//

import Foundation

class XMLCityWeatherParser : NSObject, XMLParserDelegate {
    
    var currentElement:String = ""
    var weatherData : WeatherInfo? = nil
    var parser = XMLParser()
    
    func parseXMLForCityWeather(city: String, country: String, onSuccess: @escaping (_ weatherData:WeatherInfo?) -> Void){
        
        let url:String = BaseURL + "GetWeather?CityName=\(city)&CountryName=\(country)"
        let escapedQuery = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let urlToSend: URL = URL(string: escapedQuery!) {
         
            let task = URLSession.shared.dataTask(with: urlToSend) {
                (data, response, error) in
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                let decodedString = responseString?.stringByDecodingHTMLEntities
                print("CitiesXML Data ==> \(decodedString)")
                self.parseData(data: (decodedString?.data(using: .utf8))!, onSuccess: { (weatherData) in
                    
                    onSuccess(weatherData)
                })
            }
            task.resume()
        }
    }
    
    func parseData(data: Data, onSuccess: @escaping (_ weatherData: WeatherInfo?) -> Void) {
        
        // Parse the XML
        parser = XMLParser(data: data)
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            onSuccess(weatherData)
        } else {
            print("parse failure!")
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        currentElement = "";
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}

