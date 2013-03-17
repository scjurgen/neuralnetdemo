neuralnetdemo
=============

Small test programm to test a set of neural nets using Backpropagation with momentum (no decay used).

The programme serves to get a feeling for neural nets. 

There are 3 different kinds with different representation which you can access on the iPad by swiping to the right or pressing the menu button).




All generate testdata by using a simple sine generator generating a simple wave or in the 2-dimensional case a starting lissajous pattern.
The higher the values of the sine generator the more 'chaotic' the training points. 
The more chaotic the more neurons you will need to match the pattern.


##1 input, 1 output
 a single input from -1 to 1 (x) will drive the y coordinate
 
 ![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/exampleset1in1out.png)
 
 

##1 input, 2 output
 a single input from -1 to 1 will drive the coordinates of the 2 output cells interpreted as x,y screen positions.
 ![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/example2set1in2out.png)
 

##2 input neuros, 1 output neuron

The lissajous pattern created by the sines will generate the +1 training value. By 'shooting' on the test values we determine negative (-1) values if they are not near eachother (delta >0.15)

The image generated iterates over all x,y [-1...1][-1....1] and representing the neurons output  (from -1=red to 1=green)

![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/exampleset2in1out.png)
![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/exampleset2in1out_v.png)
 
