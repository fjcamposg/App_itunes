//
//  DetallePeliculaViewController.swift
//  App_itunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher


class DetallePeliculaViewController: UIViewController {

    
    // MARK: - vbles locales
    var movie : MovieModel?
    let dataProvider = LocalCoreDataService()
    
    // MARK: - IBoutlets
    
    
    @IBOutlet weak var myImagePelicula: UIImageView!
    
    @IBOutlet weak var myTituloPelicula: UILabel!
    
    @IBOutlet weak var myDirectorPelicula: UILabel!
    
    @IBOutlet weak var myCategoriaPelicula: UILabel!
    
    @IBOutlet weak var myButtonMeInteresaBTN: UIButton!
    
    
    @IBOutlet weak var mySinopsisTV: UITextView!
    
    
    
    // MARK: - Actions
    
    
    @IBAction func peliculaFavoritaAction(_ sender: Any) {
    
        configuredFavoriteBTN()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: -Utils
    
    func configuredFavoriteBTN(){
        if let movieData = movie{
            if dataProvider.isFavorite(movieData){
                myButtonMeInteresaBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                myButtonMeInteresaBTN.setTitle("Quiero verla!", for: .normal)
            } else {
                myButtonMeInteresaBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                myButtonMeInteresaBTN.setTitle("No me interesa!", for: .normal)
            }
        }
    }

}
