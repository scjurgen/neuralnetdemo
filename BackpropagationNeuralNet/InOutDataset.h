//
//  InOutDataset.h
//  BackpropagationNeuralNet
//
//  Created by jay on 2/12/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <Foundation/Foundation.h>

// flyweight handling of data (expect some C-code)

@interface InOutDataset:NSObject

@property (atomic,assign) NSInteger inputNeurons;
@property (atomic,assign) NSInteger outputNeurons;
@property (atomic,assign) NSInteger setsCount;
@property (atomic,assign) float *dataSet;

- (id)initWithCSVString:(const char *)csvdata inputNeurons:(NSInteger)inputNeurons outputNeurons:(NSInteger)outputNeurons;

-(float *)dataToInputSet:(NSInteger)set;
-(float *)dataToOutputSet:(NSInteger)set;

@end