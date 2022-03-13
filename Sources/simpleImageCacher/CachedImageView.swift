//
//  File.swift
//  
//
//  Created by Jefin on 13/03/22.
//

import Foundation
import UIKit

open class CachedImageView: UIImageView {
    
  static let imagecache = NSCache<NSString, DiscardableImageCacheItem>()
  open var  UseEmptyImage = true
  private var URLStringForChecking:String?
  private var emptyImage:UIImage?
    
// Function that Caches Image and Load Image ino ImageView
    
    open func loadImage(UrlString: String,completion: (() -> ())? = nil) {
        
        image = nil
        
        self.URLStringForChecking = UrlString
        
        let urlKey = UrlString as NSString
        
        if let Cacheditem = CachedImageView.imagecache.object(forKey: urlKey){
            
            image = Cacheditem.image
            completion?()
            return
            
        }
        
        guard let url = URL(string: UrlString) else {
            
            if UseEmptyImage {
                
                image = emptyImage
            }
            return
        }
        
        URLSession.shared.dataTask(with: url,completionHandler: { [weak self] (data, response, error) in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                
                if let image = UIImage(data: data!) {
                    
                    let cacheitem = DiscardableImageCacheItem(image: image)
                    CachedImageView.imagecache.setObject(cacheitem, forKey: urlKey)
                    
                    if UrlString == self?.URLStringForChecking{
                        
                        self?.image = image
                        completion?()
                        
                    }
                    
                }
                
            }
            
        }).resume()
    }
}
