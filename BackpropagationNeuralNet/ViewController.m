//
//  ViewController.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "ViewController.h"
#import "NeuralNetTestImage.h"


@interface ViewController ()
{
    NeuralNetTestImage *testImage;
    NeuralNetHandler *neuralNet;
    SIG_SIGMOID sigmoid;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetSimulationData:self];
    sigmoid=SIG_TANHC;
    testImage = [[NeuralNetTestImage alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    _inputNeurons.text = [NSString stringWithFormat:@"%d", _neuronsIn];
    _outputNeurons.text = [NSString stringWithFormat:@"%d", _neuronsOut];
    [_sigmoidControl setSelectedSegmentIndex:sigmoid];
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
    [neuralNet setSigmoid:sigmoid];
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
    BOOL startAction=YES;
    if (neuralNet!=nil)
    {
        if ([neuralNet isIterating])
        {
            startAction=NO;
        }
    }
    if (startAction)
    {
        [_runButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self runNet];
    }
    else
    {
        [_runButton setTitle:@"Start" forState:UIControlStateNormal];
        [neuralNet setStopNow:YES];
    }
}

- (float)clipValue:(float)value
{
    if (value < -0.5)
        return -1.0;
    if (value > 0.5)
        return 1.0;
    return 0.0;
}


-(float)distance:(CGPoint)a to:(CGPoint)to
{
    float x=(a.x-to.x);
    float y=(a.y-to.y);
    return sqrt(x*x+y*y);
}

- (float)getMinDistance:(CGPoint)pt pts:(CGPoint*)pts lastPoint:(int)lastPoint
{
    if (!lastPoint)
        return [self distance:pt to:pt];
    float minDt=[self distance:pt to:pts[0]];
    for (int i=1; i < lastPoint; i++)
    {
        float nDt=[self distance:pt to:pts[i]];
        if (nDt < minDt)
            minDt=nDt;
    }
    return minDt;
}

#define MAXPOINTS 1000

-(NSMutableString *)testSet2In1Out
{
    CGPoint points[MAXPOINTS];
    int lastPoint=0;
    NSMutableString *testData=[[NSMutableString alloc]init];
    float sine1=[_sine1Label.text floatValue];
    float sine2=[_sine2Label.text floatValue];
    BOOL clipValues=[_clipValues isOn];
    
    float facx=3.1415926535897931*sine1;
    float facy=3.1415926535897931*sine2;
    float scale=0.6;
    float yscale=0.0;
    float step=0.02;
    float a,x,y;
    for (a=-1.0; a < 1.0+step; a+=step)
    {
        x=(sin(a * facx)+yscale)/(scale*2.0);
        y=(cos(a * facy)+yscale)/(scale*2.0);
        if (clipValues)
        {
            x=[self clipValue:x];
            y=[self clipValue:y];
        }
        points[lastPoint++]=CGPointMake(x,y);
        [testData appendFormat:@"%1f,%1f,%1f\n",x,y,1.0];
    }
    // shoot and find dot's outside
    
    for (int i=0; i < 250; i++)
    {
        x=((float)rand()/RAND_MAX)*2.0-1.0;
        y=((float)rand()/RAND_MAX)*2.0-1.0;
        float delta=[self getMinDistance:CGPointMake(x,y) pts:points lastPoint:lastPoint];
        if (delta > 0.1)
        {
            points[lastPoint++]=CGPointMake(x,y);
            [testData appendFormat:@"%1f,%1f,%1f\n",x,y,-1.0];
        }
    }
    return testData;
}


- (IBAction)resetSimulationData:(id)sender {
    NSMutableString *testData=[[NSMutableString alloc]init];
    float sine1=[_sine1Label.text floatValue];
    float sine2=[_sine2Label.text floatValue];
    BOOL clipValues=[_clipValues isOn];
    
    if (_neuronsIn==2 && _neuronsOut==1)
    {
        testData = [self testSet2In1Out];
     }
    if (_neuronsIn==1 && _neuronsOut==2)
    {
        float facx=3.1415926535897931*sine1;
        float facy=3.1415926535897931*sine2;
        float scale=0.6;
        float yscale=0.0;
        float step=0.1;
        float a,x,y;
        for (a=-1.0; a < 1.0+step; a+=step)
        {
            x=(sin(a * facx)+yscale)/(scale*2.0);
            y=(cos(a * facy)+yscale)/(scale*2.0);
            if (clipValues)
            {
	            x=[self clipValue:x];
    	        y=[self clipValue:y];
            }
            [testData appendFormat:@"%1f,%1f,%1f\n",a,x,y];
        }
    }
    if (_neuronsIn==1 && _neuronsOut==1)
    {
        float facx=3.1415926535897931*sine1;
        float scale=0.6;
        float yscale=0.0;
        float step=0.1;
        float a,x;
        for (a=-1.0; a < 1.0+step; a+=step)
        {
            x=(sin(a * facx)+yscale)/(scale*2.0);
            if (clipValues)
	            x=[self clipValue:x];
            [testData appendFormat:@"%1f,%1f\n",a,x];
        }
    }
    _dataSet.text=testData;
    
}

- (IBAction)sigmoidSelect:(id)sender {
    sigmoid=_sigmoidControl.selectedSegmentIndex;
}

@end
