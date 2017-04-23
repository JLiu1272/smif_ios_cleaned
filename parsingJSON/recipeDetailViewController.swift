//
//  recipeDetailViewController.swift
//  parsingJSON
//
//  Created by Jennifer liu on 22/4/2017.
//  Copyright © 2017 Jennifer liu. All rights reserved.
//

import UIKit

class recipeDetailViewController: UIViewController, downloadImgProtocal, fullRecipeAPIModelProtocal{

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var large_image: UIImageView!
    
    var selectedRecipe: recipeModel = recipeModel()
    var large_img: UIImage = UIImage()
    
    var recipeInst: NSArray = NSArray()
    
    //Initializing API for recipe titles
    let downloadImgModel = DownloadImgModel()
    
    @IBOutlet weak var instruction: UIScrollView!
    
    //Initializing API for full Recipe
    let FullRecipeAPI = fullRecipeAPIModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImgModel.delegate = self
        FullRecipeAPI.delegate = self
        
        downloadImgModel.convertToImage(base64: selectedRecipe.getImage())
        
        recipeTitle.text = selectedRecipe.getTitle()
        FullRecipeAPI.downloadItems(id: selectedRecipe.getId())
        instruction.isDirectionalLockEnabled = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloadedRecipe(items: NSArray) {
        recipeInst = items
        var ingredients = ""
        var equipement = ""
        var steps = ""
        DispatchQueue.main.async{
            self.large_image.image = self.large_img
            
            var ycor: CGFloat = 5
            
            for i in 0 ..< self.recipeInst.count{
                
                let ingredientTitle = UILabel()
                //ingredientTitle.backgroundColor = UIColor.red
                ingredientTitle.numberOfLines = 0
                ingredientTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
                ingredientTitle.font = UIFont(name: "Avenir", size: 12.0)
                ingredientTitle.text = "Ingredients"
                ingredientTitle.sizeToFit()
                ingredientTitle.frame = CGRect(x: 0, y: ycor, width: self.view.frame.size.width, height: ingredientTitle.frame.height)
                self.instruction.addSubview(ingredientTitle)
                ycor += 5
             
                //let ingr = ((self.recipeInst[i] as! fullRecipeModel).getIngredient(idx: i))
                //print(ingr)
                for m in 0 ..< (self.recipeInst[i] as! fullRecipeModel).getIngredient().count{
                    ycor += 15
                    ingredients = (self.recipeInst[i] as! fullRecipeModel).getIngredient()[m] + ""
                    //UILabel for Ingredient Content
                    let ingredientCont = UILabel()
                    //ingredientCont.backgroundColor = UIColor.red
                    ingredientCont.numberOfLines = (self.recipeInst[i] as! fullRecipeModel).getIngredient().count
                    ingredientCont.lineBreakMode = NSLineBreakMode.byWordWrapping
                    ingredientCont.font = UIFont(name: "Avenir-Light", size: 8.0)
                    ingredientCont.text = ingredients
                    ingredientCont.sizeToFit()
                    ingredientCont.frame = CGRect(x: 0, y: ycor, width: self.view.frame.size.width-50, height: ingredientCont.frame.height)
                    self.instruction.addSubview(ingredientCont)
                }
                
                //Setting title for Equipments
                ycor += 20
                let equipmentTitle = UILabel()
                //equipmentTitle.backgroundColor = UIColor.blue
                equipmentTitle.numberOfLines = 0
                equipmentTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
                equipmentTitle.font = UIFont(name: "Avenir", size: 12.0)
                equipmentTitle.text = "Equipment"
                equipmentTitle.sizeToFit()
                equipmentTitle.frame = CGRect(x: 0, y: ycor, width: self.view.frame.size.width, height: ingredientTitle.frame.height)
                self.instruction.addSubview(equipmentTitle)
                ycor += 5
                
                for n in 0 ..< (self.recipeInst[i] as! fullRecipeModel).getEquipment().count{
                    equipement = (self.recipeInst[i] as! fullRecipeModel).getEquipment()[n]
                    ycor += 15
                    //UILabel for Equipment Content
                    let equipmentCont = UILabel()
                    //equipmentCont.backgroundColor = UIColor.blue
                    equipmentCont.numberOfLines = (self.recipeInst[i] as! fullRecipeModel).getEquipment().count
                    equipmentCont.lineBreakMode = NSLineBreakMode.byWordWrapping
                    equipmentCont.font = UIFont(name: "Avenir-Light", size: 8.0)
                    equipmentCont.text = equipement
                    equipmentCont.sizeToFit()
                    equipmentCont.frame = CGRect(x: 0, y: ycor, width: self.view.frame.size.width, height: equipmentCont.frame.height)
                    self.instruction.addSubview(equipmentCont)
                }
                
                //Setting title for Steps
                ycor += 20
                let stepsTitle = UILabel()
                //stepsTitle.backgroundColor = UIColor.green
                stepsTitle.numberOfLines = 0
                stepsTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
                stepsTitle.font = UIFont(name: "Avenir", size: 12.0)
                stepsTitle.text = "Instructions"
                stepsTitle.sizeToFit()
                stepsTitle.frame = CGRect(x: 0, y: ycor, width: self.view.frame.size.width, height: stepsTitle.frame.height)
                self.instruction.addSubview(stepsTitle)
                ycor += 30
                
                
                for h in 0 ..< (self.recipeInst[i] as! fullRecipeModel).getSteps().count{
                    steps = "\(h+1). \((self.recipeInst[i] as! fullRecipeModel).getSteps()[h])"
                    //UILabel for Steps Content
                    let stepsCont = UITextView()
                    //stepsCont.backgroundColor = UIColor.green
                    stepsCont.font = UIFont(name: "Avenir-Light", size: 8.0)
                    stepsCont.text = steps
                    stepsCont.sizeToFit()
                    stepsCont.isEditable = false
                    stepsCont.isSelectable = false
                    
                    stepsCont.frame = CGRect(x: 0, y: ycor, width: self.view.frame.size.width, height: stepsCont.frame.height)
                    self.instruction.addSubview(stepsCont)
                    ycor += 30
                }
            }
            
            //Adding Ingredient Content to Instruction ScrollView
            print(ingredients)
            self.instruction.contentSize = CGSize(width: self.view.frame.size.width, height: ycor)
            //ingredientCont.text = ingredients
            //self.instruction.addSubview(ingredientCont)
            
            //let finalInst = "\(ingredients)\(equipement)\(steps)"
            
            //self.instruction.text = finalInst
            
            
        }
        print(recipeInst)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0{
            scrollView.contentOffset.x = 0
        }
    }
    
    func itemDownloadedImg(image: UIImage){
        self.large_img = image
        DispatchQueue.main.async{
            self.large_image.image = self.large_img
        }
    }

}
