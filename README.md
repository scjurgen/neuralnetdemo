neuralnetdemo
=============

Small test programm to test a set of neural nets using Backpropagation with momentum (no decay used).

The programme serves to get a feeling for neural nets. 

There are 3 different kinds with different representation which you can access on the iPad by swiping to the right or pressing the menu button)


All generate testdata by using a simple sine generator generating a simple wave or in the 2-dimensional case a starting lissajous pattern.
The higher the values of the sine generator the more 'chaotic' the training points. 
The more chaotic the more neurons you will need to match the pattern.




2 input neuros, 1 output neuron (from -1=red to 1=green)

The lissajous pattern generates a +1 value. by shooting on the test values we determine negative values if they are not near eachother (delta >0.15)

![ScreenShot](
https://raw.github.com/scjurgen/neuralnetdemo/master/iOS%20Simulator%20Screen%20shot%20Mar%2017,%202013%204.30.38%20PM.png
)
 
