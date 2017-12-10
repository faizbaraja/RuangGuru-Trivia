//
//  ViewControllerQuestions.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class ViewControllerQuestions: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    let controllerQuestions:ControllerQuestions = ControllerQuestions()
    @IBOutlet var textViewQuestion:UITextView!
    @IBOutlet var collectionViewAnswers:UICollectionView!
    @IBOutlet var stackViewQuestionAnswer:UIStackView!
    @IBOutlet var scrollViewQuestionAnswer:UIScrollView!
    
    @IBOutlet weak var constraintHeightTextViewQuestions:NSLayoutConstraint!
    @IBOutlet weak var constraintHeightCollectionViewQuestions:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewAnswers.register(UINib(nibName:"CollectionViewCellAnswers", bundle: nil), forCellWithReuseIdentifier: "CollectionViewAnswer")
        collectionViewAnswers.dataSource = self
        collectionViewAnswers.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        collectionViewAnswers.collectionViewLayout.invalidateLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setConstraintHeightTextView()
        self.setConstraintHeightCollectionView()
        //print(controllerQuestions.getDataState())
        controllerQuestions.getQuestionsDataFromServer()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.setConstraintHeightTextView()
            self.setConstraintHeightCollectionView()
            self.collectionViewAnswers.reloadData()
        })
    }
    
    func setConstraintHeightTextView(){
        constraintHeightTextViewQuestions.constant = textViewQuestion.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    func setConstraintHeightCollectionView(){
        constraintHeightCollectionViewQuestions.constant = collectionViewAnswers.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    func setDataStateModel(dataStateModel:ModelCategoryDataState){
        controllerQuestions.setDataStateModel(dataStateModel: dataStateModel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    // tell the collection view how many cells to make
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let collectionViewLayout = collectionViewAnswers.collectionViewLayout as? UICollectionViewFlowLayout
        let collectionViewMarginIterItem:CGFloat = (collectionViewLayout?.minimumInteritemSpacing)!
        let collectionViewLeftInset:CGFloat = (collectionViewLayout?.sectionInset.left)!
        let collectionViewRightInset:CGFloat = (collectionViewLayout?.sectionInset.right)!
        
        let cellWidth = (collectionViewAnswers.frame.size.width - (collectionViewMarginIterItem + collectionViewLeftInset + collectionViewRightInset))/2
        let cellHeight:CGFloat = 100.0
        return CGSize(width:cellWidth, height: cellHeight)
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewAnswers?.dequeueReusableCell(withReuseIdentifier: "CollectionViewAnswer", for: indexPath) as! CollectionViewCellAnswers
        return cell
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
