//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke
import NukeUI

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableCell: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableCell.dataSource = self
        fetchPosts()
    }

    private var posts = [Post]()

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    
                    let posts = blog.response.posts


                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    self?.posts = posts
                    self?.tableCell.reloadData()
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TableCellController
        let post = posts[indexPath.row]
        
        let imgURL = post.photos[0].originalSize.url
        
        ImagePipeline.shared.loadImage(with: imgURL) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    cell.postImage.image = response.image
                }
            case .failure(let error):
                print("Failed to load image: \(error)")
            }
        }
        
        cell.postLabel.text = post.summary
        
        return cell
    }
}

