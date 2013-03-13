//
//  NeuralNet.h
//  BackpropagationNeuralNet
//
//  Created by jay on 2/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BackPropagationNeuralNet.h"
#import "InOutDataset.h"

@class NeuralNetHandler;

@protocol NeuralNetHandlerProtocol <NSObject>

-(void)showProgress:(CGFloat)errorValue iterations:(NSInteger)iterations;
-(void)showTestResult:(NSString*)data;
-(void)showAsImage:(NeuralNetHandler *)nnh;
@end


@interface NeuralNetHandler : NSObject
@property (strong,nonatomic) id <NeuralNetHandlerProtocol> delegate;
@property (atomic) CGFloat learningRate;
@property (atomic) CGFloat momentum;
@property (atomic) CGFloat threshold;
@property (atomic) CGFloat maximumIterations;
@property (atomic) NSInteger randomSeed;

@property (nonatomic,strong) InOutDataset *trainDataSet;
@property (nonatomic,strong) InOutDataset *testDataSet;


- (id)initWithLayers:(NSInteger *)layout;
- (void)initTrainDataSet:(NSString *)csvString inputNeurons:(NSInteger)inputNeurons outputNeurons:(NSInteger)outputNeurons;
- (void)initTestDataSet:(NSString *)csvString inputNeurons:(NSInteger)inputNeurons outputNeurons:(NSInteger)outputNeurons;

- (void)train;
- (void)feedForward:(FP_TYPE *)inData;
- (FP_TYPE)outValue:(NSInteger)neuron;

@end
