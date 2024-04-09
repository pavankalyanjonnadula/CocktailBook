import XCTest
@testable import CocktailBook

class CocktailBookTests: XCTestCase {
    
    var viewModel : MainScreenViewModel!
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = MainScreenViewModel(cocktailsAPI: FakeCocktailsAPI())
    }

    override func tearDownWithError() throws {
    }

    func testDecodeLogic(){
        guard let filePath = Bundle.main.path(forResource: "sample", ofType: "json") else {
            // Handle file not found error
            print("Error: sample.json not found")
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            viewModel.decodeThedata(cocktailData: data)
            XCTAssert(viewModel.cocktailsList.count > 0, "Data decoding is sucessfull")
            XCTAssert(viewModel.cocktailsListCopy.count > 0)
            print("the pavann",viewModel.cocktailsList.count,viewModel.cocktailsListCopy.count)
        } catch {
            // Handle file reading or JSON parsing errors
            print("Error: Could not read or parse JSON file: \(error)")
        }

    }
    
    func testFilterTheAlcoholCocktails(){
        print(viewModel.cocktailsList.count,"the pavann")
    }
//    
//    func testFilterTheNonAlcoholCocktails(){
//        viewModel.filterCocktailsAccording(type: .nonalcoholic, cocktials: cocktailList)
//        XCTAssert((viewModel.cocktailsList.first?.type ?? "") == "non-alcoholic")
//    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
