


#include "BackPropagationNeuralNet.h"

#include <stdio.h>
#include <string.h>

void NeuralNet::setSigFunc(SIG_SIGMOID sig)
{
    this->sigFunc=sig;
}


//	initializes and allocates memory on heap
NeuralNet::NeuralNet(int nl, int *sz, FP_TYPE learningRate, FP_TYPE momentum):
    learningRate(learningRate),momentum(momentum)
{
	layersCount=nl;
	lsize=new int[layersCount];
    sigFunc=SIG_TANHC;

	for(int i=0;i<layersCount;i++){
		lsize[i]=sz[i];
	}

	outputNeuron = new FP_TYPE*[layersCount];

	for(int i=0;i<layersCount;i++){
		outputNeuron[i]=new FP_TYPE[lsize[i]];
	}

	delta = new FP_TYPE*[layersCount];

	for(int i=1;i<layersCount;i++){
		delta[i]=new FP_TYPE[lsize[i]];
	}

	weight = new FP_TYPE**[layersCount];

	for(int i=1;i<layersCount;i++){
		weight[i]=new FP_TYPE*[lsize[i]];
	}
	for(int i=1;i<layersCount;i++){
		for(int j=0;j<lsize[i];j++){
			weight[i][j]=new FP_TYPE[lsize[i-1]+1];
		}
	}

	prevDwij = new FP_TYPE**[layersCount];

	for(int i=1;i<layersCount;i++){
		prevDwij[i]=new FP_TYPE*[lsize[i]];

	}
	for(int i=1;i<layersCount;i++){
		for(int j=0;j<lsize[i];j++){
			prevDwij[i][j]=new FP_TYPE[lsize[i-1]+1];
		}
	}

	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
            {
                
                FP_TYPE val=((FP_TYPE)rand()/RAND_MAX)/1.0-0.5;
                if (val < 0.0)
                    val-=0.5;
                else
                    val+=0.5;
                
                printf("%f ",val);
				weight[i][j][k]=val;
            }

	//	initialize previous weights to 0 for first iteration
	for(int i=1;i<layersCount;i++)
    {
		for(int j=0;j<lsize[i];j++)
		{
            for(int k=0;k<lsize[i-1]+1;k++)
            {
                prevDwij[i][j][k]=(FP_TYPE)0.0;
            }
        }
    }
}



NeuralNet::~NeuralNet()
{
	for(int i=0;i<layersCount;i++)
		delete[] outputNeuron[i];
	delete[] outputNeuron;

	for(int i=1;i<layersCount;i++)
		delete[] delta[i];
	delete[] delta;

	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			delete[] weight[i][j];
	for(int i=1;i<layersCount;i++)
		delete[] weight[i];
	delete[] weight;

	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			delete[] prevDwij[i][j];
	for(int i=1;i<layersCount;i++)
		delete[] prevDwij[i];
	delete[] prevDwij;

	delete[] lsize;
}


//	sigmoid function
FP_TYPE NeuralNet::sigmoid(FP_TYPE x)
{
    switch(sigFunc)
    {
        case SIG_TANH:
            return (FP_TYPE)tanh(x);
        case SIG_TANHC:
            return (FP_TYPE)1.7159 * tanh(x * 2.0/3.0);
        case SIG_EXP:
    		return (FP_TYPE)(1.0/(1.0+expf(-x)));
    }
}


FP_TYPE NeuralNet::derivateSigmoid(FP_TYPE x)
{
    switch(sigFunc)
    {
        case SIG_TANH:
            return (FP_TYPE)(1.0-x*x);
        case SIG_TANHC:
            //return (FP_TYPE)(2.0/3.0*(1.7159-x*x));
            return (FP_TYPE)(2.0/3.0 / 1.7159 * (1.7159 + x) * (1.7159 - x));
        case SIG_EXP:
    		return (FP_TYPE)(x*(1.0-x));
    }
}

//	mean square error
FP_TYPE NeuralNet::mse(FP_TYPE *tgt)
{
	FP_TYPE mse=0;
	for(int i=0;i<lsize[layersCount-1];i++){
		mse+=(tgt[i]-outputNeuron[layersCount-1][i])*(tgt[i]-outputNeuron[layersCount-1][i]);
	}
	return mse/2.0;
}


FP_TYPE NeuralNet::outValue(int i)
{
	return outputNeuron[layersCount-1][i];
}

// feed forward one set of input
void NeuralNet::feedForward(FP_TYPE *in)
{
	FP_TYPE sum;

	//	assign content to input layer
	for(int i=0;i<lsize[0];i++)
		outputNeuron[0][i]=in[i];  // output_from_neuron(i,j) Jth neuron in Ith Layer

	//	assign output(activation) value 
	for(int i=1;i<layersCount;i++){
		for(int j=0;j<lsize[i];j++){
			sum=0.0;
			for(int k=0;k<lsize[i-1];k++){		// input from each neuron in preceeding layer
				sum+= outputNeuron[i-1][k]*weight[i][j][k];	// Apply weight to inputs and add to sum
			}
			sum+=weight[i][j][lsize[i-1]];		// Apply bias
			outputNeuron[i][j]=sigmoid(sum);				// Apply sigmoid function
		}
	}
}


//	backpropogate errors from output layer to the first hidden layer
void NeuralNet::backPropagate(FP_TYPE *in,FP_TYPE *tgt)
{
	feedForward(in);

	//	calc delta for output layer
	for(int i=0;i<lsize[layersCount-1];i++)
    {
        // http://people.csail.mit.edu/acornejo/Projects/html/neuralnet.htm
        FP_TYPE v=outputNeuron[layersCount-1][i];
		delta[layersCount-1][i]=derivateSigmoid(v)*(tgt[i]-v);
	}

		
	for(int i=layersCount-2;i>0;i--)
    {
		for(int j=0;j<lsize[i];j++)
        {
			FP_TYPE sumerror=0.0;
			for(int k=0; k<lsize[i+1]; k++)
            {
				sumerror += delta[i+1][k]*weight[i+1][k][j];
			}
			delta[i][j] = derivateSigmoid(outputNeuron[i][j])*sumerror; //	delta in hidden layer
		}
	}

	
	for(int i=1;i<layersCount;i++)
    {
		for(int j=0; j<lsize[i]; j++)
        {
			for(int k=0; k<lsize[i-1]; k++)
            {
				weight[i][j][k] += momentum*prevDwij[i][j][k];
			}
			weight[i][j][lsize[i-1]] += momentum*prevDwij[i][j][lsize[i-1]];
            //	apply momentum
		}
	}

	
	for(int i=1;i<layersCount;i++)
    {
		for(int j=0;j<lsize[i];j++)
        {
			for(int k=0;k<lsize[i-1];k++)
            {
                //	adjust weights with steepest descent
				prevDwij[i][j][k]=learningRate*delta[i][j]*outputNeuron[i-1][k];
				weight[i][j][k]+=prevDwij[i][j][k];
			}
			prevDwij[i][j][lsize[i-1]]=learningRate*delta[i][j];
			weight[i][j][lsize[i-1]]+=prevDwij[i][j][lsize[i-1]];
            
            
            //delta wij(t)=decay(learningrate delta(i) Xi)+momentum * delta wij(t-1)
            // wij(t+1) = wij(t)+delta wij(t)
            
            
		}
	}
}

#pragma mark - save and load states

bool NeuralNet::saveState(char *fname)
{
	FILE *fp;
	char fname2[256];
	if (!fname)
	{
		strcpy(fname2, m_fname);
		fp=fopen(m_fname,"wb");
	}
	else
	{
		strcpy(fname2, fname);
		fp=fopen(fname,"wb");
	}
	if (!fp)
		return false;
    
	fwrite(&layersCount,1,sizeof(layersCount),fp);
	for(int i=0;i<layersCount;i++)
	{
		fwrite(&lsize[i],1,sizeof(lsize[i]),fp);
	}
	fwrite(&learningRate,1,sizeof(learningRate),fp);
	fwrite(&momentum,1,sizeof(momentum),fp);
	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
			{
				fwrite(&weight[i][j][k],1,sizeof(weight[i][j][k]),fp);
			}
    
	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
			{
				fwrite(&prevDwij[i][j][k],1,sizeof(prevDwij[i][j][k]),fp);
			}
	fclose(fp);
    
#if SAVETXT
	strcat(fname2,".txt");
	fp=fopen(fname2,"wb");
	if (!fp)
		return false;
    
	fprintf(fp,"n=%d:",layersCount);
	for(int i=0;i<layersCount;i++)
	{
		fprintf(fp,"layer %d=%d,",i,lsize[i]);
	}
	fprintf(fp,"%f,%f\n",alpha,beta);
	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
			{
				fprintf(fp,"w[%d][%d][%d]=%f\n",i,j,k,weight[i][j][k]);
			}
    
	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
			{
				fprintf(fp,"pw[%d][%d][%d]=%f\n",i,j,k,prevDwij[i][j][k]);
			}
	fclose(fp);
#endif
    
	return true;
}


bool NeuralNet::loadState(char *fname)
{
	FILE *fp;
	int numlNew;
	if (!fname)
		fp=fopen(m_fname,"rb");
	else
		fp=fopen(fname,"rb");
	if (!fp)
		return false;
    
	fread(&numlNew,1,sizeof(numlNew),fp);
	if (layersCount!=numlNew)
	{
		return false;
	}
	for(int i=0;i<layersCount;i++)
	{
		fread(&numlNew,1,sizeof(numlNew),fp);
		if (lsize[i]!=numlNew)
		{
			return false;
		}
        
	}
	fread(&learningRate,1,sizeof(learningRate),fp);
	fread(&momentum,1,sizeof(momentum),fp);
	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
			{
				fread(&weight[i][j][k],1,sizeof(weight[i][j][k]),fp);
			}
    
	for(int i=1;i<layersCount;i++)
		for(int j=0;j<lsize[i];j++)
			for(int k=0;k<lsize[i-1]+1;k++)
			{
				fread(&prevDwij[i][j][k],1,sizeof(prevDwij[i][j][k]),fp);
			}
	fclose(fp);
	return true;
}