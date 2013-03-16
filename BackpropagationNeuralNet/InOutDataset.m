//
//  InOutDataset.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/12/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "InOutDataset.h"




@implementation InOutDataset

- (id)initWithCSVString:(const char *)csvdata inputNeurons:(NSInteger)inputNeurons outputNeurons:(NSInteger)outputNeurons
{
    self = [super self];
    if (self)
    {
        _dataSet=nil;
        _setsCount=0;
        int itemsPerRow=1; // newline counts as 1 data item
        for (int i=0; csvdata[i];i++)
        {
            if ((csvdata[i]==',')||
                (csvdata[i]==';')||
                (csvdata[i]==':')||
                (csvdata[i]=='\t')
                )
                itemsPerRow++;
            if (csvdata[i]=='\n')
            {
                break;
            }
        }
        _inputNeurons = inputNeurons;
        _outputNeurons = outputNeurons;
        if (itemsPerRow != inputNeurons+outputNeurons)
        {
            NSString *msg = [NSString stringWithFormat:@"Neurons count doesn't match input/output: %d != %d+%d",itemsPerRow,inputNeurons,outputNeurons];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"configuration error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return nil;
        }
        
        
        for (int i=0; csvdata[i];i++)
        {
            if (csvdata[i]=='\n')
                _setsCount++;
        }
        if (_setsCount)
        {
            int columnCount=0;
            _dataSet=(float*)malloc(sizeof(float)*_setsCount*(inputNeurons+outputNeurons));
            char value[256];
            int valPos=0;
            value[0]=0;
            int dataSetPos=0;
            for (int i=0; csvdata[i];i++)
            {
                switch(csvdata[i])
                {
                        case '-':
                    case '0':
                    case '1':
                    case '2':
                    case '3':
                    case '4':
                    case '5':
                    case '6':
                    case '7':
                    case '8':
                    case '9':
                    case '.':
                        value[valPos++]=csvdata[i];
                        value[valPos]=0;
                        break;
                    case ' ':
                        break;
                    case '\n':
                        columnCount++;
                        _dataSet[dataSetPos++]=atof(value);
                        valPos = 0;
                        if (columnCount!=itemsPerRow)
                        {
                            NSAssert1(0,@"Data array is not consistent,columns = %d", columnCount);
                        }
                        columnCount=0;
                        break;
                    case '\t':
                    case ',':
                    case ';':
                    case ':':
                        columnCount++;
                        _dataSet[dataSetPos++]=atof(value);
                        valPos = 0;
                        break;
                }
            }
        }
    }
    return self;
}

-(float *)dataToInputSet:(NSInteger)set
{
    return &_dataSet[set*(_inputNeurons+_outputNeurons)];
}


-(float *)dataToOutputSet:(NSInteger)set
{
    return &_dataSet[set*(_inputNeurons+_outputNeurons)+_inputNeurons];
}


- (void)dealloc
{
    if (_dataSet!=nil)
        free(_dataSet);
}

@end
