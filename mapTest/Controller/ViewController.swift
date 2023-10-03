import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    
    var searchInput = UITextField()
    var searchButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupCL()
        setupSearchModule()
    }
    
    func setupSearchModule(){
        setupSearchButton()
        setupSearchInput()
    }
    
    func setupSearchButton(){
        view.addSubview(searchButton)
        searchButton.backgroundColor = .red
        searchButton.tintColor = .white
        searchButton.setTitle("Search   ", for: .normal)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant:  75),
            searchButton.widthAnchor.constraint(equalToConstant: 75),
            searchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    func setupSearchInput(){
        view.addSubview(searchInput)
        searchInput.backgroundColor = .white
        searchInput.placeholder = "Lookin for a city"
        searchInput.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            searchInput.topAnchor.constraint(equalTo: view.topAnchor, constant:  75),
            searchInput.widthAnchor.constraint(equalToConstant: 300),
            searchInput.heightAnchor.constraint(equalToConstant: 44)
            
        ])
        
        searchButton.addTarget(self, action: #selector(searchCity), for: .touchUpInside)
        
   
    }
    
    @objc func searchCity(){
       
        guard let city = searchInput.text else {
            return
        }
        
        fetchDataFromAPI(city){
            apiResponse in
            DispatchQueue.main.async {
                if let apiResponse = apiResponse {
                    
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    for city in apiResponse.features {
                        guard let latitude = city.geometry.coordinates.last, let longitude = city.geometry.coordinates.first else{
                            return
                        }
                        
                        self.addAnnotation(city.properties.name, city.properties.context, latitude, longitude)
                    }
                    
                
                }
            }
            
            
                
         
        }
    }
}


extension ViewController: MKMapViewDelegate{
    func setupMap(){
        
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        addAnnotation("Strasbourg", "info", 48.5870262, 7.7530259)
        
        addAnnotation("Paris", "Panthéon", 48.866667, 2.333333)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = button
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    
    
    func addAnnotation(_ title:String, _ subtitle:String,_ latitude: CLLocationDegrees,_ longitude:CLLocationDegrees){
        
        
        let annotation = MKPointAnnotation()
        
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        mapView.addAnnotation(annotation)
        
    }
    
}
extension ViewController: CLLocationManagerDelegate {
    func setupCL(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else{
            return
        }
        
        addAnnotation("Apple", "siège", location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            if let coordinate = locationManager.location?.coordinate {
                let regionRadius: CLLocationDistance = 15000
                let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
            }
        }
    }
}
