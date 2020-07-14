//
//  extension.swift
//  swift_image_cacher
//
//  Created by shin seunghyun on 2020/07/13.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

//Image Cache, 로딩한 이미지를 저장함. 나중에 더 빠르게 로딩하기 위해서다.

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    //비교할 url string 값
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String){
        imageUrlString = urlString
        let url = URL(string: urlString)
        //가장 처음에 로딩될 때, 해당되는 이미지가 로딩아 안되는 경우가 있어서 `nil`값을 줘서 제대로 출력되게 만든다.
        image = nil
        if let imageFromCache = imageCache.object(forKey: NSString(string:urlString)) {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                //imageUrl string과 parameter로 들어온 urlString이 같은 값일때 로딩하게 하면, collectionView나 tableView 특성 때문에 이상하게 데이터가 출력되는 경우를 방지할 수 있다.
                if self.imageUrlString == urlString {
                    imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                }
                self.image = imageToCache
            }
        }.resume()
    }
    
}
