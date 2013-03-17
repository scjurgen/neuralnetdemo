
#ifndef BackPropagationNeuralNet_h
#define BackPropagationNeuralNet_h

#include <assert.h>
#include <math.h>
#include "sigmoids.h"


class NeuralNet{
	FP_TYPE **outputNeuron;
	FP_TYPE **delta;//	delta error values of neurons
	FP_TYPE ***weight;

    
	int layersCount; //	input layer too
    
    
	int *lsize; //	layersCount elements for size of each layer

	FP_TYPE learningRate;
	FP_TYPE momentum;
	FP_TYPE ***prevDwij; //	storage for weight-change made in previous epoch
    
    FP_TYPE sigmoid(FP_TYPE in);
    FP_TYPE derivateSigmoid(FP_TYPE in);

    char *m_fname; // filename for trained data
    SIG_SIGMOID sigFunc;

public:

	~NeuralNet();
	NeuralNet(int nl,int *sz,FP_TYPE b,FP_TYPE a);

	void backPropagate(FP_TYPE *in,FP_TYPE *tgt);
	void feedForward(FP_TYPE *in);
	
	FP_TYPE mse(FP_TYPE *tgt);
	FP_TYPE outValue(int i);
    
    bool saveState(char *fname=NULL);
    bool loadState(char *fname);
	void setSigFunc(SIG_SIGMOID sig);

};

#endif