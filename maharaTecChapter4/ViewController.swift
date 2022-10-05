import UIKit
import SDWebImage
import CoreData
//array of data mode for local api
//var movies : [Movie] = []
//array of data model for Movies App api from rapid api
var movies : [Result] = []
class ViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var message = ""
        //show user last time the list was updated ,to decide if he want to update it or not
        let lastLogin =  UserDefaults.standard.string(forKey: "loginDate")
        if let lastLogin = lastLogin {
             message = "the last time you update the list was \(lastLogin)"
        }else{
            message = "it's the first time to open app so click update"
        }
        let upDateAlert = UIAlertController(title: " do you want to update the list", message: message, preferredStyle: .alert)
        upDateAlert.addAction(UIAlertAction(title: "cancel", style: .cancel,handler: { _ in
            
            //fetch data from core data
                let fetchedRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
                do {
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context =  appDelegate.persistentContainer.viewContext
                    let allMovies = try context.fetch(fetchedRequest)
                    print("can you see number of data that will be fetched")
                    print(allMovies.count)
                    for singleMovie in allMovies{
                        
                     //   print(allMovies[0].value(forKey: "title"))
                        print(singleMovie.value(forKey: "title")!)
                    }
                    
                }
                catch{
                    print("error2")
                }
            
        }))
        upDateAlert.addAction(UIAlertAction(title: "update", style: .default,handler: { _ in

            do {
                let fetchedRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context =  appDelegate.persistentContainer.viewContext
                let deletedMovies = try context.fetch(fetchedRequest)
                print("can you see number of data before delete")
                print(deletedMovies.count)
                
                
                //if core data isn't empty delete all data from it ,else  nothing
                if deletedMovies.count > 0 {
                    for deletedMovie in deletedMovies{
                       // print(deletedMovie.value(forKey: "title"))
                        context.delete(deletedMovie)
                        try context.save()
                    }
                }
                print("can you see number of data after delete")
                //should use new request to know the new number of object in movieEntity
                let fetchedRequest1 = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
                let deletedMovies1 = try context.fetch(fetchedRequest1)
                print(deletedMovies1.count)
                    
            }
            catch{
                print("error2")
            }

            
            
            
            //get the date and time of last time app was updated
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let theCurrentDate = dateFormatter.string(from: today)
            //store that date in user default
            let userDefaults = UserDefaults.standard
            userDefaults.set(theCurrentDate, forKey: "loginDate")
//-----------------------------------------------------------------------------------------------------------------------------
            //get data from api ,convert ,store in movies
            //let url = URL(string: "http://localhost:3000/comments/")
            let url = URL(string:"https://movies-app1.p.rapidapi.com/api/movies")
            var request = URLRequest(url: url!)
            //add api key to header
            request.addValue("26c064811fmsh3430e68097cd394p170803jsn9a8e91f87f85", forHTTPHeaderField: "X-RapidAPI-Key")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task =  session.dataTask(with: request) { data, response, error in
                guard let jsonData = data else {return}
                //print returned data bytyes
                //print(jsonData)
                //use decoder to convert movies data from jason shape to data model shape
                let decoder = JSONDecoder()
                //Welcome
                let response  = try? decoder.decode(Welcome.self, from: jsonData)
                //print(response)
                guard let responseNonOptinal = response else {
                    print("no data here ")
                    return
                    
                }
                    //store data from api after coverted in movies array
                  movies = responseNonOptinal.results
                
                

                
                
                
                /*can't reload collectionCell in background thread
                 so used dispatch to reload in main thread
                 */
                DispatchQueue.main.async {
                    
                    
                                //store data in CoreData
                                //can't use appDelegate in background thread
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context =  appDelegate.persistentContainer.viewContext
                                let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context)
                                
                                for theMovie in movies {
                                    let moive = NSManagedObject(entity: entity!, insertInto: context)
                                    moive.setValue(theMovie.titleOriginal, forKey: "title")
                                    moive.setValue(theMovie.rating, forKey: "rate")
                                    moive.setValue(theMovie.year, forKey: "releaseYear")
                                    //moive.setValue(theMovie.image, forKey: "title")
                                    do {
                                    try context.save()
                                    }
                        
                                    catch{
                                        print("error1")
                                    }
                                }
                    

                    
                    
                    //reload collection view after get data from api
                    self.movieCollectionView.reloadData()
                }
                

            }
             task.resume()
            
            
            
        }))
        
        self.present(upDateAlert, animated: true)
        
        
        

        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        //print("man")
    }
}


extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    // give collection view number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    
    
    //build cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! cellCollectV
        
        cell.titleUILabel.text = movies[indexPath.row].titleOriginal
        let url = URL(string: movies[indexPath.row].image)
        if let url = url {
            cell.photoUIMageView.sd_setImage(with: url, completed: nil)
        }
        //get moive image using SDWebImage pod 
        
        //cell.contentView.backgroundColor = .blue
        return cell
    }
        
    //when user select movies open new screen that contain all info about that movie
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        vc.moviveDetails = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated:
        true)
    }
    
}

