//
//  CoronaTableViewController.swift
//  CoronaTableViewController
//
//  Created by 박형환 on 2021/11/27.
//

import UIKit

class CoronaTableViewController: UITableViewController {

    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutBreakCell: UITableViewCell!
    
    var covidData: CovidOverView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("secondViewDidLoad")
        guard let data = covidData else {return}
        self.configurationCell(data)
    
    }
    func configurationCell(_ covidData: CovidOverView){
        self.title = "\(covidData.countryName) 코로나 발생 현황"
        
        var content1 = newCaseCell.defaultContentConfiguration()
        content1.text = "신규 확진자"
        content1.secondaryText = "\(covidData.newCase) 명"
        newCaseCell.contentConfiguration = content1
        
        var content2 = totalCaseCell.defaultContentConfiguration()
        content2.text = "확진자"
        content2.secondaryText = "\(covidData.totalCase) 명"
        totalCaseCell.contentConfiguration = content2
        
        var content3 = recoveredCell.defaultContentConfiguration()
        content3.text = "완치자"
        content3.secondaryText = "\(covidData.recovered) 명"
        recoveredCell.contentConfiguration = content3
        
        var content4 = deathCell.defaultContentConfiguration()
        content4.text = "사망자"
        content4.secondaryText = "\(covidData.death) 명"
        deathCell.contentConfiguration = content4
        
        var content5 = percentageCell.defaultContentConfiguration()
        content5.text = "발생률"
        content5.secondaryText = "\(covidData.percentage) %"
        percentageCell.contentConfiguration = content5
        
        var content6 = overseasInflowCell.defaultContentConfiguration()
        content6.text = "해외 유입 신규 확진자"
        content6.secondaryText = "\(covidData.newCcase) 명"
        overseasInflowCell.contentConfiguration = content6
        
        var content7 = regionalOutBreakCell.defaultContentConfiguration()
        content7.text = "지역 발생 신규 확진자"
        content7.secondaryText = "\(covidData.newFcase) 명"
        regionalOutBreakCell.contentConfiguration = content7

        
        
    }

}
