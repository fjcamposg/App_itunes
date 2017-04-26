//
//  RemoteitunesMovieService.swift
//  App_itunes
//
//  Created by cice on 19/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RemoteitunesMovieService {
    // Metodo de buscar peliculas y otro para el top con callbacks
    func getTopMovies(completionHandler : @escaping (_ arrayDiccionario : [[String : String]]?) -> ()){
        let urlData = URL(string: "https://itunes.apple.com/es/rss/topmovies/limit=99/json")!
        Alamofire.request(urlData,
                          method: .get).validate().responseJSON { (responseData) in
                            switch responseData.result{
                            case .success:
                            // Parseamos y lo metemos en un diccionario
                                if let valorData = responseData.result.value{
                                    let json = JSON(valorData)
                                    var resultData = [[String : String]]()
                                    let entries = json["feed"]["entry"].arrayValue
                                    for c_entry in entries{
                                        var movieDiccionario = [String : String]()
                                        movieDiccionario["id"] = c_entry["id"]["attributes"]["im:id"].stringValue
                                        movieDiccionario["title"] = c_entry["im:name"]["label"].stringValue
                                        movieDiccionario["summary"] = c_entry["summary"]["label"].stringValue
                                        movieDiccionario["image"] = c_entry["im:image"][0]["label"].stringValue.replacingOccurrences(of: "60x60", with: "500x500")
                                        movieDiccionario["category"] = c_entry["category"]["attributes"]["label"].stringValue
                                        movieDiccionario["director"] = c_entry["im:artist"]["label"].stringValue
                                        resultData.append(movieDiccionario)
                                        
                                    }
                                    completionHandler(resultData)
                                }
                                
                                
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                                completionHandler(nil)
                                
                            }
                }
        
    }
    
    // busqueda de datos pasando un parametro que es el termino de busqueda
    func searchMovies(_ byTerm : String, completionHandler : @escaping (_ arrayDiccionario : [[String : String]]?) -> ()){
        let urlData = URL(string: "https://itunes.apple.com/search")! //?media=movie&attributes=movieTerm&term=batman")
        Alamofire.request(urlData, method: .get,
                          parameters: ["media" : "movie", "attributes" : "movieTerm", "term" : byTerm],
                          encoding: URLEncoding.default,
                          headers: nil).validate().responseJSON { (resultData) in
                            switch resultData.result{
                            case .success:
                                if let valorData = resultData.result.value{
                                    let json = JSON(valorData)
                                    var resultMovie = [[String : String]]()
                                    let entries = json["results"].arrayValue
                                    for c_entrie in entries{
                                        var movieDiccionario = [String : String]()
                                        movieDiccionario["id"] = c_entrie["trackId"].stringValue
                                        movieDiccionario["title"] = c_entrie["trackName"].stringValue
                                        movieDiccionario["summary"] = c_entrie["longDescription"].stringValue
                                        movieDiccionario["image"] = c_entrie["artworkUrl100"].stringValue.replacingOccurrences(of: "100x100", with: "500x500")
                                        movieDiccionario["category"] = c_entrie["primaryGenreName"].stringValue
                                        movieDiccionario["director"] = c_entrie["artistName"].stringValue
                                        resultMovie.append(movieDiccionario)
                                    }
                                    completionHandler(resultMovie)
                                }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                                completionHandler(nil)
                            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
