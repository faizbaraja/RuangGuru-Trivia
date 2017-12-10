//
//  ViewControllerMainMenu.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class ViewControllerMainMenu: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionViewTriviaCategory:UICollectionView!
    @IBOutlet var collectionViewTriviaCategoryFlowLayout:UICollectionViewFlowLayout!
    
    let controllerMainMenu:ControllerMainMenu = ControllerMainMenu()
    
    var arrayDataCategory = [[String:Any]]()
    var dictionarySelectedCategory:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewTriviaCategory.register(UINib(nibName:"CollectionViewCellTriviaCategory", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCellCategory")
        collectionViewTriviaCategory.dataSource = self
        collectionViewTriviaCategory.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        controllerMainMenu.createCategoryAndSaveToDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrayDataCategory = controllerMainMenu.getAllCategoryDataAsArray()
        collectionViewTriviaCategory.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.collectionViewTriviaCategory.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuestionVC" {
            let viewControllerNextScene =  segue.destination as! ViewControllerQuestions
            controllerMainMenu.setCategoryDataState(dictionaryData: dictionarySelectedCategory)
            viewControllerNextScene.navigationItem.title = (dictionarySelectedCategory["categoryText"] as! String)
            viewControllerNextScene.setDataStateModel(dataStateModel: controllerMainMenu.getDataStateModel())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayDataCategory.count
    }
    
    // tell the collection view how many cells to make
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let collectionViewLayout = collectionViewTriviaCategory.collectionViewLayout as? UICollectionViewFlowLayout
        let collectionViewMarginIterItem:CGFloat = (collectionViewLayout?.minimumInteritemSpacing)!
        let collectionViewLeftInset:CGFloat = (collectionViewLayout?.sectionInset.left)!
        let collectionViewRightInset:CGFloat = (collectionViewLayout?.sectionInset.right)!
        
        let cellWidth = (collectionViewTriviaCategory.frame.size.width - (collectionViewMarginIterItem + collectionViewLeftInset + collectionViewRightInset))/2
        let cellHeight:CGFloat = 100.0
        return CGSize(width:cellWidth, height: cellHeight)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewTriviaCategory?.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellCategory", for: indexPath) as! CollectionViewCellTriviaCategory
        if (arrayDataCategory.count > 0){
            let dictionaryCategoryTrivia:[String:Any] = arrayDataCategory[indexPath.row]
            if (dictionaryCategoryTrivia.keys.count > 0){
                cell.labelCategoryTitle.text = (dictionaryCategoryTrivia["categoryText"] as! String)
                cell.imageViewIcon.image = UIImage(named: (dictionaryCategoryTrivia["categoryIcon"] as! String))
                cell.imageViewBackGround.image = UIImage(named: (dictionaryCategoryTrivia["categoryImage"] as! String))
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dictionarySelectedCategory = arrayDataCategory[indexPath.row]
        self.performSegue(withIdentifier: "ShowQuestionVC", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
