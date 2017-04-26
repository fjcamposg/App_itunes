//
//  LocalCoreDataService.swift
//  App_itunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService{
    //1 -> Desde localservice se invoca a remote service 
    let remoteMovieService = RemoteitunesMovieService()
    let stack = CoreDataStack.shared
    
    func searchMovies(_ byterm : String, remoteHandler : @escaping ([MovieModel]?)->()){
    //2 -> 
        remoteMovieService.searchMovies(byterm) { (result) in
            if let movieData = result {
                var modelMovies = [MovieModel]()
                for c_movie in movieData {
                    let obj = MovieModel(pId: c_movie["id"]!, pTitle: c_movie["title"]!, pOrder: nil, pSummary: c_movie["summary"]!, pImage: c_movie["image"]!, pCategory: c_movie["category"]!, pDirector: c_movie["director"]!)
                    modelMovies.append(obj)
                }
                remoteHandler(modelMovies)
            } else {
                print("Error mientras se llama a los servicios de itunes")
                remoteHandler(nil)
            }
            
        }
    }
    func topMovie(_ localHandler : @escaping ([MovieModel]?) ->(), remoteHandler : @escaping([MovieModel]?) -> ()){
        localHandler(queryTopMovies())
        remoteMovieService.getTopMovies{ (result) in
            if let moviesData = result {
                // Proceso sincronizacion que marque todos los objetos no sinconizados
                self.markAllMoviesUnsync()
                var order = 1
                for c_movieDiccionario in moviesData{
                    // consultar si la pelicula la tenemos en coredata
                    if let movieData = self.getMovieById(c_movieDiccionario["id"]!, favorito: false){
                        //update
                        self.updateMovie(c_movieDiccionario, movie: movieData, order: order)
                    } else {
                        // inserta
                        self.insertMovie(c_movieDiccionario, order: order)
                    }
                    order += 1
                }
                
                // borrar lo no sincronizado
                self.removeAllnotFavoriteMovies()
                
                remoteHandler(self.queryTopMovies())
                
                
            } else {
                print("Error mientras se llama a los servicios de itunes")
                remoteHandler(nil)
            
            }
        }
    
        
    }
    
    func queryTopMovies() -> [MovieModel]?{
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        do {
            let fetchMovies = try context.fetch(request)
            var movie  = [MovieModel]()
            for c_manage in fetchMovies{
                movie.append(c_manage.mappedObject())
            }
            return movie
        }catch{
            print ("Error mientras se obtienen as pelicuas desde core-data")
            return nil
        }
    }
    
    func markAllMoviesUnsync(){
            let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        do {
            let fetchMovies = try context.fetch(request)
            for c_manage in fetchMovies{
                //vamos a cambiar su propiedad sync
                c_manage.sync = false
            }
            
        } catch {
            print ("Error miesras se actualizan las peliculas desde CoreData")
        }
        
    }
    
    func getMovieById(_ id : String, favorito : Bool) -> MovieManager?{
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "id = \(id) and favorito = \(favorito)") //
        request.predicate = customPredicate
        do {
            let fetchmovies = try context.fetch(request)
            // si tiene algun registro debe retornar uno
            if fetchmovies.count > 0{
                return fetchmovies.last
            } else {
                return nil
            }
        }catch {
            print("Error mientras se obtienen peliculas desde Coredata")
            return nil
        }
        
    }
    func insertMovie(_ movieDiccionario : [String : String],  order : Int){
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        movie.id = movieDiccionario["id"]
        updateMovie(movieDiccionario, movie: movie, order: order)
    }

    
    
    func updateMovie(_ movieDiccionario : [String : String], movie : MovieManager, order : Int){
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        movie.sync = true
        
        do{
            try context.save()
        }catch{
            print("Error mientras se actualiza el coredata")
        }
        
        
    }

    func removeAllnotFavoriteMovies(){
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        do{
            let fetchMovies = try context.fetch(request)
            for c_manageMovie in fetchMovies{
                if !c_manageMovie.sync{
                    context.delete(c_manageMovie)
                }
            }
            try context.save()
        }catch{
            print("Error mientras se esta borrando el coredata")
        }
    }
    
    
    
    
    
    
    
    
    
    
}
