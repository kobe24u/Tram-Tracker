//
//  Copyright © 2017 REA. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

enum JSONError: Error {
  case serialization
}

class HomeViewController: UITableViewController {

    
    let viewModel = HomeViewModel(tokenManager: TokenManager(), tramManager: TramManager())
    
    private var timer = Timer()
    
    @IBOutlet var tramTimesTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
            self?.tramTimesTable.reloadSections(.init(integer: direction == .north ? TableViewSection.north.rawValue : TableViewSection.south.rawValue),
                                               with: .automatic)
        }
        
        viewModel.noUpComingTramClosure = { [weak self] in
            self?.clearTramData()
            self?.showAlert(alertText: Constants.Title.tramStopFetchingError, alertMessage: Constants.Title.noUpcomingError)
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        clearTramData()
        loadTramData()
    }
    
    //Loading spinner to give user a prompt
    func setupView(){
        //Registed tableview cells, disabeld selection ability
        tramTimesTable.register(forClass: TramDetailsTableViewCell.self)
        tramTimesTable.register(forClass: TramMissingTableViewCell.self)
        tramTimesTable.allowsSelection = false
        
        //Allow user to drag the tableview to refresh data
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action:#selector(refresh(sender:)) , for: UIControl.Event.valueChanged)
        
        //Use dynamic title value instead of using the hardcoded navigation item title in Storyboard
        title = viewModel.title
        
        //Some Nav bar beautify settings
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.reaRed
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        timer = Timer.scheduledTimer(timeInterval: Constants.Interval.etaRefreshInterval,
                             target: self, selector: #selector(updateETA), userInfo: nil, repeats: true)
    }


    @objc func updateETA(){
        guard let visibleIndexPaths = tramTimesTable.indexPathsForVisibleRows else {return}
        tramTimesTable.beginUpdates()
        tramTimesTable.reloadRows(at:visibleIndexPaths , with: .none)
        tramTimesTable.endUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Avoid retain cycle
        timer.invalidate()
    }
}

extension HomeViewController {

    func clearTramData() {
        //ViewModel clear local data first and then refresh tableview
        viewModel.clearData()
        tramTimesTable.reloadData()
    }

    func loadTramData() {
        //Check if we have stored a token before, if yes, we use it, if not, we call API to get one and store it locally
        if let _ = UserDefaults.standard.tokenKey{
            //We got a token stored locally, ready to fetch tramstops
            Direction.allCases.forEach{ fetchTramStopsByDirection(direction: $0) }
        }else{
            fetchToken()
        }
    }

    func fetchToken(){
        viewModel.fetchToken { [weak self] (result) in
            switch result {
                case .failure(let error):
                    self?.showAlert(alertText: Constants.Title.tokenFetchingError, alertMessage: error.localizedDescription)
                case .success():
                    //We just fetched a new token, ready to fetch tramstops
                    Direction.allCases.forEach{ self?.fetchTramStopsByDirection(direction: $0) }
            }
        }
    }
    
    func fetchTramStopsByDirection(direction: Direction){
        self.viewModel.fetchTramStopsByDirection(direction: direction) { [weak self] (result) in
            self?.refreshControl?.endRefreshing()
            switch result {
                case .failure(let error):
                    self?.showAlert(alertText: Constants.Title.tramStopFetchingError, alertMessage: error.localizedDescription)
                case .success():
                    break
            }
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableViewSection(rawValue: indexPath.section) else { return UITableViewCell() }

        guard let tram = viewModel.tramFor(section: section, row: indexPath.row) else {
            //If no valid tram found, use TramMissingTableViewCell to present a meaningful message to user
            let cell: TramMissingTableViewCell = tableView.dequeueReusableCell(forClass: TramMissingTableViewCell.self)
            
            if viewModel.isLoading(section: section) {
                cell.configCell(msg: Constants.Message.tramLoadingSpinnerTitle)
            } else {
                cell.configCell(msg: Constants.Message.tramMissingTitle)
            }
            return cell
        }
        
        let cell: TramDetailsTableViewCell = tableView.dequeueReusableCell(forClass: TramDetailsTableViewCell.self)
        cell.configCell(tram: tram)
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = TableViewSection(rawValue: section) else { return 0 }
        return viewModel.numberOfRowsIn(section: section)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = TableViewSection(rawValue: section) else { return "Section" }
        return viewModel.titleForSection(section)
    }
}
