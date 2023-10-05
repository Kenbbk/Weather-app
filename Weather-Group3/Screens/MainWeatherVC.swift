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
    
    // 전체 날씨 정보
    var oneDayWeathers: [OneDayWeather] = []
    
    // Header View에 표시되는 정보
    var currentLocationForecast: CurrentLocationForecast?
    
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
        
        initialConfigurerUI()
        setLocationManager()
    }
    
    
    //MARK: - Actions
    
    @objc func collectionTapped() {
        print("CollectionTapped")
    }
    
    //MARK: - Helpers
    
    private func configureDataSource() {
        
        // Main Header View
        mainHeaderView.setCurrentLocation(currentLocationForecast: currentLocationForecast!)
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .first(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath) as! TodayCollectionViewCell
                
                let daysWeather = self.oneDayWeathers[0].timeWeather
                if indexPath.row < daysWeather.count {
                    cell.configure(with: daysWeather[indexPath.row].time, iconCode: daysWeather[indexPath.row].icon, temp: daysWeather[indexPath.row].temp)
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
    
    private func initialConfigurerUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background2")!)
        setIndicators()
    }
    
    private func configureUI() {
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
            let weatherViewController = WeatherViewController(oneDayWeathers: oneDayWeathers, indexPath: indexPath)
            
            present(weatherViewController, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            let weatherViewController = WeatherViewController(oneDayWeathers: oneDayWeathers, indexPath: indexPath)
            
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
                        
                        // 전체 날짜
                        self.oneDayWeathers = WeatherProvider().getWeathers(dayWeather: weatherResponse)
                        // Main Header View 오늘 날짜의 정보 표시
                        self.currentLocationForecast = WeatherProvider().getCityInfo(dayWeather: weatherResponse, oneDayWeather: self.oneDayWeathers[0])
                        
                        // Indicator
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.removeFromSuperview()
                        // API 통신 완료 후 UI 및 데이터 입력
                        self.configureUI()
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


