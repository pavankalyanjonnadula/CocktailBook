//
//  CocktailsDetailsViewController.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 05/04/24.
//

protocol UpdateCocktailsDelegate{
    func refreshCocktail()
}

import UIKit

class CocktailsDetailsViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cocktailsImage: UIImageView!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var ingrediantsStackView: UIStackView!
    @IBOutlet weak var favouriteBtn: UIBarButtonItem!

    var cocktailDetails : Cocktails?
    var isFavourite = false
    var delegate : UpdateCocktailsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (cocktailDetails?.favourite ?? false) != isFavourite{
            delegate?.refreshCocktail()
        }
    }
    
    func initializeData(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        descriptionLabel.text = cocktailDetails?.longDescription ?? ""
        navigationItem.title = cocktailDetails?.name ?? ""
        cocktailsImage.image = UIImage(named: cocktailDetails?.imageName ?? "margarita")
        minutesLabel.text = "\(cocktailDetails?.preparationMinutes ?? 0) minutes"
        cocktailDetails?.ingredients?.forEach({ ingrediant in
            ingredientsSubview(ingredients: ingrediant)
        })
        isFavourite = cocktailDetails?.favourite ?? false
        favouriteBtn.image = isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }

    @IBAction func favouriteBtnAction(_ sender: UIBarButtonItem) {
        if !isFavourite{
            sender.image = UIImage(systemName: "heart.fill")
            UserDefaultsManager.shared.addNewFavourite(cocktailDetails?.id ?? "")
        }else{
            sender.image = UIImage(systemName: "heart")
            UserDefaultsManager.shared.removeFavourite(cocktailDetails?.id ?? "")

        }
        isFavourite.toggle()
    }
    
    func ingredientsSubview(ingredients : String){
        print(ingredients)
        let ingrediantsView = IngrediantsView()
        ingrediantsView.setText(ingredients)
        ingrediantsStackView.addArrangedSubview(ingrediantsView)
    }
    
}
