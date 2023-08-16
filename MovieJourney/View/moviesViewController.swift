//
//  moviesViewController.swift
//  MovieJourney
//
//  Created by Öykü Hazer Ekinci on 27.07.2023.
//

import UIKit
import RealmSwift
class moviesViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
       let cellIdentifier = "Cell"
       let numberOfCells = 6
       var viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        // Set the background color of the view
            view.backgroundColor = UIColor(red: 1.1, green: 0.7, blue: 0.0, alpha: 1.0)
        // Setup the collection view and title label
            setupCollectionView()
            addTitleLabel()
        // Check if the movie types are already saved in Realm, if not, save them
            let realm = try! Realm()
            if realm.objects(MovieType.self).isEmpty {
                saveMovieTypesToRealm()
            }
        // Fetch movie types from Realm using the ViewModel
            viewModel.fetchMovieTypesFromRealm()
        }
    // Function to save initial movie types to Realm
        private func saveMovieTypesToRealm() {
            let movieTypeData: [(name: String, imageURL: String)] = [
                ("Action", "https://www.media.hw-static.com/media/2023/05/Screenshot-2023-05-17-234350.png"),
                ("Comedy", "https://i0.wp.com/www.mommatogo.com/wp-content/uploads/2020/04/comedy-movies-travel.png?w=735&ssl=1"),
                ("Drama", "https://tlokireviews.files.wordpress.com/2010/07/dd61f5367ad89a26_drama-poll-xxlarge.jpg"),
                ("Si-Ci/Fantastic", "https://www.ghawyy.com/wp-content/uploads/2021/08/Sci-Fi-Movies-1.jpg"),
                ("Horror", "https://assets-global.website-files.com/60a75d8226f3295ecacf9e33/617bd7ce29c3c21e72140598_Picture2-p-2600.jpeg"),
                ("Romance", "https://confirmgood.com/wp-content/uploads/2023/02/romantic-movies-feature-image.png")
            ]
            
            // Save movie types to Realm
            let realm = try! Realm()
            try! realm.write {
                for data in movieTypeData {
                    let movieType = MovieType()
                    movieType.name = data.name
                    movieType.imageURL = data.imageURL
                    realm.add(movieType)
                }
            }
        }
        
    // Function to set up the collection view
        private func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 40 // Adjust the line spacing as per your requirement
            layout.minimumInteritemSpacing = 16 // Adjust the interitem spacing as per your requirement
            
            let collectionViewWidth: CGFloat = view.bounds.width - 60
            let collectionViewHeight: CGFloat = view.bounds.height - 130 // Adjust the value to move the collection view down
            
            collectionView = UICollectionView(frame: CGRect(x: (view.bounds.width - collectionViewWidth) / 2,
                                                            y: (view.bounds.height - collectionViewHeight) / 2 + 140,
                                                            width: collectionViewWidth,
                                                            height: collectionViewHeight), collectionViewLayout: layout)
            collectionView.backgroundColor = view.backgroundColor
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
            
            view.addSubview(collectionView)
        }
        
    // Function to add the title label to the view
        private func addTitleLabel() {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 120, width: view.bounds.width, height: 30))
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
            titleLabel.textColor = .white
            titleLabel.text = "Choose movie category"
            view.addSubview(titleLabel)
        }
        
    // Function to download an image from a URL
        func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }.resume()
        }
        
    // Function to specify the number of items in the collection view
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfCells
        }
        
    // Function to configure the cells in the collection view
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            // Remove all subviews from the cell to avoid duplicates when reusing cells
            cell.subviews.forEach { $0.removeFromSuperview() }
            
            // Create a container view to hold the image view and border layer
            let containerView = UIView(frame: CGRect(x: 3, y: 3, width: cell.bounds.width - 6, height: cell.bounds.height - 6))
            containerView.backgroundColor = .clear
            cell.addSubview(containerView)
            
            // Fetch the movie type using the ViewModel and update the cell
            if let movieType = viewModel.movieType(at: indexPath.row) {
                var imageView = containerView.viewWithTag(100) as? UIImageView
                if imageView == nil {
                    imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
                    imageView?.contentMode = .scaleAspectFill
                    imageView?.clipsToBounds = true
                    imageView?.tag = 100
                    containerView.addSubview(imageView!)
                }
                
                // Download and set the image for the movie type
                if let imageURL = URL(string: movieType.imageURL) {
                    downloadImage(from: imageURL) { image in
                        imageView?.image = image ?? UIImage(named: "placeholder_image")
                    }
                } else {
                    imageView?.image = UIImage(named: "placeholder_image")
                }
                
                // Create a border layer with a dark green color for the container view
                let frameLayer = CAShapeLayer()
                frameLayer.strokeColor = UIColor.darkGray.cgColor
                frameLayer.lineWidth = 5.0
                frameLayer.fillColor = nil
                
                let frameRect = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
                frameLayer.path = UIBezierPath(rect: frameRect).cgPath
                containerView.layer.addSublayer(frameLayer)
                
                var movieTypeLabel = cell.viewWithTag(101) as? UILabel
                if movieTypeLabel == nil {
                    movieTypeLabel = UILabel(frame: CGRect(x: 0, y: cell.bounds.height / 2 + 60, width: cell.bounds.width, height: cell.bounds.height / 2 - 20))
                    movieTypeLabel?.tag = 101
                    movieTypeLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                    movieTypeLabel?.textAlignment = .center
                    movieTypeLabel?.textColor = .white
                    movieTypeLabel?.numberOfLines = 0
                    cell.addSubview(movieTypeLabel!)
                }
                
                // Set the movie type name in the label
                movieTypeLabel?.text = movieType.name
            }
            
            return cell
        }
        
    // Function to specify the size for each item in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 10
           let collectionViewWidth = collectionView.bounds.width - padding
           let cellWidth = (collectionViewWidth - 20) / 2
           
           return CGSize(width: cellWidth, height: cellWidth)
       }
    
    // Function to handle cell selection in the collection view
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // Check if a movie type is available at the selected index
           if let movieType = viewModel.movieType(at: indexPath.row) {
               
               // Instantiate and navigate to the "AddedListViewController" passing the selected category name
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let addedListViewController = storyboard.instantiateViewController(withIdentifier: "AddedListViewController") as! AddedListViewController
               addedListViewController.selectedCategory = movieType.name
               
               self.navigationController?.pushViewController(addedListViewController, animated: true)
           }
       }
   }
  

