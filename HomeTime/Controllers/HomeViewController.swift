//
//  Copyright © 2017 REA. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

enum JSONError: Error {
  case serialization
}

class HomeViewController: UITableViewController {

    
    private let viewModel = HomeViewModel(tokenManager: TokenManager(), tramManager: TramManager())
    
    @IBOutlet var tramTimesTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        clearTramData()
        loadTramData()
    }

    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
    }

    @IBAction func loadButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
        loadTramData()
    }
    
    func setupViewModel(){
        viewModel.reloadDirectionClosure = { [weak self] direction in
            self?.tramTimesTable.reloadSections(.init(integer: direction == .north ? TableViewSections.north.rawValue : TableViewSections.south.rawValue),
                                               with: .automatic)
        }
        
        viewModel.noUpComingTramClosure = {
            //TODO: present an alert to tell user there is no tram coming
        }
    }
}

// MARK: - Tram Data

extension HomeViewController {

    func clearTramData() {
        //ViewModel clear local data first and then refresh tableview
        viewModel.clearData()
        tramTimesTable.reloadData()
    }

    func loadTramData() {
        //Check if we have stored a token before, if yes, we use it, if not, we call API to get one and store it locally
        if let storedToken = UserDefaults.standard.tokenKey{
            print("We got a token stored locally, ready to fetch tramstops")
        }else{
            viewModel.fetchToken { (result) in
                switch result {
                    case .failure(let error):
                        //TODO: Handle error, show alert
                        print(error.localizedDescription)
                    case .success():
                        print("We just fetched a new token, ready to fetch tramstops")
                        //TODO: Load tramstops using the latestest token
                }
            }
        }
    }

    func fetchTramStopsByDirection(direction: Direction){
        
    }
    
    func tramsFor(section: Int) -> [Tram]? {
        return (section == TableViewSections.north.rawValue) ? viewModel.northTrams : viewModel.southTrams
    }
    
    func isLoading(section: Int) -> Bool {
        return (section == TableViewSections.north.rawValue) ? viewModel.loadingNorth : viewModel.loadingSouth
    }
}


// MARK - UITableViewDataSource

extension HomeViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TramCellIdentifier", for: indexPath)

    let trams = tramsFor(section: indexPath.section)
    guard let tram = trams?[indexPath.row] as? JSONDictionary else {
      if isLoading(section: indexPath.section) {
        cell.textLabel?.text = "Loading upcoming trams..."
      } else {
        cell.textLabel?.text = "No upcoming trams. Tap load to fetch"
      }
      return cell
    }

    guard let arrivalDateString = tram["PredictedArrivalDateTime"] as? String else {
      return cell
    }
    let dateConverter = DotNetDateConverter()
    cell.textLabel?.text = dateConverter.formattedDateFromString(arrivalDateString)

    return cell;
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0)
    {
        guard let count = viewModel.northTrams?.count else { return 1 }
      return count
    }
    else
    {
        guard let count = viewModel.southTrams?.count else { return 1 }
      return count
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "North" : "South"
  }
}
