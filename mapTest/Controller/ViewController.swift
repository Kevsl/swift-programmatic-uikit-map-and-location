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
    
    @objc func searchCity() {
        guard let searchValue = searchInput.text else {
            return
        }

        fetchDataFromAPI(searchValue) { apiResponse in
            DispatchQueue.main.async {
                if let apiResponse = apiResponse {
                    self.mapView.removeAnnotations(self.mapView.annotations)

                    for city in apiResponse.features {
                        self.addAnnotation(city.properties.city, city.geometry.coordinates[1], city.geometry.coordinates[0], city.properties.context)
                    }
                    
                } else {
                    print("Error fetching data from API")
                }
                self.zoomToAnnotations()
            }
        }
    }
}

extension ViewController:MKMapViewDelegate{
    func setupMap(){
             mapView = MKMapView()
             mapView.delegate = self
        view.addSubview(mapView)
        
             mapView.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
                 mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
                 mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                 mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
             ])

        addAnnotation("Aix les bains", 45.692341, 5.908998, "une ville ")
        addAnnotation("Schiltigheim", 48.599998 , 7.75, "une autre ville")
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

        func addAnnotation(_ title: String, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ info: String) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = title
            annotation.subtitle = info
            mapView.addAnnotation(annotation)
        }
    
    
    func zoomToAnnotations() {
        
        let annotations = self.mapView.annotations
        if  annotations.count > 0 {
            let region = MKCoordinateRegion(center: annotations.last!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
        else{
            print("nil")
        }
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
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    
    
 


}
