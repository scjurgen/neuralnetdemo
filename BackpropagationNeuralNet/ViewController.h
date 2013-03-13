//
//  ViewController.h
//  BackpropagationNeuralNet
//
//  Created by jay on 2/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeuralNetHandler.h"

@interface ViewController : UIViewController <NeuralNetHandlerProtocol>
- (IBAction)runAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *errorLevel;
@property (weak, nonatomic) IBOutlet UILabel *iterations;
@property (weak, nonatomic) IBOutlet UITextField *layersComposition;
@property (weak, nonatomic) IBOutlet UITextField *learningRate;
@property (weak, nonatomic) IBOutlet UITextField *momentum;
@property (weak, nonatomic) IBOutlet UITextView *testResult;
@property (weak, nonatomic) IBOutlet UIImageView *imageTest;
@property (weak, nonatomic) IBOutlet UITextField *randomSeed;
@property (weak, nonatomic) IBOutlet UITextView *dataSet;
@property (weak, nonatomic) IBOutlet UIImageView *inputSetImage;
@property (weak, nonatomic) IBOutlet UITextField *inputNeurons;
@property (weak, nonatomic) IBOutlet UITextField *outputNeurons;

@end
