//
//  Rest.swift
//  MyCars
//
//  Created by Danilo Requena on 03/03/20.
//  Copyright © 2020 Danilo Requena. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

class REST {
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let config  = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type" : "application/json"]
        config.timeoutIntervalForRequest = 20.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    private static let session = URLSession(configuration: configuration) //URLSession.shared
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        guard let url = URL(string: "https://fipeapi.appspot.com/api/1/carros/marcas.json") else {
            onComplete(nil)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                        
                    } catch {
                        onComplete(nil)
                    }
                } else {
                    onComplete(nil)
                    print("Algum status invalido pelo servidor")
                }
            } else {
                onComplete(nil)
            }
        }
        dataTask.resume()
    }
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                        
                    } catch {
                        onError(.invalidJSON)
                    }
                } else {
                    onError(.responseStatusCode(code: response.statusCode))
                    print("Algum status invalido pelo servidor")
                }
            } else {
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOparation(car: car, oparation: .save, onComplete: onComplete)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOparation(car: car, oparation: .update, onComplete: onComplete)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void) {
           applyOparation(car: car, oparation: .delete, onComplete: onComplete)
       }
    private class func applyOparation(car: Car, oparation: RESTOperation, onComplete: @escaping (Bool) -> Void) {
        let urlString = basePath + "/" + (car._id ?? "")
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        var request = URLRequest(url: url)
        var httpMethod: String = ""
        switch oparation {
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        case .delete:
            httpMethod = "DELETE"
        }
        
        guard let json = try?JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        //        do {
        //            let json = try JSONEncoder().encode(car)
        //        } catch {
        //            print(error.localizedDescription)
        //        } ---- jeito principal de se fazer isso
        request.httpBody = json
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
