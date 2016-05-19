import numpy as np 
import random

# file=open("data")
# text=file.read()

def sigmoid(z):
	return 1/(1+np.exp(-z))
def sigmoidprime(z):
	return sigmoid(z)*(1-sigmoid(z))

inputs=np.array([[0,0,1],
                [0,1,1],
                [1,0,1],
                [1,1,1]] )
results=np.array([[0,0,1,1]]).T
weights=np.random.randn(3,1)

# biases=np.random.randn(1,1)
eta=.1
for epoch in xrange(10):	

		output=sigmoid(np.dot(inputs,weights))
		# print "1"
		# print output
		delta_weight=np.dot(inputs.T,(results-output)*sigmoidprime(output))
		print weights
		print delta_weight
		# print "2"
		# print delta_weight
		# print [np.transpose(activation)]
		# delta_bias=np.random.randn(1,1)
		# delta_weight,delta_bias=backprop(activation)
		weights = weights-np.dot(delta_weight,eta)
		output = sigmoid(np.dot(inputs,weights))	
		print "{0} epochs done and result is {1}".format(epoch,output)
		# print "3"
		# print weights
		# print delta_weight
        # biases=[bias-eta*delta_bias for bias in biases]
        # 
        # print "{0} epochs done and result is {1}".format(epoch,output)






