import UIKit
import Combine

enum CocktailTypes{
    case all
    case alcoholic
    case nonalcoholic
}

class MainScreenViewController: UIViewController {
    
    @IBOutlet var cocktailSegmentController: UISegmentedControl!
    @IBOutlet weak var cocktailsTableView: UITableView!
    
    let viewModel = MainScreenViewModel(cocktailsAPI: FakeCocktailsAPI())
    private var cancellables: Set<AnyCancellable> = []

    fileprivate func getCocktails() {
        ProgressView.shared.showProgressView(self.view)
        viewModel.fetchCocktails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        getCocktails()
        subscribeToCocktails()
        subscribeToError()
        initializeNavigationBar()
        cocktailSegmentController.layer.cornerRadius = 15
        

    }
    
    func initializeNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func initializeTableView(){
        cocktailsTableView.dataSource = self
        cocktailsTableView.delegate = self
        cocktailsTableView.register(UINib(nibName: "CocktailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CocktailsTableViewCell")
    }
    
    func subscribeToCocktails(){
        viewModel.$cocktailsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                if completed.count > 0 {
                    ProgressView.shared.hideProgressView()
                    self?.cocktailsTableView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    func subscribeToError(){
        viewModel.$isErrorReceived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if error == true{
                    self?.showAlert(title: "Error", message: "Something went wrong please retry again",actionHandler: {
                        self?.viewModel.fetchCocktails()
                    })
                }
            }.store(in: &cancellables)
    }
    
    
    
    
}

extension MainScreenViewController : UpdateCocktailsDelegate{
    func refreshCocktail() {
        viewModel.addFavouriteCocktails(cocktials: viewModel.cocktailsList)
    }
}

extension MainScreenViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailsTableViewCell", for: indexPath) as! CocktailsTableViewCell
        let cocktailAtIndex = viewModel.cocktailsList[indexPath.row]
        cell.cocktailTitle.text = cocktailAtIndex.name ?? ""
        cell.cocktailDescrption.text = cocktailAtIndex.shortDescription ?? ""
        cell.favouriteBtn.isHidden = !cocktailAtIndex.favourite
        cell.cocktailTitle.textColor = cocktailAtIndex.favourite ? UIColor.systemBlue : UIColor.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cocktailsList.count
    }
}

extension MainScreenViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cocktailsDetailsVC = UIStoryboard(name: "CocktailsBook", bundle: nil).instantiateViewController(withIdentifier: "CocktailsDetailsViewController") as! CocktailsDetailsViewController
        cocktailsDetailsVC.cocktailDetails = viewModel.cocktailsList[indexPath.row]
        cocktailsDetailsVC.delegate = self
        self.navigationController?.pushViewController(cocktailsDetailsVC, animated: true)
        
    }
}

extension MainScreenViewController {
    
    @IBAction func segmentControllerAction(_ sender: UISegmentedControl) {
        viewModel.switchSelection(segmentSelected: sender.selectedSegmentIndex)
    }
}

extension UIViewController{
    func showAlert(title: String?, message messageToShow: String?, buttonTitle: String = "Retry",actionHandler :@escaping ()->Void){
            let alert = UIAlertController(
                title: title ?? "",
                message: messageToShow ?? "",
                preferredStyle: .alert
            )
            
        let defaultAction = UIAlertAction(
                title: buttonTitle,
                style: .cancel) { _ in
                    actionHandler()
            }
            
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
    }
}
