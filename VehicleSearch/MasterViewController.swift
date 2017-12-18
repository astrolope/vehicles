
import UIKit
import Firebase


class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchFooter: SearchFooter!
  
  var detailViewController: DetailViewController? = nil
    
  var vehicles = [Vehicle]()
  var filteredVehicles = [Vehicle]()
    
  let searchController = UISearchController(searchResultsController: nil)
    
  var ref: DatabaseReference!

  var vehicleRef: DatabaseReference!
  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    
    vehicleRef = ref.child("vehicles")
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Vehicles"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    // Setup the Scope Bar
    searchController.searchBar.scopeButtonTitles = ["All", "Red", "White", "Gray", "Silver", "Black"]
    searchController.searchBar.delegate = self
    
    // Setup the search footer
    tableView.tableFooterView = searchFooter
    
    //build out vehicle class and reload data
    
    vehicleRef.observe(.childAdded, with: { (snapshot) -> Void in
        
        let value = snapshot.value as? NSDictionary
        
        let make = value?["make"] as? String ?? ""
        let year = value?["year"] as? Int ?? 0
        let color = value?["color"] as? String ?? ""
        let price = value?["price"] as? Int ?? 0
        let hasSunroof = value?["hasSunroof"] as? Bool ?? false
        let isAutomatic = value?["isAutomatic"] as? Bool ?? false
        let isFourWheelDrive = value?["isFourWheelDrive"] as? Bool ?? false
        let hasLowMiles = value?["hasLowMiles"] as? Bool ?? false
        let hasPowerWindows = value?["hasPowerWindows"] as? Bool ?? false
        let hasNavigation = value?["hasNavigation"] as? Bool ?? false
        let hasHeatedSeats = value?["hasHeatedSeats"] as? Bool ?? false
        
        let vehicle = Vehicle(
            color:color,
            make:make,
            year: year,
            price: price,
            isAutomatic: isAutomatic,
            hasSunroof: hasSunroof,
            isFourWheelDrive: isFourWheelDrive,
            hasLowMiles: hasLowMiles,
            hasPowerWindows: hasPowerWindows,
            hasNavigation: hasNavigation,
            hasHeatedSeats: hasHeatedSeats
        )
        
        self.vehicles.append(vehicle)
        self.filteredVehicles.append(vehicle)
        
        self.tableView.reloadData()
    })
    
    
    if let splitViewController = splitViewController {
      let controllers = splitViewController.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if splitViewController!.isCollapsed {
      if let selectionIndexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: selectionIndexPath, animated: animated)
      }
    }
    
    //TODO: load search
    super.viewWillAppear(animated)
    
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table View
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      searchFooter.setIsFilteringToShow(filteredItemCount: filteredVehicles.count, of: vehicles.count)
      return filteredVehicles.count
    }
    
    searchFooter.setNotFiltering()
    return vehicles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VehicleCell
    let vehicle: Vehicle
    if isFiltering() {
      vehicle = filteredVehicles[indexPath.row]
    } else {
      vehicle = vehicles[indexPath.row]
    }
    
    var options = [String]()
    
    //TODO: add options as array
    
    cell.make.text = vehicle.make
    cell.year.text = String(vehicle.year)
    
    let instance = SearchState.sharedInstance
    
    if(instance.isAutomatic == true) {
        options.append("Automatic");
    }
    
    if(instance.hasSunroof == true) {
        options.append("Sun Roof");
    }
    
    if(instance.isFourWheelDrive == true) {
        options.append("4-Wheel Drive");
    }
    
    if(instance.hasLowMiles == true) {
        options.append("Low Miles");
    }
    
    if(instance.hasPowerWindows == true) {
        options.append("Power Windows");
    }
    
    if(instance.hasNavigation == true) {
        options.append("Navigation");
    }
    
    if(instance.hasHeatedSeats == true) {
        options.append("Heated Seats");
    }
    
    cell.options.text = options.joined(separator: ", ");
    
    //cell.textLabel!.text = vehicle.make
    //cell.detailTextLabel!.text = vehicle.color
    
    
    let formatter = NumberFormatter()
    formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
    formatter.numberStyle = .currency
    if let price = formatter.string(from: vehicle.price as NSNumber) {
        cell.price.text = price
    }
    
    
    
    return cell
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let vehicle: Vehicle
        if isFiltering() {
          vehicle = filteredVehicles[indexPath.row]
        } else {
          vehicle = vehicles[indexPath.row]
        }
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.vehicleDetail = vehicle
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
  // MARK: - Private instance methods
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {

    filteredVehicles = vehicles.filter({( vehicle : Vehicle) -> Bool in
      let doesCategoryMatch = (scope == "All") || (vehicle.color == scope)
      
      if searchBarIsEmpty() {
        return doesCategoryMatch
      } else {
        return doesCategoryMatch && vehicle.make.lowercased().contains(searchText.lowercased())
      }
    })
    
    filterWithOptions()
    
    //TODO: check if options are open and filter options
    tableView.reloadData()
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func isFiltering() -> Bool {
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    
    // TODO: Always filtering true
    //return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    
    return true
  }
    
    
    func filterWithOptions() {
        
        let instance = SearchState.sharedInstance
        //TODO: check if filter is active
        //TODO: pass filtered vehicles through chain of  individual filters
        
        if(instance.isAutomatic == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.isAutomatic == vehicle.isAutomatic)
                
                return sort
                
            })
        }
        
        if(instance.hasSunroof == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.hasSunroof == vehicle.hasSunroof)
                
                return sort
                
            })
        }
        
        if(instance.isFourWheelDrive == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.isFourWheelDrive == vehicle.isFourWheelDrive)
                
                return sort
                
            })
        }
        
        if(instance.hasLowMiles == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.hasLowMiles == vehicle.hasLowMiles)
                
                return sort
                
            })
        }
        
        if(instance.hasPowerWindows == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.hasPowerWindows == vehicle.hasPowerWindows)
                
                return sort
                
            })
        }
        
        if(instance.hasNavigation == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.hasNavigation == vehicle.hasNavigation)
                
                return sort
                
            })
        }
        
        if(instance.hasHeatedSeats == true) {
            filteredVehicles = filteredVehicles.filter({( vehicle : Vehicle) -> Bool in
                let sort = (instance.hasHeatedSeats == vehicle.hasHeatedSeats)
                
                return sort
                
            })
        }
        
        tableView.reloadData()

    }
}


func hasOptions() -> Bool {
    
    let instance = SearchState.sharedInstance
    
    if (instance.isAutomatic == true || instance.hasSunroof == true || instance.isFourWheelDrive == true || instance.hasLowMiles == true || instance.hasPowerWindows == true || instance.hasNavigation == true || instance.hasHeatedSeats == true) {
        return true
    } else {
        return false
    }

}

extension MasterViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}

extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
}
