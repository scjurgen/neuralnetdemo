neuralnetdemo
=============

Small test programm to run a set of neural nets using backpropagation with momentum (no decay used). See also
http://people.csail.mit.edu/acornejo/Projects/html/neuralnet.htm 
for some background information.

The programme serves essential a feeling for creating neural nets. 



There are 3 different kinds with different representation which you can access on the iPad by swiping to the right or pressing the menu button).

You can generate testdata by using a simple sine generator creating a simple wave or in the 2-dimensional case a starting lissajous pattern.
The higher the values of the sine generator the more 'chaotic' the training points. 
The more chaotic the more neurons you will need to match the pattern.
You can edit also the points (I would consider pasting though ;-) ).

##Tweaking a net

You can try several things. 
* when patterns are more complex (strong local minimas and maximas) you might need more cells and even more layers.
* if the net does not converge even a simple change of the random seed can change the behaviour, especially when you have many local max and minima.
* learning rate: try lower values (from like 0.2 to 0.001)
* momentum: try lower values (like 0.1 until 0)
* don't exagerate with cell count, too many cells and the system will never converge


##1 input, 1 output
 ### space
 a single input from -1 to 1 (x) will drive the y coordinate
  ### testset
a very simple sine. please note that you can clip the values to get a kind of binary response. This usually requires fine-tuning for the count of layers and number of cells (first increase cells, then try layers).
 
 ![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/exampleset1in1out.png)
 
 

##1 input, 2 output
 ### space
 a single input from -1 to 1 will drive the coordinates of the 2 output cells interpreted as x,y screen positions.
 ### testset
 Lissajous pattern by mapping i -> [x,y]=[sin(i*f),cos(i*g)]
 ![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/example2set1in2out.png)
 

##2 input neuros, 1 output neuron
 ### space
The image generated iterates over all x,y [-1...1][-1....1] and representing the neurons output  (from -1=red to 1=green)
### testset
The lissajous pattern created by the sines will generate the +1 training value. By 'shooting' on the test values we determine negative (-1) values if they are not near eachother (delta >0.15)


![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/exampleset2in1out.png)
![ScreenShot](https://raw.github.com/scjurgen/neuralnetdemo/master/exampleset2in1out_v.png)
 
