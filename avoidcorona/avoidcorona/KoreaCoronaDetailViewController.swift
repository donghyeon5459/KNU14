//
//  FirstViewController.swift
//  AvoidCoronaApp
//
//  Created by Azderica on 2020/06/02.
//  Copyright © 2020 Azderica. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var KoreaCOVIDTableView: UITableView!
    
    var jsondata1: [String: Any]!
    var jsondata2: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Label layout 설정
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                //테이블 뷰 delegate 설정
                self.KoreaCOVIDTableView.dataSource = self
                self.KoreaCOVIDTableView.delegate = self
            }
            //COVID 데이터 JSON 파싱
            self.getData1 {
                DispatchQueue.main.async {
                    let updateTime = (self.jsondata1["updateTime"] as! String).components(separatedBy: "(")
                    self.titleLabel.text = "COVID-19 국내 지역별 상세 현황"
                    self.dateLabel.text = updateTime[1].components(separatedBy: ")")[0]
                    self.KoreaCOVIDTableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.getData2 {
                    self.KoreaCOVIDTableView.reloadData()
                }
            }
        }
    }
    
    func getData1(success: @escaping ()->()) {
        do {
            let url = URL(string: "http://api.corona-19.kr/korea")
            if let data = try String(contentsOf: url!).data(using: .utf8) {
                jsondata1 = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(jsondata1)
                success()
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func getData2(success: @escaping ()->()) {
        do {
            let url = URL(string: "http://api.corona-19.kr/korea/country/new")
            if let data = try String(contentsOf: url!).data(using: .utf8) {
                jsondata2 = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(jsondata2)
                success()
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = KoreaCOVIDTableView.dequeueReusableCell(withIdentifier: "COVIDDetailCell", for: indexPath) as! COVIDDetailCell
        switch indexPath.row {
        case 0:
            cell.cityLabel.text = "전국"
            if let totalCase = (jsondata1["TotalCase"] as? String), let todayRecovered = (jsondata1["TodayRecovered"] as? String), let todayDeath = (jsondata1["TodayDeath"] as? String), let totalCaseBefore = (jsondata1["TotalCaseBefore"] as? String), let nowCase = (jsondata1["NowCase"] as? String), let totalDeath = (jsondata1["TotalDeath"] as? String), let totalRecovered = (jsondata1["TotalRecovered"] as? String) {
                if let todayRecovered_int = Int(todayRecovered), let todayDeath_int = Int(todayDeath), let totalCaseBefore_int = Int(totalCaseBefore) {
                    let todayCase = todayDeath_int + todayRecovered_int + totalCaseBefore_int
                    cell.caseLabel.text = "\(totalCase)\n(+\(todayCase))"
                    if totalCaseBefore_int >= 0 {
                        cell.nowcaseLabel.text = "\(nowCase)\n(+\(totalCaseBefore))"
                    }
                    else {
                        cell.nowcaseLabel.text = "\(nowCase)\n(-\(totalCaseBefore))"
                    }
                    cell.deathLabel.text = "\(totalDeath)\n(+\(todayDeath))"
                    cell.recoveredLabel.text = "\(totalRecovered)\n(+\(todayRecovered))"
                }
            }
        case 1:
            updateLabel(city_kor: "서울", city_eng: "seoul", cell: cell)
        case 2:
            updateLabel(city_kor: "부산", city_eng: "busan", cell: cell)
        case 3:
            updateLabel(city_kor: "대구", city_eng: "daegu", cell: cell)
        case 4:
            updateLabel(city_kor: "인천", city_eng: "incheon", cell: cell)
        case 5:
            updateLabel(city_kor: "광주", city_eng: "gwangju", cell: cell)
        case 6:
            updateLabel(city_kor: "대전", city_eng: "daejeon", cell: cell)
        case 7:
            updateLabel(city_kor: "울산", city_eng: "ulsan", cell: cell)
        case 8:
            updateLabel(city_kor: "세종", city_eng: "sejong", cell: cell)
        case 9:
            updateLabel(city_kor: "경기", city_eng: "gyeonggi", cell: cell)
        case 10:
            updateLabel(city_kor: "강원", city_eng: "gangwon", cell: cell)
        case 11:
            updateLabel(city_kor: "충북", city_eng: "chungbuk", cell: cell)
        case 12:
            updateLabel(city_kor: "충남", city_eng: "chungnam", cell: cell)
        case 13:
            updateLabel(city_kor: "전북", city_eng: "jeonbuk", cell: cell)
        case 14:
            updateLabel(city_kor: "전남", city_eng: "jeonnam", cell: cell)
        case 15:
            updateLabel(city_kor: "경북", city_eng: "gyeongbuk", cell: cell)
        case 16:
            updateLabel(city_kor: "경남", city_eng: "gyeongnam", cell: cell)
        case 17:
            updateLabel(city_kor: "제주", city_eng: "jeju", cell: cell)
        case 18:
            updateLabel(city_kor: "검역", city_eng: "quarantine", cell: cell)
        default:
            break
        }
        return cell
    }
    
    func updateLabel(city_kor: String, city_eng: String, cell: COVIDDetailCell) {
        cell.cityLabel.text = city_kor
        let data = jsondata2[city_eng] as! [String: Any]
        if let totalCase = (data["totalCase"] as? String), let totalDeath = (data["death"] as? String), let totalRecovered = (data["recovered"] as? String), let newCase = (data["newCase"] as? String) {
            let totalCase_str = totalCase.components(separatedBy: ",")
            var totalCase_nocomma = totalCase_str[0]
            for count in 1..<totalCase_str.count {
                totalCase_nocomma += totalCase_str[count]
            }
            let totalDeath_str = totalDeath.components(separatedBy: ",")
            var totalDeath_nocomma = totalDeath_str[0]
            for count in 1..<totalDeath_str.count {
                totalDeath_nocomma += totalDeath_str[count]
            }
            let totalRecovered_str = totalRecovered.components(separatedBy: ",")
            var totalRecovered_nocomma = totalRecovered_str[0]
            for count in 1..<totalRecovered_str.count {
                totalRecovered_nocomma += totalRecovered_str[count]
            }
            if let totalCase_int = Int(totalCase_nocomma), let totalDeath_int = Int(totalDeath_nocomma), let totalRecovered_int = Int(totalRecovered_nocomma) {
                let nowCase = totalCase_int - totalDeath_int - totalRecovered_int
                cell.caseLabel.text = "\(totalCase)\n(+\(newCase))"
                cell.nowcaseLabel.text = String(nowCase)
                cell.deathLabel.text = totalDeath
                cell.recoveredLabel.text = totalRecovered
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
