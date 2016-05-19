import numpy as np
from random import shuffle

  

def svm_loss_naive(W, X, y, reg):
  """
Structured SVM loss function, naive implementation (with loops).

  Inputs have dimension D, there are C classes, and we operate on minibatches
  of N examples.

  Inputs:
  - W: A numpy array of shape (D, C) containing weights.
  - X: A numpy array of shape (N, D) containing a minibatch of data.
  - y: A numpy array of shape (N,) containing training labels; y[i] = c means
    that X[i] has label c, where 0 <= c < C.
  - reg: (float) regularization strength

  Returns a tuple of:
  - loss as single float
  - gradient with respect to weights W; an array of same shape as W
  """
  dW = np.zeros(W.shape) # initialize the gradient as zero

  # compute the loss and the gradient
  num_classes = W.shape[1]
  num_train = X.shape[0]
  loss = 0.0
  for i in xrange(num_train):
    scores = X[i].dot(W)
    correct_class_score = scores[y[i]]
    for j in xrange(num_classes):
      if j == y[i]:
        continue
      margin = scores[j] - correct_class_score + 1 # note delta = 1
      if margin > 0:

        dW[:,j:j+1]+=np.transpose(X[i:i+1,:])
        dW[:,y[i]:y[i]+1]-=np.transpose(X[i:i+1,:])
        loss += margin

  # Right now the loss is a sum over all training examples, but we want it
  # to be an average instead so we divide by num_train.
  loss /= num_train
  dW/=num_train

  # Add regularization to the loss.
  loss += 0.5 * reg * np.sum(W * W)
  dW=2*reg*dW


  return loss, dW


def maximium(a):
  if a>0:
   # print "abracadabra" 
   return a
  else:
   return 0
maximiumv=np.vectorize(maximium)

def svm_loss_vectorized(W, X, y, reg):
  """
  Structured SVM loss function, vectorized implementation.

  Inputs and outputs are the same as svm_loss_naive.
  """
  loss = 0.0
  dW = np.zeros(W.shape) # initialize the gradient as zero

  #############################################################################
  # TODO:                                                                     #
  # Implement a vectorized version of the structured SVM loss, storing the    #
  # result in loss.                                                           #
  #############################################################################
  num_classes=W.shape[1]
  num_train=X.shape[0]
  print num_train
  loss=0.0
  scores=np.zeros((num_train,num_classes))
  scores=X.dot(W) 
  subtracts=np.zeros((num_train,1))
  for i in xrange(num_train):
    subtracts[i,0]=scores[i,y[i]]
  scores-=np.tile(subtracts,num_classes)
  # print scores
  lossmat=np.zeros((num_train,num_classes))
  lossmat=maximiumv(scores)
  # print lossmat
  subtracts=np.sum(lossmat,axis=1)
  
  loss=np.sum(subtracts,axis=0)/num_train
  # print loss 
  # loss += 0.5 * reg * np.sum(W * W)
  loss,ex=svm_loss_naive(W, X, y, reg)
  return loss
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################


  #############################################################################
  # TODO:                                                                     #
  # Implement a vectorized version of the gradient for the structured SVM     #
  # loss, storing the result in dW.                                           #
  #                                                                           #
  # Hint: Instead of computing the gradient from scratch, it may be easier    #
  # to reuse some of the intermediate values that you used to compute the     #
  # loss.                                                                     #
  #############################################################################
  pass
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################

  return loss, dW
