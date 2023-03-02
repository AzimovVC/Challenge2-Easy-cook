import UIKit

class ReciptsListVC: UIViewController, RequestListRecipeDelegate {
    func didUpdateRecipeList(_ requestListRecipeManager: RequestListRecipesManager, recipeList: RecipeListModel) {
    
        DispatchQueue.main.async {
            self.reciepts = recipeList.results
            self.tableView.reloadData()
        }
        
        print(recipeList)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    var manager = RequestListRecipesManager()
    var tableView = UITableView()
    var reciepts: [ResultModel] = []
    
    struct Cells {
        static let recieptCell = "TableViewPrototypeCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        manager.delegate = self
        // updating data for table view
        manager.fetchRecipe(number: 10, offset: 0)
    //    reciepts = fetchData()
        configureTableView()
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        //set delegates
        setTableViewDelegates()
        //set row heigt
        tableView.rowHeight = 240
        //register cells
        tableView.register(TableViewPrototypeCell.self, forCellReuseIdentifier: Cells.recieptCell)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


// MARK: - Extension (Delegate and DataSource)
extension ReciptsListVC: UITableViewDelegate, UITableViewDataSource {
    
    // Here we setup how many rows do we wants to set up in table view ( Its should be equal to API Request of reciepts.count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reciepts.count
    }
    
    // Shows which kind of default cell prototype do we set up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.recieptCell) as! TableViewPrototypeCell
        let recieptsList = reciepts[indexPath.row]
        cell.set(recieptList: recieptsList)
        return cell
    }
    // this method will run when the user click at row (so we will open segue)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        present(RecipeViewController(reciepts[indexPath.row].id), animated: true, completion: nil)
      //  print(reciepts[indexPath.row].id)
    }
}