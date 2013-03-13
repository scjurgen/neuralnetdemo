//
//  ViewController.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "ViewController.h"
#import "NeuralNetTestImage.h"
#import "../testset/testset.h"


@interface ViewController ()
{
    NeuralNetTestImage *testImage;
    NeuralNetHandler *neuralNet;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSet.text = TESTSET;
    testImage = [[NeuralNetTestImage alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)fillLayers:(NSString*)compositionAsText layers:(NSInteger*)layers
{
    NSString *pattern=@"([0-9]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * results=[regex matchesInString:compositionAsText options:NSMatchingReportCompletion range:NSMakeRange(0,[compositionAsText length])];
    int layerIndex=1;
    layers[0]=1;
    for (NSTextCheckingResult *match in results)
    {
        int cnt=[[compositionAsText substringWithRange:[match rangeAtIndex:1]] integerValue];
        layers[layerIndex++]=cnt;
        NSLog(@"%d",cnt);
    }
    layers[layerIndex++]=1; // 1 output
    layers[layerIndex++]=0; // terminal
    return layerIndex>3;
}

- (void)runNet
{
    NSInteger layers[10];
    int inputNeurons = [_inputNeurons.text integerValue];
    int outputNeurons = [_outputNeurons.text integerValue];
    neuralNet=nil;
    [self fillLayers:_layersComposition.text layers:layers];
    neuralNet = [[NeuralNetHandler alloc]initWithLayers:layers];
    [neuralNet initTrainDataSet:_dataSet.text inputNeurons:inputNeurons outputNeurons:outputNeurons];
    [neuralNet setLearningRate:[_learningRate.text floatValue]];
    [neuralNet setMomentum:[_momentum.text floatValue]];
    [neuralNet setRandomSeed:[_randomSeed.text integerValue]];
    neuralNet.delegate=self;
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0);
    dispatch_async(queue, ^{
        [neuralNet train];
    });
}

#pragma mark - Neural Net delegate

- (void)showProgress:(CGFloat)errorValue iterations:(NSInteger)iterations
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _errorLevel.text=[NSString stringWithFormat:@"%f",errorValue];
        _iterations.text=[NSString stringWithFormat:@"%d",iterations];
    });
}

-(void)showTestResult:(NSString*)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _testResult.text=data;
    });
}

- (void)showAsImage:(NeuralNetHandler *)nnh
{
    // this is critical, getTestImage must not run on a different thread while training is running,
    // so we aquire the image on the training thraed and hand it over to main
    UIImage *image=[testImage getTestImage:nnh];
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageTest.image=image;
    });
}


- (IBAction)runAction:(id)sender {
    [self runNet];
    
}
@end
