//
//  MovieManager+Mapping.swift
//  App_itunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import Foundation

extension MovieManager{
    // Con esto sobre cualquier objeto Manage podrá ejecutar el retorno de un objeto del,tipo movieModel
    
    func mappedObject() -> MovieModel{
        return MovieModel(pId: self.id!, pTitle: self.title!, pOrder: Int(self.order), pSummary: self.summary!, pImage: self.image!, pCategory: self.category!, pDirector: self.director!)
    }
    
    
}
