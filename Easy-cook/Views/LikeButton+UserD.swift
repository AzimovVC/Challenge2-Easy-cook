//
//  button.swift
//  Easy-cook
//
//  Created by Sergey Azimov on 05.03.2023.
//

import UIKit

class LikeButton:UIButton {
    
    static var subscribers = [Int: Set<LikeButton>]()
    
    private let defaults = UserDefaults.standard
    
    var itemId = 0
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
      //  updateApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setID(id: Int){
        itemId = id
        
        if  !LikeButton.subscribers.keys.contains(id) {
            LikeButton.subscribers[id] = Set<LikeButton>()
        }
        
        LikeButton.subscribers[id]!.insert(self)
        self.updateApperance()
    }
    
    func updateApperance() {
       
        if isLiked {
             
             LikeButton.subscribers[itemId]!.forEach({
                 $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
             })
         } else {
             
             LikeButton.subscribers[itemId]!.forEach({
                 $0.setImage(UIImage(systemName: "heart"), for: .normal)
             })
         }
        
    }
    //check item
    var isLiked: Bool {
        return getSetIds().contains(itemId)
    }
    
    //saving
    private func saveFavoriteId(_ ids: Set<Int>) {
        defaults.set(Array(ids), forKey: K.idFavorite)
    }
    //Set with id
    func getSetIds() -> Set<Int> {
        let likedsArray = defaults.object(forKey: K.idFavorite) as? [Int] ?? []
        return Set(likedsArray)
    }
    //buttonTapped
    @objc func buttonTapped() {
        var ids = getSetIds()
        if isLiked {
            print("remove")
            ids.remove(itemId)
            print(ids)
        } else {
            print("saving")
            ids.insert(itemId)
            print(ids)
        }
        
        saveFavoriteId(ids)
        updateApperance()
    }
    
    deinit {
        LikeButton.subscribers[itemId]!.remove(self)
       
        if LikeButton.subscribers[itemId]!.count == 0{
            LikeButton.subscribers.removeValue(forKey: itemId)
            
        }// perform the deinitialization
    }
}
