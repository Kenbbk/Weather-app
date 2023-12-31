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

enum Row: Hashable {
    case first(TimeWeather)
    case second(OneDayWeather)
    case third(Int)
    case fourth(Int)
}


class MainWeatherVC: UIViewController {
    //MARK: - Properties
    let locationManager = CLLocationManager()
    
    let weatherProvider = WeatherProvider()
    
    let tempRangeService = TempRangeService()
    
    let layoutProvider = MainLayoutProvider()
    
    let colorService = ColorService()
    
    var oneDayWeathers: [OneDayWeather] = []
    
    var timeWeathers: [TimeWeather] = []
    
    // Header View에 표시되는 정보
    var currentLocationForecast: CurrentLocationForecast?
    
    var heightConstraint: NSLayoutConstraint!
    
    let mainHeaderView: MainHeaderView = .init(frame: .zero)
    
    var highLowTemp: (Double, Double) = (0,0)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layoutProvider.getMainLayout())
        view.showsVerticalScrollIndicator = false
        view.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        view.register(FourthCell.self, forCellWithReuseIdentifier: FourthCell.identifier)
        view.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        
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
            case .first(let object):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath) as! TodayCollectionViewCell
                
                cell.configure(timeWeather: object)
                
                return cell
            case .second(let object):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCell.identifier, for: indexPath) as! SecondCell
                
                let tuple = self.tempRangeService.getTempRange(min: self.highLowTemp.0, max: self.highLowTemp.1, currentMin: object.lowTemp, currentMax: object.highTemp)
                
                cell.colorViews(min: tuple.0, max: tuple.1)
                cell.colorBar.colors = self.colorService.getColors(min: 20, max: 32)
                cell.configure(model: object)
                
                return cell
                
            case .third(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as! MapCell
                return cell
                
            case .fourth(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FourthCell.identifier, for: indexPath) as! FourthCell
                return cell
            }
            
            
        })
        
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else {
                fatalError("Could not dequeue sectionHeader: \(CellHeaderView.identifier)")
            }
            switch indexPath.section {
            case 0:
                sectionHeader.label.text = "3HOUR FORECAST"
            case 1:
                sectionHeader.label.text = "5-DAY FORECAST"
            case 2:
                sectionHeader.label.text = "PRECIPITATIOM"
            default:
                sectionHeader.label.text = ""
            }
            
            sectionHeader.sectionIndex = indexPath.section
            return sectionHeader
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections(layoutProvider.sections)
        let weathers = timeWeathers[0...16].map { Row.first($0)}
        
        snapshot.appendItems(weathers, toSection: .first)
        let a = oneDayWeathers[0...4].map {
            Row.second($0)
        }
        snapshot.appendItems(a, toSection: .second)
        snapshot.appendItems([.third(8)], toSection: .third)
        //        snapshot.appendItems([.fourth(9), .fourth(10)], toSection: .fourth)
        
        dataSource.apply(snapshot)
    }
    
    
    
    //MARK: - UI
    
    private func initialConfigurerUI() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blueSky4")!)
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
    
    private func stopIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    // 위치 업데이트를 수신할 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // 위도와 경도 가져오기
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
            let apiKey = WeatherAPIService().apiKey
            let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
            
            WeatherAPIService().getLocalWeather(url: urlString) { result in
                switch result {
                    
                case .failure(_):
                    print("실패: error")
                    
                case .success(let weatherResponse):
                    self.timeWeathers = self.weatherProvider.getTimeWeathers(dayWeather: weatherResponse)
                    self.highLowTemp = HighLowTempSerivce().getHighLowTemp(threeHourList: weatherResponse.list)
                    self.oneDayWeathers = self.weatherProvider.getWeathers(dayWeather: weatherResponse)
                    self.currentLocationForecast = self.weatherProvider.getCityInfo(dayWeather: weatherResponse, oneDayWeather: self.oneDayWeathers[0])
                    
                    DispatchQueue.main.async {
                        
                        // Indicator
                        self.stopIndicator()
                        // API 통신 완료 후 UI 및 데이터 입력
                        self.configureUI()
                        self.configureDataSource()
                        self.applySnapshot()
                    }
                    
                }
            }
        }
    }
}




