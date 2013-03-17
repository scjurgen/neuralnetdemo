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
@property (assign,atomic) NSUInteger neuronsIn;
@property (assign,atomic) NSUInteger neuronsOut;

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
@property (weak, nonatomic) IBOutlet UITextField *sine1Label;
@property (weak, nonatomic) IBOutlet UITextField *sine2Label;
@property (weak, nonatomic) IBOutlet UISwitch *clipValues;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sigmoidControl;
- (IBAction)sigmoidSelect:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *runButton;
- (IBAction)resetSimulationData:(id)sender;
- (IBAction)runAction:(id)sender;

@end
