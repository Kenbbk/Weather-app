//
//  MainWeatherVC.swift
//  Weather-Group3
//
//  Created by Woojun Lee on 2023/09/27.
//

import UIKit
import CoreLocation

enum Section {
    case first
    case second
    case third
    case fourth
}


class MainWeatherVC: UIViewController {
    //MARK: - Properties
    let locationManager = CLLocationManager()
    

    
    var heightConstraint: NSLayoutConstraint!
        
    var sections: [Section] = [.first, .second, .third, .fourth]
    
    let mainHeaderView: MainHeaderView = .init(frame: .zero)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        view.showsVerticalScrollIndicator = false
        view.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        
        view.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.register(SecondCell.self, forCellWithReuseIdentifier: SecondCell.identifier)
        view.backgroundColor = .clear
        
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    var header: NSCollectionLayoutBoundarySupplementaryItem!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test 231003
        // Indicator 임시로 테스트
        //        activityIndicator.center = view.center
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        
//        view.backgroundColor = .white
        header = supplementaryHeaderItem()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background2")!)
        configureUI()
        //        configureDataSource()
        //        applySnapshot()
        
        collectionView.delegate = self
        // Test(sr) - MapCell 등록
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "mapCell")
        
        // Test: 특정 위치의 날씨정보 얻어오기
        setLocationManager()
    }
    
    
    //MARK: - Actions
    
    @objc func collectionTapped() {
        print("CollectionTapped")
    }
    
    //MARK: - Helpers
    
    private func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath) as! TodayCollectionViewCell
                // 현재 날짜만 표시
                // test 231003
                let daysWeather = WeatherViewModel.fiveDaysTemp[0]
                print("indexPath.row: \(indexPath.row)")
                if indexPath.row < daysWeather.time.count {
                    cell.configure(with: daysWeather.time[indexPath.row], iconCode: "01d", temp: daysWeather.temp[indexPath.row])
                } else {
                    cell.configure(with: "빈칸", iconCode: "01d", temp: 0)
                }
                
                
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCell.identifier, for: indexPath) as! SecondCell
                let tuple = TempRangeService().getTempRange(min: 10, max: 30, currentMin: 10, currentMax: 30)
                
                cell.colorViews(min: tuple.0, max: tuple.1)

                cell.colorBar.colors = ColorService().getColors(min: -7, max: 21)
                return cell
            }
//            else if indexPath.section == 1 {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier, for: indexPath) as! DayCollectionViewCell
//                // 5일간의 날씨 표시
//                // test 231003
//                print("indexPath.row: \(indexPath.row)")
//                if indexPath.row < WeatherViewModel.fiveDays.count {
//                    let day = WeatherViewModel.fiveDays[indexPath.row]
//                    let daysTemp = WeatherViewModel.fiveDaysTemp[indexPath.row].temp
//                    cell.configure(with: day, icon: "icon", lowTemp: Double(daysTemp.min()!) ?? 0, highTemp: Double(daysTemp.max()!) ?? 0)
//                } else {
//                    cell.configure(with: "time", icon: "icon", lowTemp: 0, highTemp: 10)
//                }
//                
//                return cell
//            }
               else if indexPath.section == 2 {
                if let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as? MapCell {
                    return mapCell
                }
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .yellow
                
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .yellow

            return cell
        })

        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else {
                fatalError("Could not dequeue sectionHeader: \(CellHeaderView.identifier)")
            }
            sectionHeader.delegate = self
            sectionHeader.sectionIndex = indexPath.section
            return sectionHeader
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections(sections)
        snapshot.appendItems([1,2,3,4,5,6,7], toSection: .first)
        snapshot.appendItems([8,9,10,11,12,13,14,15], toSection: .second)
        snapshot.appendItems([16], toSection: .third)
        snapshot.appendItems([17,18,19,20,21,22,23,24], toSection: .fourth)
        
        dataSource.apply(snapshot)
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return header
    }
    
    //MARK: - UI
    
    private func configureUI() {
        configureMainHeaderView()
        configureCollectionView()
    }
    
    func configureMainHeaderView() {
        view.addSubview(mainHeaderView)
        
        mainHeaderView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = mainHeaderView.heightAnchor.constraint(equalToConstant: 260)
        NSLayoutConstraint.activate([
            mainHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightConstraint
        ])
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainHeaderView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [ weak self ] sectionIndex, layoutEnviro in
            guard let self else { fatalError()}
            
            let section = self.sections[sectionIndex]
            switch section {
            case .first:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                                item.contentInsets = .init(top: 1, leading: 5, bottom: 10, trailing: 5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .estimated(95)), subitems: [item])
                
                
                let section = NSCollectionLayoutSection(group: group)
                //                section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
                section.orthogonalScrollingBehavior = .continuous
                //                section.interGroupSpacing = 10
                //                let header = supplementaryHeaderItem()
                
                section.boundarySupplementaryItems = [header]
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                
                
                section.decorationItems = [backgroundItem]
                return section
                
            case .second:
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                //                group.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                
                
                section.decorationItems = [backgroundItem]
                
                return section
                
                
                
            case .third:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                
                
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                backgroundItem.contentInsets = section.contentInsets
                
                section.decorationItems = [backgroundItem]
                
                return section
                
            case .fourth:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 3, leading: 7.5, bottom: 3, trailing: 7.5)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(180)), repeatingSubitem: item, count: 2)
                group.contentInsets = .init(top: 0, leading: 0, bottom: 5, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundReusableView.identifier)
                
                backgroundItem.contentInsets = section.contentInsets
                
                section.decorationItems = [backgroundItem]
                return section
            }
            
            
        }
        
        layout.register(BackgroundReusableView.self,
                        forDecorationViewOfKind: BackgroundReusableView.identifier)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        layout.configuration = config
        
        return layout
        
    }
    
}

extension MainWeatherVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var a = heightConstraint.constant - scrollView.contentOffset.y
        a = max(115, a)
        a = min(a, 260)
        // 하이트 컨스턴트를 만들고 그값을 업데이트해준뒤
        //        heightFloat = a
        heightConstraint.constant = a // <- 여기에다가 넣어준다
        // 넣어주고 나서 넣어준값이 변경될때마다 City label Constraint를 업데이트 시켜준다
        mainHeaderView.topConstraintConstant = (7 / 29) * heightConstraint.constant - 30.3448
        if heightConstraint.constant > 115 {
            if scrollView.contentOffset.y <= 0 {
                
            } else {
                scrollView.contentOffset.y = 0
            }
            
        }
        
    }
    
    
}



extension MainWeatherVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.section == 0 {
            let weatherViewController = WeatherViewController()
            
            print("indexPath.section: \(indexPath.section)")
            weatherViewController.section = indexPath.section
            
            present(weatherViewController, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            let weatherViewController = WeatherViewController()
            
            print("indexPath.section: \(indexPath.section)")
            weatherViewController.section = indexPath.section
            
            present(weatherViewController, animated: true, completion: nil)
        }  else if indexPath.section == 2 {
            let mapViewController = MapViewController()
            present(mapViewController, animated: true) }
    }
}

extension MainWeatherVC: CLLocationManagerDelegate {
    // MARK: 현재 위치 파악 함수.
    private func setLocationManager() {
        // 델리게이트를 설정하고,
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("위치 서비스 허용 off")
        }
    }
    
    // 위치 업데이트를 수신할 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // OpenWeatherMap API 엔드포인트 및 API 키 설정
            let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
            let apiKey = WeatherAPIService().apiKey
            let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            
            // URLSession을 사용하여 데이터 가져오기
            if let url = URL(string: urlString) {
                let session = URLSession.shared
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("데이터를 가져오는 중 오류 발생: \(error)")
                    } else if let data = data {
                        // 데이터가 성공적으로 가져온 경우
                        do {
                            // JSON 디코딩
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                // 예보 데이터 확인
                                if let list = json["list"] as? [[String: Any]] {
                                    
                                    // 같은 날짜끼리 묶기
                                    var dayParts: [String] = []
                                    
                                    for forecast in list {
                                        if let dtTxt = forecast["dt_txt"] as? String,
                                           let main = forecast["main"] as? [String: Any],
                                           let temp = main["temp"] as? Double
//                                           let weather = forecast["weather"] as? [String: Any],
//                                           let icon = weather["icon"] as? String
                                        {
                                            // 날짜 및 시간대별 온도 출력
                                            // print("main: \(main), Date/Time: \(dtTxt), Temperature: \(temp - 273.15) ℃")
                                            let tempChange = temp - 273.15
                                            // print("Date/Time: \(dtTxt), Temperature: \(tempChange) ℃")
                                            WeatherViewModel.tempOfChart.append(tempChange)
                                            WeatherViewModel.timeOfChart.append(dtTxt)
                                            
                                            // 공백 기준으로 문자열 자르기 ex) 2023-10-06 12:00:00 -> 2023-10-06, 12:00:00
                                            let parts = dtTxt.split(separator: " ")
                                            let day = String(parts[0])
                                            let time = String(parts[1])
                                            
                                            if !WeatherViewModel.fiveDays.contains(day) {
                                                WeatherViewModel.fiveDays.append(day)
                                                // WeatherViewModel.fiveDaysTemp에 온도를 저장하는 빈 FivedayTemp 구조체 형식을 추가해준다.
                                                WeatherViewModel.fiveDaysTemp.append(FivedayTemp(time: [], temp: []))
                                            }
                                            
                                            // 입력받은 일의 수를 파악하여(fiveDays) 시간대별 온도를 저장할 배열(fiveDaysTemp)에 index값으로 사용함.
                                            if !WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].time.contains(time) {
                                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].time.append(time)
                                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].temp.append(tempChange)
                                            }
                                            // print("저장 상태 : \(WeatherViewModel.fiveDaysTemp)")
                                        }
                                    }
                                    
                                    for i in 0..<WeatherViewModel.fiveDays.count {
                                        print("i: \(i)")
                                        print("WeatherViewModel.fiveDays[i]: \(WeatherViewModel.fiveDays[i])")
                                        print("WeatherViewModel.fiveDaysTemp[i]: \(WeatherViewModel.fiveDaysTemp[i])")
                                    }
                                    
                                    // API 호출이 완료된 후 화면 업데이트
                                    DispatchQueue.main.async {
                                        // API 호출이 끝나고 실행
                                        // 임시로 Indicator Test
                                        // self.activityIndicator.stopAnimating()
                                        // self.activityIndicator.removeFromSuperview()
                                        self.configureDataSource()
                                        self.applySnapshot()
                                    }
                                }
                            }
                        } catch {
                            print("JSON 데이터 디코딩 중 오류 발생: \(error)")
                        }
                    }
                }
                task.resume()
            }

        }
    }
}

extension MainWeatherVC: CellHeaderViewDelegate {
    func cellHeaderViewTapped(sectionIndex: Int) {
        print(sectionIndex)
    }
    
    
}


