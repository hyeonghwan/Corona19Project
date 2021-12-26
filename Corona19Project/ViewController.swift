//
//  ViewController.swift
//  Corona19Project
//
//  Created by 박형환 on 2021/11/27.
//

import UIKit
import Charts
import Alamofire
enum ChangeGraph {
    case new
    case next
}
class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var piChartView: PieChartView!
   
    var covidResultValue: CityCoronaOverView?
    var graph: ChangeGraph = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.piChartView.delegate = self
        self.configureNodataPieChartView()
        self.fetchCovidOverView(completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result{
            case let .success(result):
                self.covidResultValue = result
                self.configureStackView(result.korea)
                let covidList = self.makeCovidOverViewList(coronaCityOverView: result)
                self.configureChartView(covidList)
                print("dfasdfasdf")
            case let .failure(result):
                debugPrint("Faulure \(result)")
            }
        })
        
    }
    @IBAction func chageGraphButton(_ sender: UIButton) {
        switch self.graph{
        case .new:
            self.piChartView.data = .none
            self.graph = .next
        case .next:
           guard let covidResult = self.covidResultValue else {return}
            let covidList = self.makeCovidOverViewList(coronaCityOverView: covidResult)
            self.configureChartView(covidList)
            self.graph = .new
        }
    }
  
    func makeCovidOverViewList(
        coronaCityOverView: CityCoronaOverView
    ) -> [CovidOverView] {
        return [
            coronaCityOverView.seoul,
            coronaCityOverView.busan,
            coronaCityOverView.chungbuk,
            coronaCityOverView.chungnam,
            coronaCityOverView.daegu,
            coronaCityOverView.daejeon,
            coronaCityOverView.gangwon,
            coronaCityOverView.gwangju,
            coronaCityOverView.gyeongbuk,
            coronaCityOverView.gyeonggi,
            coronaCityOverView.gyeongnam,
            coronaCityOverView.jeju,
            coronaCityOverView.jeonbuk,
            coronaCityOverView.jeonnam,
            coronaCityOverView.sejong,
            coronaCityOverView.ulsan
        ]
    }
    func configureNodataPieChartView(){
        self.piChartView.noDataText = "현재 데이터를 불러오는 중입니다."
        self.piChartView.noDataFont = .boldSystemFont(ofSize: 20)
        self.piChartView.noDataTextColor = .lightGray
    }
    func configureChartView(_ covidList: [CovidOverView]){
        let entries = covidList.compactMap{ [weak self] overView -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(overView.newCase),
                label: overView.countryName,
                data: overView
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생현황")
        dataSet.sliceSpace = 1.5
        dataSet.valueTextColor = .black
        dataSet.entryLabelColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.liberty() +
        ChartColorTemplates.pastel() +
        ChartColorTemplates.material()
        self.piChartView.data = PieChartData(dataSet: dataSet)
      
        if self.graph == .new{
            self.piChartView.spin(duration: 0.3, fromAngle: self.piChartView.rotationAngle, toAngle: self.piChartView.rotationAngle + 80)
        }
    }
    func removeFormatString(_ str: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: str)?.doubleValue ?? 0
    }
    
    
    func configureStackView(_ covidOverView: CovidOverView) {
        self.totalCaseLabel.text = "\(covidOverView.totalCase) 명"
        self.newCaseLabel.text = "\(covidOverView.newCase) 명"
    }

    func fetchCovidOverView(
        completionHandler: @escaping (Result<CityCoronaOverView,Error>)->Void
    ){
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "NYeRI9iPoDCHnt1bf2xOUvJl8VKG6ydBu"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData( completionHandler: { response in
                switch response.result{
                case let .success(data):
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCoronaOverView.self, from: data)
                        completionHandler(.success(result))
                    }catch{
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
}

extension ViewController: ChartViewDelegate{
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        
        guard let covidData = entry.data  as? CovidOverView else {return}
        guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? CoronaTableViewController else {return}
        secondViewController.covidData = covidData
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }
}


