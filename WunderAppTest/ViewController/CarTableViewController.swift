//
//  ViewController.swift
//  WunderAppTest
//
//  Created by Mark Labios on 10/29/19.
//  Copyright © 2019 Mark Labios. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift
import RxDataSources

class CarTableViewController: UIViewController {
    
    let viewModel: CarTableViewViewModel = CarTableViewViewModel()

    @IBOutlet weak var carTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var selectCarPayload = ReadOnce<CarCellViewModel>(nil)
    
    var mapViewController: MapViewController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCellTapHandling()
        viewModel.getCars()
        
        mapViewController = tabBarController?.viewControllers![1] as? MapViewController
        
        for viewController in tabBarController?.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
        mapViewController?.pinCars(cars: viewModel.carsObservable)
    }
    
    func bindViewModel() {
         viewModel.carCells.bind(to: self.carTableView.rx.items) { carTableView, index, element in
                   let indexPath = IndexPath(item: index, section: 0)
                   switch element {
                   case .normal(let viewModel):
                       guard let cell = carTableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as? CarTableViewCell else {
                           return UITableViewCell()
                       }

                       cell.viewModel = viewModel
                       return cell
                   case .error(let message):
                       let cell = UITableViewCell()
                       cell.isUserInteractionEnabled = false
                       cell.textLabel?.text = message
                       return cell
                   case .empty:
                       let cell = UITableViewCell()
                       cell.isUserInteractionEnabled = false
                       cell.textLabel?.text = "No data available"
                       return cell
                   }
               }.disposed(by: disposeBag)
     
        
        viewModel
                   .onShowLoadingHud
                   .map { [weak self] in self?.setLoadingHud(visible: $0) }
                   .subscribe()
                   .disposed(by: disposeBag)
        
    
    }
    
    private func setLoadingHud(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
    
    private func setupCellTapHandling() {
           carTableView
               .rx
               .modelSelected(CarTableViewCellType.self)
               .subscribe(
                   onNext: { [weak self] carCellType in
                       if case let .normal(viewModel) = carCellType {
                           self?.selectCarPayload = ReadOnce(viewModel)
                           self?.onCellTap()
                          
                       }
                       if let selectedRowIndexPath = self?.carTableView.indexPathForSelectedRow {
                           self?.carTableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                       }
                   }
               )
               .disposed(by: disposeBag)
        
       }
    
    private func onCellTap() {
        let destination = tabBarController?.viewControllers![1] as! MapViewController
        let viewModel = selectCarPayload.read()
        destination.car = viewModel?.carItem
        destination.onCellTapped()
        tabBarController?.selectedIndex = 1
    }

}

extension CarTableViewController: SingleButtonDialogPresenter { }


