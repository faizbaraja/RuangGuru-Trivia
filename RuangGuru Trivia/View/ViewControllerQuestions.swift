//
//  ViewControllerQuestions.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class ViewControllerQuestions: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ControllerQuestionsDelegate {
    let controllerQuestions:ControllerQuestions = ControllerQuestions()
    let customAlertView:CustomAlertView = CustomAlertView()
    
    @IBOutlet var labelQuestionNumber:UILabel!
    @IBOutlet var labelRightAnswer:UILabel!
    
    @IBOutlet var buttonNext:UIButton!
    
    @IBOutlet var textViewQuestion:UITextView!
    @IBOutlet var collectionViewAnswers:UICollectionView!
    @IBOutlet var stackViewQuestionAnswer:UIStackView!
    @IBOutlet var scrollViewQuestionAnswer:UIScrollView!
    
    @IBOutlet weak var constraintHeightTextViewQuestions:NSLayoutConstraint!
    @IBOutlet weak var constraintHeightCollectionViewQuestions:NSLayoutConstraint!

    var alertLoadingData:UIAlertController = UIAlertController()
    var arrayQuestionsData:[[String:Any]]!
    var arrayAnswersData:[[String:Any]] = []
    var intCurrentIndex:Int = 0
    var indexAnswerSelected = -1
    var intRightAnswer:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerQuestions.delegate = self
        
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
        
        alertLoadingData = customAlertView.createAlertViewWithoutButton(stringTitle: "", stringMessage: "Sedang Mengunduh Data")
        self.present(alertLoadingData, animated: true, completion: {
                self.controllerQuestions.constructDataQuestions()
        })
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
    
    func loadDataQuestions(){
        intCurrentIndex = 0
        intRightAnswer = 0
        arrayQuestionsData = controllerQuestions.getQuestionsDataByCategoryID()
        self.showTriviaQuestionAndAnswers(questionNumber: intCurrentIndex)
    }
    
    func showTriviaQuestionAndAnswers(questionNumber:Int){
        buttonNext.isHidden = true
        if (questionNumber < arrayQuestionsData.count){
            indexAnswerSelected = -1
            let dictionaryCurrentQuestion:[String:Any] = arrayQuestionsData[questionNumber]
            let questionID = dictionaryCurrentQuestion["triviaQuestionID"] as! Int
            arrayAnswersData = controllerQuestions.getAnswersDataByCategoryID(questionSelectedID: questionID)
        
            labelQuestionNumber.text = "Question No. \(questionNumber + 1)"
            labelRightAnswer.text = "\(intRightAnswer) Right Answer"
            textViewQuestion.text = dictionaryCurrentQuestion["triviaQuestionText"] as! String
            collectionViewAnswers.reloadData()
        
            self.setConstraintHeightTextView()
            self.setConstraintHeightCollectionView()
            if (questionNumber == arrayQuestionsData.count - 1){
                buttonNext.setTitle("Finish", for: .normal)
            }
        }
    }
    
    @IBAction func actionNextGame(sender:UIButton){
        intCurrentIndex += 1
        if (intCurrentIndex < arrayQuestionsData.count){
            self.showTriviaQuestionAndAnswers(questionNumber: intCurrentIndex)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAnswersData.count
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
        if (arrayAnswersData.count > 0){
            let startingValue = Int(("A" as UnicodeScalar).value)
            let dictionaryAnswer = arrayAnswersData[indexPath.row]
            cell.labelAnswerText.text = (dictionaryAnswer["answersTriviaText"] as! String)
            cell.labelAnswerCorrectness.text = (dictionaryAnswer["answersTriviaCorrectness"] as! String)
            cell.labelAnswerCharacter.text = String(Character(UnicodeScalar(indexPath.row + startingValue)!))
            
            cell.viewBackground.backgroundColor = UIColor.white
            cell.labelAnswerCharacter.textColor = UIColor.lightGray
            cell.labelAnswerCorrectness.textColor = UIColor.lightGray
            cell.labelAnswerText.textColor = UIColor.lightGray
            
            if (indexPath.row == indexAnswerSelected){
                cell.labelAnswerCorrectness.isHidden = false
                if (cell.labelAnswerCorrectness.text == "Correct Answer"){
                    cell.viewBackground.backgroundColor = UIColorData.getColorCorrectGreen()
                    cell.labelAnswerCharacter.textColor = UIColorData.getColorCorrectGreen()
                }
                else{
                    cell.viewBackground.backgroundColor = UIColorData.getColorInCorrectRed()
                    cell.labelAnswerCharacter.textColor = UIColorData.getColorInCorrectRed()
                }
                cell.labelAnswerCorrectness.textColor = UIColor.white
                cell.labelAnswerText.textColor = UIColor.white
            }
            else{
                cell.labelAnswerCorrectness.isHidden = true
            }
            
            if (indexAnswerSelected >= 0){
                if (cell.labelAnswerCorrectness.text == "Correct Answer"){
                    cell.viewBackground.backgroundColor = UIColorData.getColorCorrectGreen()
                    cell.labelAnswerCharacter.textColor = UIColorData.getColorCorrectGreen()
                    cell.labelAnswerCorrectness.textColor = UIColor.white
                    cell.labelAnswerText.textColor = UIColor.white
                    cell.labelAnswerCorrectness.isHidden = false
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexAnswerSelected == -1){
            let dictionaryAnswerSelected:[String:Any] = arrayAnswersData[indexPath.row]
            if (dictionaryAnswerSelected["answersTriviaCorrectness"] as! String == "Correct Answer"){
                intRightAnswer += 1
                labelRightAnswer.text = "\(intRightAnswer) Right Answer"
            }
        }
        indexAnswerSelected = indexPath.row
        buttonNext.isHidden = false
        collectionView.reloadData()
    }
    
    func dataLoadAndSaveCompleted() {
        //dismiss alert load data
        alertLoadingData.dismiss(animated: true, completion: nil)
        self.loadDataQuestions()
        
    }
    
    func showAlertEmptyData() {
        //dismiss alert load data and show alert timeout
        alertLoadingData.dismiss(animated: true, completion: {
            let alertTimeOut:UIAlertController = self.customAlertView.createAlertWithDismissButton(stringTitle: "Kesalahan", stringMessage: "Kategori ini tidak memiliki pertanyaan", stringButtonTitle: "OK")
            self.present(alertTimeOut, animated: true, completion: nil)
        })
    }
    
    func showAlertTimeOut() {
        //dismiss alert load data and show alert timeout
        alertLoadingData.dismiss(animated: true, completion: {
            let alertTimeOut:UIAlertController = self.customAlertView.createAlertWithDismissButton(stringTitle: "Kesalahan", stringMessage: "tidak dapat mengakses server", stringButtonTitle: "OK")
            self.present(alertTimeOut, animated: true, completion: nil)
        })
    }
    
    func showAlertNotConnectedToInternet(){
        alertLoadingData.dismiss(animated: true, completion: {
            let alertTimeOut:UIAlertController = self.customAlertView.createAlertWithDismissButton(stringTitle: "Kesalahan", stringMessage: "Not Connected To Internet", stringButtonTitle: "OK")
            self.present(alertTimeOut, animated: true, completion: nil)
        })
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
