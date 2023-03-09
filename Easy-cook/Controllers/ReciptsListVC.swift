import UIKit

class ReciptsListVC: BaseVC{
    var manager = RequestListRecipesManager()
    var loadNum = 20
    var offset = 0
    var isEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        manager.delegate = self
        // updating data for table view
        manager.fetchRecipe(query: .list(number: loadNum, offset: offset))
        configureTableView()
        // Register the custom header view.
        tableView.register(TableViewTopCustomHeader.self, forHeaderFooterViewReuseIdentifier: K.sectiontHeaderIndent)
    }
    
    //Updating amount of shoings cells it TableView
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == reciepts.count - 3 {
           
            if isEnabled{
                isEnabled = false
                offset += loadNum
                DispatchQueue.main.async {
                    print("   rffrfrf   \(self.offset)")
                    self.manager.fetchRecipe(query: .list(number: self.loadNum, offset: self.offset))
                    tableView.reloadData()
                }
                
            }
        }
    }
}

// MARK: - Extension (RequestListRecipeDelegate)
extension ReciptsListVC: RequestListRecipeDelegate{
  
    
    func didUpdateRecipeList(_ requestListRecipeManager: RequestListRecipesManager, recipeList: RecipeListModel) {
        
        DispatchQueue.main.async {
            
            recipeList.results.forEach({
                self.reciepts.append($0)
            })
            self.tableView.reloadData()
        }
        
        isEnabled = true
        print( self.reciepts.count)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
