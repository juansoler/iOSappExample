//
//  AddSampleViewController.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 03/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddSampleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] // dropdown item

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        crystalText.text = pickerData[row]
        sampleItem?.typeOfGlass = pickerData[row]
    }
    
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var crystalText: UITextField!
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        crystalText.inputView = pickerView
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        crystalText.inputAccessoryView = toolBar
    }
    @objc func action() {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if VER2
            picker.isHidden = true
            crystalText.isHidden = true
        #else
            calculateButton.isEnabled = false
            crystalType.isEnabled = false
            calculateButton.isHidden = true
            crystalType.isHidden = true
        
        #endif
        
        lblSlider.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: .editingChanged)
        
        self.title = sampleItem!.name
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["headlamps", "tableware", "build wind non-float", "build wind float", "containers", "vehic wind float", "vehic wind non-float"]
        /* ref?.observe(.value, with: { snapshot in
            var newItems: [Sample] = []
            self.sampleItem = snapshot.value as? Sample
            
            
        })
 */
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        lblSilicon.text! = (sampleItem?.silicon.description)!
        lblManganese.text! = (sampleItem?.manganese.description)!
        lblSodium.text! = (sampleItem?.sodium.description)!
        lblCalcium.text! = (sampleItem?.calcium.description)!
        lblAluminium.text! = (sampleItem?.aluminium.description)!
        lblPotasium.text! = (sampleItem?.potasium.description)!
        lblBarium.text! = (sampleItem?.barium.description)!
        lblIron.text! = (sampleItem?.iron.description)!
        lblReIn.text! = (sampleItem?.refractiveIndex.description)!
        crystalType.text! = (sampleItem?.typeOfGlass.description)!
        crystalText.text! = (sampleItem?.typeOfGlass.description)!
        
        /*
        No funciona...es para establecer el valor del tipo de cristal en el picker, pero al parecer cuando hace el slectedRow aún no ha metido los datos del pickerData en el picker y por lo tanto está vacío y no tiene elementos.
         
        let indexPicker = pickerData.firstIndex(of: (sampleItem?.typeOfGlass.description)!)!-1
        print(indexPicker)
        if (indexPicker != 0 || indexPicker != nil){
            picker.selectedRow(inComponent: indexPicker )

        }
 */
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var btnManganeseOutlet: UIButton!
    
    @IBOutlet weak var btnSiliconOutlet: UIButton!
    
     @IBOutlet weak var btnSodiumOutlet: UIButton!
     @IBOutlet weak var btnCalciumOutlet: UIButton!
     @IBOutlet weak var btnBariumOutlet: UIButton!
     @IBOutlet weak var btnAluminiumOutlet: UIButton!
     @IBOutlet weak var btnRefractiveOutlet: UIButton!
    
     @IBOutlet weak var btnPotasiumOutlet: UIButton!
     @IBOutlet weak var btnIronOutlet: UIButton!
    
    var sodium: Bool = false
    var manganese: Bool = false
    var silicon: Bool = false
    var calcium: Bool = false
    var aluminium: Bool = false
    var potasium: Bool = false
    var barium: Bool = false
    var iron: Bool = false
    var reIn:Bool = false
    var sampleItem: Sample?
    var ref: DatabaseReference?

    @IBAction func btnGuardar(_ sender: Any) {
        ref?.setValue(sampleItem?.toAnyObject()){ (error, ref) in
            if error != nil {
                //print(error?.localizedDescription ?? "Failed to update value")
                self.showPopup(isSuccess: false)
                
            } else {
                //print("Success update newValue to database")
                self.showPopup(isSuccess: true)
                
                
            }
    }
    }
    
    @IBOutlet weak var lblSilicon: UILabel!
    
    @IBOutlet weak var lblManganese: UILabel!
    
    @IBOutlet weak var lblSodium: UILabel!
    
    @IBOutlet weak var lblCalcium: UILabel!
    
    @IBOutlet weak var lblAluminium: UILabel!
    
    @IBOutlet weak var lblPotasium: UILabel!
    
    @IBOutlet weak var lblBarium: UILabel!
    
    @IBOutlet weak var lblIron: UILabel!
    
    @IBOutlet weak var lblReIn: UILabel!
    
    
    @IBOutlet weak var lblSlider: UITextField!
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        guard !s.isEmpty else { return true }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter.number(from: s)?.intValue != nil
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) throws{
        let numberFormatter = NumberFormatter()
        
        //let pattern = "^([-+]?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
        
        let pattern = "^-?[0-9]\\d*(\\.\\d*)?$"
        
        
        let validNumber = textField.text!.range(of: pattern, options: [.regularExpression]) != nil
        
        //print(validNumber)
        
        
        var number = numberFormatter.number(from: "0")

        if textField.text! == ""{
            //print("dentro if")
            number = numberFormatter.number(from: "0")
        }else {
            //print("fuera if")
            number = numberFormatter.number(from: textField.text!)
        }
       
        
        
        var numberFloatValue:Float = 0
        
        if validNumber{
            numberFloatValue = number!.floatValue
        }else {
            let alert = UIAlertController(title: "Must enter only numbers", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            lblSlider.text = ""
        }
        
        if (manganese){
            sampleItem?.manganese = Double(numberFloatValue)
            lblManganese.text = "\(Double(numberFloatValue))"
        }
        if (silicon){
            sampleItem?.silicon = Double(numberFloatValue)
            lblSilicon.text = "\(Double(numberFloatValue))"
        }
        if sodium{
            sampleItem?.sodium = Double(numberFloatValue)
            lblSodium.text = "\(Double(numberFloatValue))"
        }
        if calcium{
            sampleItem?.calcium = Double(numberFloatValue)
            lblCalcium.text = "\(Double(numberFloatValue))"

        }
        if aluminium{
            sampleItem?.aluminium = Double(numberFloatValue)
            lblAluminium.text = "\(Double(numberFloatValue))"

        }
        if potasium{
            sampleItem?.potasium = Double(numberFloatValue)
            lblPotasium.text = "\(Double(numberFloatValue))"

        }
        if barium{
            sampleItem?.barium = Double(numberFloatValue)
            lblBarium.text = "\(Double(numberFloatValue))"

        }
        if iron{
            sampleItem?.iron = Double(numberFloatValue)
            lblIron.text = "\(Double(numberFloatValue))"

        }
        if reIn {
            sampleItem?.refractiveIndex = Double(numberFloatValue)
            lblReIn.text = "\(Double(numberFloatValue))"

        }
        //print(numberFloatValue)
        slider.value = numberFloatValue
    }
    

    
    @IBAction func btnManganese(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = false
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.manganese)!)
        lblSlider.text = sampleItem?.manganese.description
        
        manganese = true
        sodium = false
        silicon = false
        calcium = false
        aluminium = false
        potasium = false
        barium = false
        iron = false
        reIn = false
        slideLimit()
    }
    
   
    
    @IBOutlet weak var slider: UISlider!
    
    func slideLimit(){
        if manganese {
            slider.minimumValue = 0
            slider.maximumValue = 4.49
            slider.value = Float(atof(lblManganese.text!))
            
        }
        if silicon {
            slider.minimumValue = 69.81
            slider.maximumValue = 75.41
            slider.value = Float(atof(lblSilicon.text!))
        }
        if sodium {
            slider.minimumValue = 10.73
            slider.maximumValue = 17.38
            slider.value = Float(atof(lblSodium.text!))
        }
        if aluminium {
            slider.minimumValue = 0.29
            slider.maximumValue = 3.5
            slider.value = Float(atof(lblAluminium.text!))
        }
        if potasium {
            slider.minimumValue = 0
            slider.maximumValue = 6.21
            slider.value = Float(atof(lblPotasium.text!))
        }
        if calcium {
            slider.minimumValue = 5.43
            slider.maximumValue = 16.19
            slider.value = Float(atof(lblCalcium.text!))
        }
        if barium {
            slider.minimumValue = 0
            slider.maximumValue = 3.15
            slider.value = Float(atof(lblBarium.text!))
        }
        if iron {
            slider.minimumValue = 0
            slider.maximumValue = 0.51
            slider.value = Float(atof(lblIron.text!))
        }
        if reIn {
            slider.minimumValue = 1.511
            slider.maximumValue = 1.534
            slider.value = Float(atof(lblReIn.text!))
        }
        lblSlider.text! = "\(Double(slider.value))"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        lblSlider.text = sender.value.description
        //print(sender.value.description)
        if (manganese){
            lblManganese.text = sender.value.description
            sampleItem?.manganese = Double(sender.value)
        }
        if (silicon){
            lblSilicon.text = sender.value.description
            sampleItem?.silicon = Double(sender.value)
        }
        if (sodium){
            lblSodium.text = sender.value.description
            sampleItem?.sodium = Double(sender.value)
        }
        if (calcium){
            lblCalcium.text = sender.value.description
            sampleItem?.calcium = Double(sender.value)
        }
        if (aluminium){
            lblAluminium.text = sender.value.description
            sampleItem?.aluminium = Double(sender.value)
        }
        if (potasium){
            lblPotasium.text = sender.value.description
            sampleItem?.potasium = Double(sender.value)
        }
        if (barium){
            lblBarium.text = sender.value.description
            sampleItem?.barium = Double(sender.value)
        }
        if (iron){
            lblIron.text = sender.value.description
            sampleItem?.iron = Double(sender.value)
        }
        if (reIn){
            lblReIn.text = sender.value.description
            sampleItem?.refractiveIndex = Double(sender.value)
        }
        
    }

    @IBAction func btnIron(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = false
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.iron)!)
        lblSlider.text = sampleItem?.iron.description
        manganese = false
        sodium = false
        silicon = false
        calcium = false
        aluminium = false
        potasium = false
        barium = false
        iron = true
        reIn = false
        slideLimit()
    }
    
    
    @IBAction func btnBarium(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = false
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.barium)!)
        lblSlider.text = sampleItem?.barium.description
        manganese = false
        sodium = false
        silicon = false
        calcium = false
        aluminium = false
        potasium = false
        barium = true
        iron = false
        reIn = false
        slideLimit()
    }
    
    
    @IBAction func lblPotasium(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = false
        slider.value = Float((sampleItem?.potasium)!)
        lblSlider.text = sampleItem?.potasium.description
        manganese = false
        sodium = false
        silicon = false
        calcium = false
        aluminium = false
        potasium = true
        barium = false
        iron = false
        reIn = false
        slideLimit()
    }
    
    @IBAction func btnAluminium(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = false
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.aluminium)!)
        lblSlider.text = sampleItem?.aluminium.description
        manganese = false
        sodium = false
        silicon = false
        calcium = false
        aluminium = true
        potasium = false
        barium = false
        iron = false
        reIn = false
        slideLimit()
    }
    
    @IBAction func btnSilicon(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = false
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.silicon)!)
        lblSlider.text = sampleItem?.silicon.description
        manganese = false
        sodium = false
        silicon = true
        calcium = false
        aluminium = false
        potasium = false
        barium = false
        iron = false
        reIn = false
        slideLimit()
    }
    
    @IBAction func btnSodium(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = false
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.sodium)!)
        lblSlider.text = sampleItem?.sodium.description
        manganese = false
        sodium = true
        silicon = false
        calcium = false
        aluminium = false
        potasium = false
        barium = false
        iron = false
        reIn = false
        slideLimit()
    }
    
    @IBAction func btnCalcium(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = false
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = true
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.calcium)!)
        lblSlider.text = sampleItem?.calcium.description
        manganese = false
        sodium = false
        silicon = false
        calcium = true
        aluminium = false
        potasium = false
        barium = false
        iron = false
        reIn = false
        slideLimit()
    }
    
    @IBAction func btnRefraIndex(_ sender: Any) {
        btnManganeseOutlet.isHighlighted = true
        btnSiliconOutlet.isHighlighted = true
        btnIronOutlet.isHighlighted = true
        btnSodiumOutlet.isHighlighted = true
        btnCalciumOutlet.isHighlighted = true
        btnBariumOutlet.isHighlighted = true
        btnAluminiumOutlet.isHighlighted = true
        btnRefractiveOutlet.isHighlighted = false
        btnPotasiumOutlet.isHighlighted = true
        slider.value = Float((sampleItem?.refractiveIndex)!)
        lblSlider.text = sampleItem?.calcium.description
        manganese = false
        sodium = false
        silicon = false
        calcium = false
        aluminium = false
        potasium = false
        barium = false
        iron = false
        reIn = true
        slideLimit()
    }
        func showPopup(isSuccess: Bool) {
            let successMessage = "Sample was sucessfully updated."
            let errorMessage = "Something went wrong. Please try again"
            let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {action in     self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var crystalType: UILabel!
    @IBAction func crystalAlgorithm(_ sender: UIButton) {
        
        if atof(lblBarium.text!) <= 0.27 {
            //print(atof(lblBarium.text!))
            if atof(lblManganese.text!) <= 2.41 {
                //K
                //print(atof(lblManganese.text!))
                if atof(lblSodium.text!) <= 0.03 {
                    //Ri
                    //print(atof(lblSodium.text!))
                    if atof(lblReIn.text!) <= 1.52315 {
                        //print(atof(lblReIn.text!))
                        crystalType.text = "tableware"
                        sampleItem?.typeOfGlass = "tableware"

                        //tableware
                    }else{
                        crystalType.text = "build wind non-float"
                        sampleItem?.typeOfGlass = "build wind non-float"

                        //build wind non-float
                    }
                    
                }else{
                    //Al
                    if atof(lblAluminium.text!) <= 1.38 {
                        crystalType.text = "build wind non-float"
                        sampleItem?.typeOfGlass = "build wind non-float"
                        //build wind non-float
                    }else{
                        //mg
                        if atof(lblManganese.text!) <= 1.88 {
                            crystalType.text = "containers"
                            sampleItem?.typeOfGlass = "containers"

                            //containers
                        }else{
                            crystalType.text = "build wind non-float"
                            sampleItem?.typeOfGlass = "build wind non-float"

                            //build wind non-float
                        }
                    }
                }
            }else{
                //Al
                if atof(lblAluminium.text!) < 1.41 {
                    //Ri
                    if atof(lblReIn.text!) <= 1.51707 {
                        //Ri
                        if atof(lblReIn.text!) <= 1.51596 {
                            crystalType.text = "build wind non-float"
                            sampleItem?.typeOfGlass = "build wind non-float"

                            //build wind non-float
                        }else{
                            //Al
                            if atof(lblAluminium.text!) <= 1.27 {
                                //Mg
                                if atof(lblManganese.text!) <= 3.46 {
                                    crystalType.text = "vehic wind float"
                                    sampleItem?.typeOfGlass = "vehic wind float"

                                    //vehic wind float
                                }else{
                                    crystalType.text = "vehic wind non-float"
                                    sampleItem?.typeOfGlass = "vehic wind non-float"

                                    //vehic wind non-float
                                }
                            }else{
                                crystalType.text = "vehic wind float"
                                sampleItem?.typeOfGlass = "vehic wind float"

                                //vehic wind float
                            }
                        }
                    }else{
                        //K
                        if atof(lblPotasium.text!) <= 0.23 {
                            //Mg
                            if atof(lblManganese.text!) <= 3.34 {
                                crystalType.text = "build wind non-float"
                                sampleItem?.typeOfGlass = "build wind non-float"

                                //build wind non-float
                            }else{
                                //Ri
                                if atof(lblReIn.text!) <= 1.52127 {
                                    //Al
                                    if atof(lblAluminium.text!) <= 0.91 {
                                        crystalType.text = "vehic wind float"
                                        sampleItem?.typeOfGlass = "vehic wind float"

                                        //vehic wind float
                                    }else{
                                        crystalType.text = "build wind float"
                                        sampleItem?.typeOfGlass = "build wind float"

                                      
                                        //build wind float
                                    }
                                }else{
                                    crystalType.text = "build wind float"
                                    sampleItem?.typeOfGlass = "build wind float"

                                    //build wind float
                                }
                            }
                        }else{
                            //Mg
                            if atof(lblManganese.text!) <= 3.75 {
                                //Al
                                if atof(lblAluminium.text!) <= 1.16 {
                                    //Ri
                                    if atof(lblReIn.text!) <= 1.51806 {
                                        crystalType.text = "build wind float"
                                        sampleItem?.typeOfGlass = "build wind float"

                                        //build wind float
                                    }else{
                                        crystalType.text = "build wind non-float"
                                        sampleItem?.typeOfGlass = "build wind non-float"

                                        //build wind non-float
                                    }
                                }else{
                                    crystalType.text = "build wind float"
                                    sampleItem?.typeOfGlass = "build wind float"

                                    //build wind float
                                }
                            }else{
                                crystalType.text = "build wind non-float"
                                sampleItem?.typeOfGlass = "build wind non-float"

                                //build wind non-float
                            }
                        }
                    }
                }else{
                    crystalType.text = "build wind non-float"
                    sampleItem?.typeOfGlass = "build wind non-float"

                    //build wind non-float
                }
            }
        }else{
            crystalType.text = "headlamps"
            sampleItem?.typeOfGlass = "headlamps"

            //headlamps
        }
    }
    
}
