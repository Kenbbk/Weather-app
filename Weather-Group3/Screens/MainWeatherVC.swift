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
    
    var lastPositionY: CGFloat = 0
    
    var currentOffsetY: CGFloat = 0
    
    let sectionPadding: CGFloat = 15
    
    let sectionTopPadding: CGFloat = 5
    
    var heightConstraint: NSLayoutConstraint! {
        didSet {
            print("changed")
        }
    }
    
    //    var heightFloat: CGFloat {
    //        print(heightConstraint.constant)
    //        return heightConstraint.constant
    //
    //    }
    var sections: [Section] = [.first, .second, .third, .fourth]
    
    let mainHeaderView: MainHeaderView = .init(frame: .zero)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        view.contentInset = .init(top: 260, left: 0, bottom: 0, right: 0)
        view.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellHeaderView.identifier)
        
        view.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.identifier)
        view.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.identifier)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .white
        
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    // test 231003
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test 231003
        // Indicator 임시로 테스트
        //        activityIndicator.center = view.center
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        
        view.backgroundColor = .white
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
    
    //MARK: - Helpers
    
    private func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCollectionViewCell.identifier, for: indexPath) as! TodayCollectionViewCell
                // 현재 날짜만 표시
                // test 231003
                let daysWeather = WeatherViewModel.fiveDaysTemp[0]
                if indexPath.row < daysWeather.time.count {
                    cell.configure(with: daysWeather.time[indexPath.row], iconCode: daysWeather.icon[indexPath.row], temp: daysWeather.temp[indexPath.row])
                } else {
                    cell.configure(with: "빈칸", iconCode: "01d", temp: 0)
                }
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.identifier, for: indexPath) as! DayCollectionViewCell
                // 5일간의 날씨 표시
                // test 231003
                if indexPath.row < WeatherViewModel.fiveDays.count {
                    let day = WeatherViewModel.fiveDays[indexPath.row]
                    let daysIcon = WeatherViewModel.fiveDaysTemp[indexPath.row].icon
                    let daysTemp = WeatherViewModel.fiveDaysTemp[indexPath.row].temp
                    cell.configure(with: day, iconCode: daysIcon[0], lowTemp: Double(daysTemp.min()!) , highTemp: Double(daysTemp.max()!) )
                } else {
                    cell.configure(with: "time", iconCode: "01d", lowTemp: 0, highTemp: 10)
                }
                
                return cell
            }
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
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//            cell.backgroundColor = .yellow
//            return cell
//        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellHeaderView.identifier, for: indexPath) as? CellHeaderView else {
                fatalError("Could not dequeue sectionHeader: \(CellHeaderView.identifier)")
            }
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
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem    {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        return header
    }
    
    //MARK: - UI
    
    private func configureUI() {
        configureCollectionView()
        configureMainHeaderView()
        
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
                //                item.contentInsets = .init(top: 1, leading: 5, bottom: 1, trailing: 5)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(70)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                return section
                
            case .second:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), repeatingSubitem: item, count: 1)
                group.contentInsets = .init(top: 2.5, leading: 0, bottom: 2.5, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: sectionTopPadding, trailing: sectionPadding)
                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                
                return section
                
                
                
            case .third:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //                item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                //                section.decorationItems = [UIView()]
                section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: sectionTopPadding, trailing: sectionPadding)
                
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
                section.contentInsets = .init(top: 0, leading: 7.5, bottom: sectionTopPadding, trailing: 7.5)
                //                section.boundarySupplementaryItems = [supplementaryHeaderItem()]
                //                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
            
            
        }
        layout.register(BackgroundReusableView.self,
                        forDecorationViewOfKind: BackgroundReusableView.identifier)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        // config.interSectionSpacing = 20
        
        layout.configuration = config
        
        return layout
        
        
    }
    
}

extension MainWeatherVC: UIScrollViewDelegate {
    
    //    func updateOffset(offsetY: CGFloat) {
    //
    //
    //        guard offsetY < -75 else { return }
    //
    //        let diff = lastPositionY - offsetY
    //
    //        self.currentOffsetY = currentOffsetY + diff
    //        print(lastPositionY, offsetY, diff)
    //
    //        heightConstraint.constant = currentOffsetY
    //
    //        lastPositionY = offsetY
    //
    //    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y <= 0 else { return }
        
        if scrollView.contentOffset.y > -260 {
            heightConstraint.constant = max(abs(scrollView.contentOffset.y), 105)
            
            mainHeaderView.topConstraint.constant = max((6 / 31) * abs(scrollView.contentOffset.y) - (630 / 31), -5)
            
            print(mainHeaderView.topConstraint.constant)
            
        } else {
            heightConstraint.constant = 260
            mainHeaderView.topConstraint.constant = 30
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
                        for forecast in weatherResponse.list {
                            print("wind: \(forecast.wind.speed)")
                            
                            // 날짜와 시간 저장
                            WeatherViewModel.timeOfChart.append(forecast.dt_txt)
                            
                            // 온도 저장.
                            let tempChange = forecast.main.temp - 273.15
                            WeatherViewModel.tempOfChart.append(tempChange)
                            
                            // 공백 기준으로 문자열 자르기 ex) 2023-10-06 12:00:00 -> 2023-10-06, 12:00:00
                            let parts = forecast.dt_txt.split(separator: " ")
                            let day = String(parts[0])
                            let time = String(parts[1])
                            
                            // 년월일 저장
                            if !WeatherViewModel.fiveDays.contains(day) {
                                WeatherViewModel.fiveDays.append(day)
                                // WeatherViewModel.fiveDaysTemp에 온도를 저장하는 빈 FivedayTemp 구조체 형식을 추가해준다.
                                WeatherViewModel.fiveDaysTemp.append(FivedayTemp(time: [], icon: [], temp: []))
                            }
                            
                            // 입력받은 일의 수를 파악하여(fiveDays) 시간대별 온도를 저장할 배열(fiveDaysTemp)에 index값으로 사용함.
                            if !WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].time.contains(time) {
                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].time.append(time)
                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].icon.append(forecast.weather.first!.icon)
                                WeatherViewModel.fiveDaysTemp[WeatherViewModel.fiveDays.count-1].temp.append(tempChange)
                            }

                            // 임시로 Indicator Test
                            //                                        // self.activityIndicator.stopAnimating()
                            //                                        // self.activityIndicator.removeFromSuperview()
                            self.configureDataSource()
                            self.applySnapshot()
                        }
                    }
                case .failure(_ ):
                    print("실패: error")
                }
            }
        }
    }
}
