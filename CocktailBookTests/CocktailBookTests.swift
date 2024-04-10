import XCTest
@testable import CocktailBook

class CocktailBookTests: XCTestCase {
    
    var viewModel : MainScreenViewModel!
    
    override func setUpWithError() throws {
        viewModel = MainScreenViewModel(cocktailsAPI: FakeCocktailsAPI())
    }

    override func tearDownWithError() throws {
    }

    func testDecodeLogic(){
        viewModel.decodeThedata(cocktailData: getCocktailsDataFromSampleMockJSON() ?? Data())
        XCTAssert(viewModel.cocktailsList.count > 0, "Data decoding is sucessfull")
        XCTAssert(viewModel.cocktailsListCopy.count > 0)
    }
    
    func getCocktailsDataFromSampleMockJSON() -> Data?{
        guard let filePath = Bundle.main.path(forResource: "sample", ofType: "json") else {
            // Handle file not found error
            print("Error: sample.json not found")
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            return data
        }
        catch {
            // Handle file reading or JSON parsing errors
            print("Error: Could not read or parse JSON file: \(error)")
        }
        return nil
    }
    
    func testFilterTheAlcoholCocktails(){
        viewModel.decodeThedata(cocktailData: getCocktailsDataFromSampleMockJSON() ?? Data())
        viewModel.filterCocktailsAccording(type: .alcoholic, cocktials: viewModel.cocktailsListCopy)
        XCTAssert((viewModel.cocktailsList.first?.type ?? "") == "alcoholic")

    }
    
    func testFilterTheNonAlcoholCocktails(){
        viewModel.decodeThedata(cocktailData: getCocktailsDataFromSampleMockJSON() ?? Data())
        viewModel.filterCocktailsAccording(type: .nonalcoholic, cocktials: viewModel.cocktailsListCopy)
        XCTAssert((viewModel.cocktailsList.first?.type ?? "") == "non-alcoholic")
    }
    
    func testAddfavourite(){
        viewModel.decodeThedata(cocktailData: getCocktailsDataFromSampleMockJSON() ?? Data())
        if viewModel.cocktailsListCopy.count > 10{
            let randomInt = Int.random(in: 0...9)
            UserDefaultsManager.shared.addNewFavourite("\(randomInt)")
        }
        viewModel.addFavouriteCocktails(cocktials: viewModel.cocktailsList)
        XCTAssert(viewModel.cocktailsList.first?.favourite ?? false,"Favourite cocktails successfully added")
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
