//
//  MainViewController
//  Nomad Education
//
//  Created by Laurent Favard on 05/03/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import UIKit
import RxSwift

class TableViewController: AncestorViewController, UITableViewDelegate, UITableViewDataSource {

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - UI elements
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - Private var members
    private let viewModel = TableViewModel()
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - ViewControllers functions
    override func viewDidLoad() {

        super.viewDidLoad()

        //  Initialize the expected delegate for the tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self

        //  Register the custom tableViewCell (XIB kind)
        CustomTableViewCell.register(to: self.tableView)
        
        // Add the refresh control, Rx Observers
        self.addRefreshControl(forScrollView: mainScrollView)
        self.addRxObservers()
        
        //  Request the events data: REFRESH now
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Start the data downloading
     */
    private func refresh() {
        
        self.refreshControl.beginRefreshing()
        self.viewModel.load(completionHandler: {
            
            success in
            
            //  Stop refreshing indicator
            self.refreshControl.endRefreshing()
            
            if !success {
                //  Alert the user we are encountering an issue
                let alert  = UIAlertController(title: "MainViewController.NetworkIssue".asLocalizable, message: "MainViewController.NetworkIssue.Message".asLocalizable, preferredStyle: .alert)
                
                alert.addAction( UIAlertAction(title: "OK".asLocalizable, style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    /**
     Dipslaying the event here, it's just reload the tableview
     */
    private func displayElements() {
        
        self.tableView.reloadData()
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    //  MARK: - RxObservers
    private func addRxObservers() {
        
        self.viewModel.items.asObservable().subscribe(onNext: {

            items in

            //  Display whatever data are here or not
            self.displayElements()

        } ).disposed(by: self.disposeBag)
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    //  MARK: - Public functions
    override func pullRefreshControl(_ sender: AnyObject?) {

        self.refresh()
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// TableView delegate implementation
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    // MARK: - TableView delegate implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.numberOfSections
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    //  Return each title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel.titleForHeaderInSection(inSection:section)
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfRowsInSection(inSection: section)
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier(), for: indexPath)
        if let cell = cell as? CustomTableViewCell {
            
            cell.customText = self.viewModel.objectTexteExampme(atIndex: indexPath)
            
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 58;
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let event = self.viewModel.event(at: indexPath ) {
//            
//            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: EventViewController.self)) as? DetailsViewController {
//
//                viewController.viewModel = DetailsViewModel( fromEvent: event )
//
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
//        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.none
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let calendarAction = UITableViewRowAction(style: .normal, title: "MainViewController.Calendar".asLocalizable, handler: {
                
            action, indexPath in
            
        })
        
        calendarAction.backgroundColor = UIColor.blue
        
        return [calendarAction]
    }

    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let shareAction = UIContextualAction(style: .normal, title:  "MainViewController.Share".asLocalizable, handler: {

            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            success(true)
        })

        shareAction.image = UIImage(named: "share")
        shareAction.backgroundColor = .purple

        return UISwipeActionsConfiguration(actions: [shareAction])

    }

}

/*

 Bonjour Laurent,
 
 Ravi d’avoir pu échanger avec vous. Comme convenu, voici le test technique :
 
 Etat d’esprit
 ==============
 
 Réaliser un exercice « simple » mais mettre en place toutes les bonnes pratiques comme s’il s’agissait d’un vrai projet. Nous serons particulièrement attentif à l’architecture du code
 
 Contenu
 ==============
 
 Voici l'URL d'un JSON représentant des events d'école : http://res.cloudinary.com/nomadeducation/raw/upload/v1510821111/events_uqwefr.json
 
 Un 'event' est constitué d'un titre ('title'), d'une date de début ('dateStart'), d'une date de fin ('dateEnd'), d'une image (optionelle: premier Media dans 'medias'), d'un extrait (optionnelle, 'excerp'), d'un contenu ('content') et d'une adresse ('address').
 
 Nous vous demandons de réaliser l'écran permettant d'afficher la liste des évènements en les regroupant par section. Une section représentant un mois et doit être ordonnée par date. La cellule devra afficher les informations (si elles existent) comme dans la pièce jointe ('eventCell.png'). En effet des informations peuvent être manquantes, ainsi vous êtes libre d'adapter la cellule pour gérer les différents cas. Nous demandons également de réaliser le détail de l'event ('eventDetail.png').
 
 Ce que l'on veut à travers cet exercice c'est voir la façon dont vous concevez votre projet et les écrans. Vous êtes totalement libre sur le choix de librairies tierces ainsi que sur la façon dont vous gérez les vues.
*/
