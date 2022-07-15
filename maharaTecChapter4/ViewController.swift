import UIKit
import SDWebImage
var movies : [Movie] = []
class ViewController: UIViewController {
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //next line to make app wait until get all data
        let sem = DispatchSemaphore.init(value: 0)
        let url = URL(string: "http://localhost:3000/comments/")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task =  session.dataTask(with: request) { data, response, error in
            //next line to make app wait until get all data
            defer { sem.signal() }
            guard let jsonData = data else {return}
            let decoder = JSONDecoder()
            let response  = try? decoder.decode([Movie].self, from: jsonData)
            guard let responseNonOptinal = response else {return}
            movies = responseNonOptinal
            print("hi man")

        }
        
        
        
         task.resume()
        //next line to make app wait until get all data
        sem.wait()
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        print("man")
    }
}


extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! cellCollectV
        
        cell.titleUILabel.text = movies[indexPath.row].title
        let url = URL(string: movies[indexPath.row].image)
        cell.photoUIMageView.sd_setImage(with: url, completed: nil)
        //cell.contentView.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        vc.moviveDetails = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated:
        true)
    }
    
}

