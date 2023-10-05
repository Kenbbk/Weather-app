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
    
}

enum Row: Hashable {
    case first(Int)
    case second(OneDayWeather)
    case third(Int)
}


class MainWeatherVC: UIViewController {
    //MARK: - Properties
    let locationManager = CLLocationManager()
    
    let layoutProvider = MainLayoutProvider()
    
    var oneDayWeathers: [OneDayWeather] = []
    
    var heightConstraint: NSLayoutConstraint!
    
    let mainHeaderView: MainHeaderView = .init(frame: .zero)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layoutProvider.getMainLayout())
        view.showsVerticalScrollIndicator = false
        view.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        
        view.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.register(SecondCell.self, forCellWithReuseIdentifier: SecondCell.identifier)
        view.register(MapCell.self, forCellWithReuseIdentifier: "mapCell")
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Row>!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setLocationManager()
    }
    
    
    //MARK: - Actions
    
    @objc func collectionTapped() {
        print("CollectionTapped")
    }
    
    //MARK: - Helpers
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .first(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath) as! TodayCollectionViewCell
            
                let daysWeather = WeatherViewModel.fiveDaysTemp[0]
                if indexPath.row < daysWeather.time.count {
                    cell.configure(with: daysWeather.time[indexPath.row], iconCode: daysWeather.icon[indexPath.row], temp: daysWeather.temp[indexPath.row])
                } else {
                    cell.configure(with: "빈칸", iconCode: "01d", temp: 0)
                }
                return cell
            case .second(let object):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCell.identifier, for: indexPath) as! SecondCell
                cell.configure(model: object)
                return cell
            
            case .third(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as! MapCell
                return cell
            }
        })
        
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else {
                fatalError("Could not dequeue sectionHeader: \(CellHeaderView.identifier)")
            }
//            sectionHeader.delegate = self
            sectionHeader.sectionIndex = indexPath.section
            return sectionHeader
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections(layoutProvider.sections)
        snapshot.appendItems([.first(1),.first(2), .first(3), .first(4), .first(5), .first(6), .first(7),], toSection: .first)
        let a = oneDayWeathers.map {
            Row.second($0)
        }
        snapshot.appendItems(a, toSection: .second)
        snapshot.appendItems([.third(8)], toSection: .third)
//        snapshot.appendItems([17,18,19,20,21,22,23,24,], toSection: .fourth)
        
        dataSource.apply(snapshot)
    }
    
    
    
    //MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background2")!)
        setIndicators()
        configureMainHeaderView()
        configureCollectionView()
    }
    
    private func setIndicators() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func configureMainHeaderView() {
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
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainHeaderView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
            weatherViewController.row = indexPath.row
            
            present(weatherViewController, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            let weatherViewController = WeatherViewController()
            
            print("indexPath.section: \(indexPath.section)")
            weatherViewController.section = indexPath.section
            weatherViewController.row = indexPath.row
            
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
            // 위도와 경도 가져오기
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
            let apiKey = WeatherAPIService().apiKey
            let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            
            WeatherAPIService().getLocalWeather(url: urlString) { result in
                switch result {
                case .success(let weatherResponse):
                    DispatchQueue.main.async {
                        
                        var fiveDays: [String] = []
                        var fiveDaysTemp: [FiveDayTemp] = []
                        
                        for forecast in weatherResponse.list {
                            // 온도 저장.
                            let tempChange = forecast.main.temp - 273.15
                            
                            // 공백 기준으로 문자열 자르기 ex) 2023-10-06 12:00:00 -> 2023-10-06, 12:00:00
                            let parts = forecast.dt_txt.split(separator: " ")
                            let day = String(parts[0])
                            
                            let timeParts = String(parts[1]).split(separator: ":00")
                            let time = "\(timeParts[0]) 시"
                            
                            // 기존
                            // 년월일 저장
                            if !WeatherViewModel.fiveDays.contains(day) {
                                WeatherViewModel.fiveDays.append(day)
                                // WeatherViewModel.fiveDaysTemp에 온도를 저장하는 빈 FivedayTemp 구조체 형식을 추가해준다.
                                WeatherViewModel.fiveDaysTemp.append(FiveDayTemp(time: [], icon: [], temp: []))
                            }
                            
                            // 입력받은 일의 수를 파악하여(fiveDays) 시간대별 온도를 저장할 배열(fiveDaysTemp)에 index값으로 사용함.
                            if !WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].time.contains(time) {
                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].time.append(time)
                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].icon.append(forecast.weather.first!.icon)
                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].temp.append(tempChange)
                            }
                           
                            
                            // 신규
                            // 년월일 저장
                            if !fiveDays.contains(day) {
                                fiveDays.append(day)
                                // WeatherViewModel.fiveDaysTemp에 온도를 저장하는 빈 FivedayTemp 구조체 형식을 추가해준다.
                                fiveDaysTemp.append(FiveDayTemp(time: [], icon: [], temp: []))
                            }
                            
                            // 입력받은 일의 수를 파악하여(fiveDays) 시간대별 온도를 저장할 배열(fiveDaysTemp)에 index값으로 사용함.
                            if !fiveDaysTemp[fiveDays.count-1].time.contains(time) {
                                fiveDaysTemp[fiveDays.count-1].time.append(time)
                                fiveDaysTemp[fiveDays.count-1].icon.append(forecast.weather.first!.icon)
                                fiveDaysTemp[fiveDays.count-1].temp.append(tempChange)
                            }
                        }
                        
                        print(weatherResponse.list)
                        print("WeatherViewModel.fiveDays : \(WeatherViewModel.fiveDays)")
                        print("WeatherViewModel.fiveDaysTemp : \(WeatherViewModel.fiveDaysTemp)")
                        
//                        var viewModel = WeatherViewModel.allDaysWeather
                        
//                        [Weather_Group3.FiveDayTemp(time: ["15 시", "18 시", "21 시"], icon: ["01d", "01d", "01d"], temp: [17.600000000000023, 20.379999999999995, 25.590000000000032]),
                        
                        for index in 0..<fiveDaysTemp.count {
                            var timeWeather: [TimeWeather] = []
                            
                            for timeIndex in 0..<fiveDaysTemp[index].time.count {
                                timeWeather.append(TimeWeather(time: fiveDaysTemp[index].time[timeIndex], temp: fiveDaysTemp[index].temp[timeIndex], icon: fiveDaysTemp[index].icon[timeIndex]))
                            }
                            
                            let oneDayWeather: OneDayWeather = OneDayWeather(day: fiveDays[index], highTemp: fiveDaysTemp[index].temp.max()!, lowTemp: fiveDaysTemp[index].temp.min()!, icon: fiveDaysTemp[index].icon.first!, timeWeather: timeWeather)
                            
                            self.oneDayWeathers.append(oneDayWeather)
                        }

                        
                        // Indicator
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.removeFromSuperview()
                        self.configureDataSource()
                        self.applySnapshot()
                    }
                case .failure(_ ):
                    print("실패: error")
                }
            }
        }
    }
}

//extension MainWeatherVC: CellHeaderViewDelegate {
//    func cellHeaderViewTapped(sectionIndex: Int) {
//        print(sectionIndex)
//    }
//    
//    
//}


