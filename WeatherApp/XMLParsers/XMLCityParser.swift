//
//  XMLCityParser.swift
//  WeatherApp
//
//  Created by LP-221 on 07/11/16.
//  Copyright © 2016 LP-221. All rights reserved.
//

import Foundation

let BaseURL : String = "http://www.webservicex.net/globalweather.asmx/"

class XMLCityParser : NSObject, XMLParserDelegate {
    
    var currentElement:String = ""
    var countryCities = CountryCities()
    var cityFound: Bool = false
    var parser = XMLParser()
    
    func parseXMLForCountry(country: String, onSuccess: @escaping (_ parsedList:CountryCities) -> Void){
        
        let url:String = BaseURL + "GetCitiesByCountry?CountryName=" + country
        let escapedQuery = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let urlToSend: URL = URL(string: escapedQuery!) {

            let task = URLSession.shared.dataTask(with: urlToSend) {
                (data, response, error) in
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                let decodedString = responseString?.stringByDecodingHTMLEntities
                print("CitiesXML Data ==> \(decodedString)")
                self.parseData(data: (decodedString?.data(using: .utf8))!, onSuccess: { (citiesData) in
                    
                    onSuccess(citiesData)
                })
            }
            task.resume()
        }
    }
    
    func parseData(data: Data, onSuccess: @escaping (_ parsedList:CountryCities) -> Void) {
        
        // Parse the XML
        parser = XMLParser(data: data)
        parser.delegate = self
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            onSuccess(countryCities)
        } else {
            print("parse failure!")
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
        if(elementName == "City" ) {
            cityFound = true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        currentElement = "";
        if(elementName == "City") {
            cityFound = false;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if(cityFound){
            countryCities.citiesList.append(string)
        }
        else if currentElement == "Country" {
            countryCities.country = string
        }
     }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}
