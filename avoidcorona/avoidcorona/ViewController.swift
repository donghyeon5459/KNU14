//
//  ViewController.swift
//  AvoidCoronaApp
//
//  Created by Azderica on 2020/06/02.
//  Copyright © 2020 Azderica. All rights reserved.
//

import UIKit

class RealtimeSituationBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var worldCOVIDTableView: UITableView!
    
    var jsondata1: [String: Any]!
    var jsondata2: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //테이블 뷰 delegate 설정
        worldCOVIDTableView.dataSource = self
        worldCOVIDTableView.delegate = self
        //Label layout 설정
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        //COVID 데이터 JSON 파싱
        getData1 {
            self.titleLabel.text = "COVID-19 실시간 상황판"
            self.worldCOVIDTableView.reloadData()
        }
        getData2 {
            self.worldCOVIDTableView.reloadData()
        }
    }
    
    func getData1(success: @escaping ()->()) {
        do {
            let url = URL(string: "http://api.corona-19.kr/korea")
            if let data = try String(contentsOf: url!).data(using: .utf8) {
                jsondata1 = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(jsondata1)
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
                print(jsondata2)
                success()
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("make Cell")
        let cell = worldCOVIDTableView.dequeueReusableCell(withIdentifier: "COVIDCell", for: indexPath) as! COVIDCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "누적 확진자 수"
            if let totalCase = (jsondata1["TotalCase"] as? String), let todayRecovered = (jsondata1["TodayRecovered"] as? String), let todayDeath = (jsondata1["TodayDeath"] as? String), let totalCaseBefore = (jsondata1["TotalCaseBefore"] as? String) {
                if let todayRecovered_int = Int(todayRecovered), let todayDeath_int = Int(todayDeath), let totalCaseBefore_int = Int(totalCaseBefore) {
                    let todayCase = todayDeath_int + todayRecovered_int + totalCaseBefore_int
                    cell.valueLabel.text = "\(totalCase) (+\(todayCase))"
                }
            }
        case 1:
            cell.titleLabel.text = "누적 완치자 수"
            if let totalRecovered = (jsondata1["TotalRecovered"] as? String), let todayRecovered = (jsondata1["TodayRecovered"] as? String) {
                cell.valueLabel.text = "\(totalRecovered) (+\(todayRecovered))"
            }
        case 2:
            cell.titleLabel.text = "누적 사망자 수"
            if let totalDeath = (jsondata1["TotalDeath"] as? String), let todayDeath = (jsondata1["TodayDeath"] as? String) {
                cell.valueLabel.text = "\(totalDeath) (+\(todayDeath))"
            }
        case 3:
            cell.titleLabel.text = "격리 환자 수"
            if let nowCase = (jsondata1["NowCase"] as? String), let totalCaseBefore = (jsondata1["TotalCaseBefore"] as? String) {
                if totalCaseBefore.contains("-") {
                    cell.valueLabel.text = "\(nowCase) (\(totalCaseBefore))"
                }
                else {
                    cell.valueLabel.text = "\(nowCase) (+\(totalCaseBefore))"
                }
            }
        case 4:
            updateLabel(city_kor: "서울", city_eng: "seoul", cell: cell)
        case 5:
            updateLabel(city_kor: "부산", city_eng: "busan", cell: cell)
        case 6:
            updateLabel(city_kor: "대구", city_eng: "daegu", cell: cell)
        case 7:
            updateLabel(city_kor: "인천", city_eng: "incheon", cell: cell)
        case 8:
            updateLabel(city_kor: "광주", city_eng: "gwangju", cell: cell)
        case 9:
            updateLabel(city_kor: "대전", city_eng: "daejeon", cell: cell)
        case 10:
            updateLabel(city_kor: "울산", city_eng: "ulsan", cell: cell)
        case 11:
            updateLabel(city_kor: "세종", city_eng: "sejong", cell: cell)
        case 12:
            updateLabel(city_kor: "경기", city_eng: "gyeonggi", cell: cell)
        case 13:
            updateLabel(city_kor: "강원", city_eng: "gangwon", cell: cell)
        case 14:
            updateLabel(city_kor: "충북", city_eng: "chungbuk", cell: cell)
        case 15:
            updateLabel(city_kor: "충남", city_eng: "chungnam", cell: cell)
        case 16:
            updateLabel(city_kor: "전북", city_eng: "jeonbuk", cell: cell)
        case 17:
            updateLabel(city_kor: "전남", city_eng: "jeonnam", cell: cell)
        case 18:
            updateLabel(city_kor: "경북", city_eng: "gyeongbuk", cell: cell)
        case 19:
            updateLabel(city_kor: "경남", city_eng: "gyeongnam", cell: cell)
        case 20:
            updateLabel(city_kor: "제주", city_eng: "jeju", cell: cell)
        case 21:
            updateLabel(city_kor: "검역", city_eng: "quarantine", cell: cell)
        default:
            break
        }
        return cell
    }
    
    func updateLabel(city_kor: String, city_eng: String, cell: COVIDCell) {
        cell.titleLabel.text = city_kor
        let data = jsondata2[city_eng] as! [String: Any]
        if let totalCase = (data["totalCase"] as? String), let newCase = (data["newCase"] as? String) {
            cell.valueLabel.text = "\(totalCase) (+\(newCase))"
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


