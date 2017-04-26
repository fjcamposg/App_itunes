//
//  ListaFavoritosViewController.swift
//  App_itunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher

class ListaFavoritosViewController: UIViewController {

    
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    var dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
@IBOutlet weak var myCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self


    
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

// MARK: - UTILS
    func loadData(){
        if let movieData = dataProvider.getFavoriteMovie(){
            movies = movieData
            myCollectionView.reloadData()
        }
    }
    
}

extension ListaFavoritosViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionViewPadding = (anchoPantalla - (3 * 113))/4 // espacio residual entre las vistas
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right:collectionViewPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewPadding
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movies.count==0{
            let imageView = UIImageView(image: #imageLiteral(resourceName: "sin-favoritas"))
            imageView.contentMode = .center
            myCollectionView.backgroundView = imageView
        }else {
            myCollectionView.backgroundView = UIView()
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PeliculaCustomCellCollectionViewCell
        let movieData = movies[indexPath.row]
        configuredCell(customCell, withMovie: movieData)
        return customCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }

    func configuredCell(_ cell : PeliculaCustomCellCollectionViewCell, withMovie movie : MovieModel){
        if let imageData = movie.image{
            cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!),
                                          placeholder: #imageLiteral(resourceName: "img-loading"),
                                          options: nil,
                                          progressBlock: nil,
                                          completionHandler: nil)
            
            
        }
    }
    

}
