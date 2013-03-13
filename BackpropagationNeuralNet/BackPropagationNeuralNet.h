
#ifndef BackPropagationNeuralNet_h
#define BackPropagationNeuralNet_h

#include <assert.h>
#include <math.h>



class NeuralNet{

    //	output neurons
	FP_TYPE **outputNeuron;

    //	delta error values of neurons
	FP_TYPE **delta;

    //	weights[] for each neuron
	FP_TYPE ***weight;

    //	layers (input layer too)
	int layersCount;
    
    //	vector of layersCount elements for size of each layer
	int *lsize;

    
    //	learning rate
	FP_TYPE learningRate;

    //	momentum parameter
	FP_TYPE momentum;
    //	storage for weight-change made
    //	in previous epoch
	FP_TYPE ***prevDwt;

	FP_TYPE sigmoid(FP_TYPE in);
    FP_TYPE derivateSigmoid(FP_TYPE in);
    char *m_fname;

public:

	~NeuralNet();
	NeuralNet(int nl,int *sz,FP_TYPE b,FP_TYPE a);

	void backPropagate(FP_TYPE *in,FP_TYPE *tgt);
	void feedForward(FP_TYPE *in);

	FP_TYPE mse(FP_TYPE *tgt);
	FP_TYPE outValue(int i);
    
    bool saveState(char *fname=NULL);
    bool loadState(char *fname);


};

#endif