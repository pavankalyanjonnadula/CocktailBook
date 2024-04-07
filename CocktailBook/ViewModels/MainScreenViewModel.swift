//
//  MainScreenViewModel.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 04/04/24.
//

import Foundation

class MainScreenViewModel {
    
    @Published var cocktailsList : [Cocktails] = []
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    var cocktailsListCopy  : [Cocktails] = []
    
    fileprivate func decodeThedata(cocktailData : Data) {
        let decoder = JSONDecoder()
        do{
            let cocktails : [Cocktails] = try decoder.decode([Cocktails].self, from: cocktailData)
            self.cocktailsListCopy = cocktails
            self.addFavouriteCocktails(cocktials: cocktails)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchCocktails(){
        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                self.decodeThedata(cocktailData: data)
            }
        }
    }
    
    func switchSelection(segmentSelected : Int){
        if segmentSelected == 1{
            filterCocktailsAccording(type: .alcoholic, cocktials: cocktailsListCopy)
        }else if segmentSelected == 2{
            filterCocktailsAccording(type: .nonalcoholic, cocktials: cocktailsListCopy)
        }else{
            sortTheCocktails(cocktials: cocktailsListCopy)
        }
    }
    
    func addFavouriteCocktails(cocktials : [Cocktails]){
        let favouriteCocktailsIds = UserDefaultsManager.shared.getStrings() ?? []
        var finalCocktails = cocktials
        if favouriteCocktailsIds.count > 0{
            finalCocktails = cocktials.map { cocktail in
              var newCocktail = cocktail // Create a copy
                if favouriteCocktailsIds.contains(cocktail.id ?? "") {
                    newCocktail.favourite = true
                }
                return newCocktail
            }
        }
        sortTheCocktails(cocktials: finalCocktails)
    }
    
    func sortTheCocktails(cocktials : [Cocktails]){
        self.cocktailsList = cocktials.sorted(by: { cocktail1, cocktail2 in
            if cocktail1.favourite != cocktail2.favourite{
                return cocktail1.favourite
            }
            return (cocktail1.name ?? "") < (cocktail2.name ?? "")
        })
    }
    
    func filterCocktailsAccording(type : CocktailTypes,cocktials : [Cocktails]){
        if type == .alcoholic{
            self.cocktailsList = cocktials.filter({ cocktail in
                if cocktail.type == "alcoholic"{
                    return true
                }
                return false
            })
        }else if type == .nonalcoholic{
            self.cocktailsList = cocktials.filter({ cocktail in
                if cocktail.type == "non-alcoholic"{
                    return true
                }
                return false
            })
        }
    }
}
