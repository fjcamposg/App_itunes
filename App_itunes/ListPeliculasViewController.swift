//
//  ListPeliculasViewController.swift
//  App_itunes
//
//  Created by cice on 24/4/17.
//  Copyright © 2017 cice. All rights reserved.
//

import UIKit
import Kingfisher

class ListPeliculasViewController: UIViewController {
    // MARK: - vbles locales
    
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    var customRefreshControll = UIRefreshControl()
    var dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
    
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customRefreshControll.addTarget(self, action: #selector(loadData), for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = CONSTANTES.COLORES_BASE.COLOR_ROJO_GENERAL
        myCollectionView.refreshControl = customRefreshControll
        tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))

        loadData()
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        
    }
    
    func hideKeyboard(){
        
    }
    
   
}


extension ListPeliculasViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionViewPadding = (anchoPantalla - (3 * 113))/4 // espacio residual entre las vistas
        
    }
    
    // insets parametros donde se va a justar graficamente
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right:collectionViewPadding)
    }
}
