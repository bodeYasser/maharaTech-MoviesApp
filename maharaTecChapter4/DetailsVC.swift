//
//  DetailsVC.swift
//  maharaTecChapter4
//
//  Created by Abdallah yasser on 07/06/2022.
//

import UIKit

class DetailsVC: UIViewController {
    var moviveDetails : Result?
    var movieImage : UIImage?
    @IBOutlet weak var tiitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    //need to use
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tiitleLabel.text = moviveDetails?.titleOriginal
        if let rating = moviveDetails?.rating, let year = moviveDetails?.year,let image = moviveDetails?.image {
            //,let genre =  moviveDetails?.genre
            //
            ratingLabel.text = String(rating)
            releaseYearLabel.text = String(year)
            let url = URL(string: image)
            //get moive image using SDWebImage pod
            photoImageView.sd_setImage(with: url, completed: nil)
            //var gerics = ""
//            for ger in genre{
//            gerics += "\(ger) "
//            }
//            genreLabel.text = gerics
        }

    }
    

}
