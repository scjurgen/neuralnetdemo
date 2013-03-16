//
//  NeuralNet.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "NeuralNetHandler.h"
#import "BackPropagationNeuralNet.h"
#include <time.h>

#define SECONDSWAIT .05
#define MAXLAYERS 6


@interface NeuralNetHandler()
{
    NSInteger layersCount;
    NSInteger realLayers[MAXLAYERS];
    NeuralNet *neuralNet;
}

@end

@implementation NeuralNetHandler

- (id)initWithLayers:(NSInteger *)layers
{
    self = [super self];
    if (self)
    {
        _learningRate = 0.125;
        _momentum = 0.1;
        _threshold =  0.0000000001;
        _randomSeed = 5;
        _maximumIterations = 100000000;
        for (layersCount=0; layers[layersCount]; layersCount++)
        {
            realLayers[layersCount]=layers[layersCount];
            NSLog(@"%d %d", layersCount,layers[layersCount]);
        }
        _isIterating=NO;
    }
    return self;
}

- (void)initTrainDataSet:(NSString *)csvString inputNeurons:(NSInteger)inputNeurons outputNeurons:(NSInteger)outputNeurons
{
    _trainDataSet = [[InOutDataset alloc] initWithCSVString:[csvString UTF8String] inputNeurons:inputNeurons outputNeurons:outputNeurons];
    realLayers[0]=_trainDataSet.inputNeurons;
    realLayers[layersCount-1]=_trainDataSet.outputNeurons;
    realLayers[layersCount]=0;
}

- (void)initTestDataSet:(NSString *)csvString inputNeurons:(NSInteger)inputNeurons outputNeurons:(NSInteger)outputNeurons
{
    _testDataSet = [[InOutDataset alloc] initWithCSVString:[csvString UTF8String] inputNeurons:inputNeurons outputNeurons:outputNeurons];
}

- (void)dealloc
{
    if (_isIterating)
    {
        _stopNow=YES;
        while (_isIterating)
        {
            sleep(1);
        }
        delete neuralNet;
    }
}


- (void)initializeNeuralNet
{
    if (neuralNet)
        delete neuralNet;
    neuralNet = new NeuralNet(layersCount, realLayers, _learningRate, _momentum);
}


- (void)feedForward:(FP_TYPE *)inData
{
    neuralNet->feedForward(inData);
}


- (FP_TYPE)outValue:(NSInteger)neuron
{
    return neuralNet->outValue(neuron);
}


- (FP_TYPE)currentError
{
    FP_TYPE error=0.0;
    for (int j = 0; j < _trainDataSet.setsCount; j++)
    {
        neuralNet->feedForward([_trainDataSet dataToInputSet:j]);
        for (int n=0; n < [[self trainDataSet] outputNeurons];n++)
            error+=fabs([_trainDataSet dataToOutputSet:j][n]-neuralNet->outValue(n));
    }
    return error/(FP_TYPE)_trainDataSet.setsCount/(FP_TYPE)[[self trainDataSet] outputNeurons];
}

- (void)train
{
    
    if (!neuralNet)
        [self initializeNeuralNet];
    if (_trainDataSet==nil)
        return;
    int testResultShow=0;
    long iterationDelta=10,lastDelta=0; // guess values for interface update, timer check will be 10th of the estimated time
    srand(_randomSeed);
    
	CFTimeInterval showTime=CACurrentMediaTime();
    _isIterating=YES;
    long i;
	for (i=0; i<_maximumIterations; i++)
	{
        int idx=rand()%[_trainDataSet setsCount];
        if (_stopNow)
        {
            break;
        }
		neuralNet->backPropagate([_trainDataSet dataToInputSet:idx], [_trainDataSet dataToOutputSet:idx]);
        
        
		if ( i%(iterationDelta/2+1) == 0 ) // don't bug to often about showing data
        {
            //if( _neuralNet->mse(trainDataOut[i%testItems]) < _threshold) {
            //    NSLog(@" Network Trained. threshold value achieved in %ld  iterations. MSE=%f",i,_neuralNet->mse(trainDataOut[i%testItems]));
            //    break;
            //}
            if (CACurrentMediaTime() >= showTime)
            {
                [_delegate showProgress:[self currentError] iterations:i];
                showTime=CACurrentMediaTime()+SECONDSWAIT;
                iterationDelta = i-lastDelta;
                lastDelta=i;
                testResultShow++;
                if (testResultShow%2==0)
                {
                    if (!_stopNow)
                    {
                        
                        [self.delegate showAsImage:self];
                    }
                }
            }
        }
	}
    _isIterating=NO;
}

@end
