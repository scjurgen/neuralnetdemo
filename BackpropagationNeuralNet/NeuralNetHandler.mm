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


#define MAXLAYERS 6


@interface NeuralNetHandler()
{
    NSInteger layersCount;
    NSInteger realLayers[MAXLAYERS];
    BOOL stopNow;
    BOOL isIterating;
    NeuralNet *neuralNet;
}

@end

@implementation NeuralNetHandler

- (id)initWithLayers:(NSInteger *)layers
{
    self = [super self];
    if (self)
    {
        _learningRate = 0.25;
        _momentum = 0.1;
        _threshold =  0.0000000001;
        _randomSeed = 5;
        _maximumIterations = 100000000;
        for (layersCount=0; layers[layersCount]; layersCount++)
        {
            realLayers[layersCount]=layers[layersCount];
            NSLog(@"%d %d", layersCount,layers[layersCount]);
        }
        isIterating=NO;
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
    if (isIterating)
    {
        stopNow=YES;
        while (isIterating)
        {
            sleep(1);
        }
        delete neuralNet;
    }
}


- (void)showTest
{
    NSString *res=@"Results:\n";
    for (int j = 0; j < _testDataSet.setsCount; j++)
    {
        neuralNet->feedForward([_testDataSet dataToInputSet:j]);
        res = [res stringByAppendingFormat:@"%4d\t%.3f %%\n",j+1, 100.0*fabs([_testDataSet dataToOutputSet:j][0]-neuralNet->outValue(0))];
        NSLog(@"error on train: %.4f", fabs([_testDataSet dataToOutputSet:j][0]-neuralNet->outValue(0)));
    }
    [self.delegate showTestResult:res];
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
    isIterating=YES;
    long i;
	for (i=0; i<_maximumIterations; i++)
	{
        int idx=rand()%[_trainDataSet setsCount];
        if (stopNow)
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
                showTime=CACurrentMediaTime()+.2;
                iterationDelta = i-lastDelta;
                lastDelta=i;
                testResultShow++;
                if (testResultShow%2==0)
                {
                    if (!stopNow)
                    {
                        [self showTest];
                        [self.delegate showAsImage:self];
                    }
                }
            }
        }
	}
	if (!stopNow)
    {
        [self showTest];
    }
    isIterating=NO;
}

@end
