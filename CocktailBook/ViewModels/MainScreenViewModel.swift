//
//  MainScreenViewModel.swift
//  CocktailBook
//
//  Created by Jonnadula Pavan Kalyan  on 04/04/24.
//

import Foundation

class MainScreenViewModel {
    
    @Published var cocktailsList : [Cocktails] = []
    private let cocktailsAPI: CocktailsAPI
    var cocktailsListCopy  : [Cocktails] = []
    @Published var isErrorReceived = false
    
    init(cocktailsAPI: CocktailsAPI) {
        self.cocktailsAPI = cocktailsAPI
    }
    
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
            if case .failure(_) = result {
                self.isErrorReceived = true
            }
        }
    }
    
    func switchSelection(segmentSelected : Int){
        if segmentSelected == 1{
            filterCocktailsAccording(type: .alcoholic, cocktials: cocktailsListCopy)
        }else if segmentSelected == 2{
            filterCocktailsAccording(type: .nonalcoholic, cocktials: cocktailsListCopy)
        }else{
            addFavouriteCocktails(cocktials: cocktailsListCopy)
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
                }else{
                    newCocktail.favourite = false
                }
                return newCocktail
            }
        }
        sortTheCocktails(cocktials: finalCocktails)
    }
    
    func sortTheCocktails(cocktials : [Cocktails]){
       
        let unFavouriteCocktails = getCocktailsDependsOn(isFavourite: false, cokcktails: cocktials)
        var sortedUnFavouriteCocktails = unFavouriteCocktails.sorted {($0.name ?? "") < ($1.name ?? "")}
        let favouriteCocktails = getCocktailsDependsOn(isFavourite: true, cokcktails: cocktials)
        if !favouriteCocktails.isEmpty{
            let sortedFavouriteCocktails = favouriteCocktails.sorted {($0.name ?? "") < ($1.name ?? "")}
            sortedUnFavouriteCocktails = sortedFavouriteCocktails + sortedUnFavouriteCocktails
        }
        self.cocktailsList = sortedUnFavouriteCocktails

    }
    
    func filterCocktailsAccording(type : CocktailTypes,cocktials : [Cocktails]){
        var filteredCocktails : [Cocktails] = []
        if type == .alcoholic{
            filteredCocktails = cocktials.filter({ cocktail in
                if cocktail.type == "alcoholic"{
                    return true
                }
                return false
            })
        }else if type == .nonalcoholic{
            filteredCocktails = cocktials.filter({ cocktail in
                if cocktail.type == "non-alcoholic"{
                    return true
                }
                return false
            })
        }
        addFavouriteCocktails(cocktials: filteredCocktails)
    }
    
    func getCocktailsDependsOn(isFavourite : Bool,cokcktails : [Cocktails]) -> [Cocktails]{
        if isFavourite{
            return cokcktails.filter { $0.favourite }
        }else{
            return cokcktails.filter { $0.favourite == false }
        }
    }
}
