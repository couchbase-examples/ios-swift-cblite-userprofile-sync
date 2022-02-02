//  UserProfileQueryDemo
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import Foundation
import UIKit

class UniversityViewController :
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    PresentingViewProtocol {
    
    //dealing with database and mapping
    var currUniversitySelection:String?
    lazy var universityPresenter:UniversityPresenter = UniversityPresenter()
    fileprivate var selectedUniversity:UniversityRecord?
    fileprivate var universities:Universities?
    fileprivate var indexOfSelectedUniverity:IndexPath?
    
    var onDoneBlock : ((String?) -> Void)?
    
    //UI components
    @IBOutlet weak var sbUniversityName: UISearchBar!
    @IBOutlet weak var sbUniversityCountry: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLookupTapped(_ sender: Any) {
        guard let nameStr = sbUniversityName.text else {
            return
        }
        
        let locationStr = self.sbUniversityCountry.text == "" ? nil : self.sbUniversityCountry.text
        self.universityPresenter.fetchUniversitiesMatchingName(nameStr, country: locationStr) { [weak self](universities, error) in
            
            guard let `self` = self else {
                return
            }
            switch error {
            case nil:
                self.universities = universities
                self.tableView.reloadData()
            default:
                self.showAlertWithTitle(NSLocalizedString("Failed to University Info!", comment: ""), message: error?.localizedDescription ?? "")
                print("Error when fetching universities \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        onDoneBlock?(self.currUniversitySelection)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        onDoneBlock?(self.selectedUniversity?.name)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.universityPresenter.attachPresentingView(self)
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //used for UITests
        self.sbUniversityName.accessibilityIdentifier = "sbUniversityName"
        
        //used for UITests
        self.sbUniversityCountry.accessibilityIdentifier = "sbUniversityCountry"
       
        //used for UITests
        self.tableView.accessibilityIdentifier = "tableView"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.universityPresenter.detachPresentingView(self)
        super.viewDidDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK : UniversityPresentingViewProtocol
extension UniversityViewController : UniversityPresentingViewProtocol {
    
    func updateUIWithUniversityRecords(_ records: Universities?, error: Error?) {
        switch error {
        case nil:
            self.universities = records
            self.tableView.reloadData()
        default:
            self.universities = records
            self.tableView.reloadData()
            self.showAlertWithTitle(NSLocalizedString("", comment: ""), message: (error?.localizedDescription) ?? "Failed to fetch university record")
        }
    }
}

extension UniversityViewController {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.universities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell:UniversityCell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath) as? UniversityCell else {
            return UITableViewCell()
        }
        guard let universities = self.universities else {
            return  UITableViewCell()
        }
        if (universities.count > indexPath.row) {
            let university = universities[indexPath.row]
            cell.nameValue = university.name ?? NSLocalizedString("Unavailable", comment:"")
            cell.locationValue = university.country ?? NSLocalizedString("Unavailable", comment:"")
            cell.urlValue = university.webPages?[0] ?? NSLocalizedString("Unavailable", comment:"")
            cell.selectionStyle = .blue
        }
        return cell
    }
}

extension UniversityViewController {
   
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex  = indexOfSelectedUniverity {
            tableView.deselectRow(at: selectedIndex, animated: true)
            indexOfSelectedUniverity = nil
            self.selectedUniversity = nil

        }
        else {
            indexOfSelectedUniverity = indexPath
            self.selectedUniversity = universities?[indexPath.row]
        }
    }
}
