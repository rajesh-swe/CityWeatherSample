//
//  Helper.swift
//  WeatherApp
//
//  Created by LP-221 on 07/11/16.
//  Copyright © 2016 LP-221. All rights reserved.
//

import Foundation
import UIKit


class Helper {
    
    @discardableResult
    class func getErrorAlertWithMessage(_ errorMessage: String, perentController: UIViewController)->  UIAlertController{
        
        let errorAlertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        errorAlertController.addAction(cancelAction)
        perentController.present(errorAlertController, animated: true, completion: nil)
        return errorAlertController
    }
}

extension UIViewController {
    
    @discardableResult
    func showActivityIndicator() -> UIActivityIndicatorView {
        
        let hasActivityViewExist = self.view.viewWithTag(ACTIVITY_TAG) != .none;
        if (hasActivityViewExist) {
            let activityView = self.view.viewWithTag(ACTIVITY_TAG)! as! UIActivityIndicatorView;
            activityView.isHidden = false;
            activityView.alpha = 1.0;
            activityView.startAnimating();
            return activityView;
        } else {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray);
            activityView.tag = ACTIVITY_TAG;
            self.view.addSubview(activityView);
            activityView.center = self.view.center;
            activityView.isHidden = false;
            activityView.alpha = 1.0;
            activityView.hidesWhenStopped = true
            activityView.startAnimating();
            
            return activityView;
        }
    }
    
    func hideActivityIndicator() {
        let hasActivityViewExist = self.view.viewWithTag(ACTIVITY_TAG) != .none;
        
        if (hasActivityViewExist) {
            let activityView = self.view.viewWithTag(ACTIVITY_TAG)! as! UIActivityIndicatorView;
            activityView.isHidden = true;
            activityView.alpha = 0.0;
            activityView.stopAnimating();
        }
    }
}

private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    var stringByDecodingHTMLEntities : String {
        
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        var result = ""
        var position = startIndex
        
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    
                    result.append(decoded)
                } else {
                    
                    result.append(entity)
                }
            } else {
                
                break
            }
        }
        result.append(self[position ..< endIndex])
        return result
    }
}
