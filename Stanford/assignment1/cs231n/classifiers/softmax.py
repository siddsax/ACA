import numpy as np
from random import shuffle

def softmax_loss_naive(W, X, y, reg):
  """
  Softmax loss function, naive implementation (with loops)

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
  # Initialize the loss and gradient to zero.
  loss = 0.0
  dW = np.zeros_like(W)
  scores=X.dot(W)
  #############################################################################
  # TODO: Compute the softmax loss and its gradient using explicit loops.     #
  # Store the loss in loss and the gradient in dW. If you are not careful     #
  # here, it is easy to run into numeric instability. Don't forget the        #
  # regularization!                                                           #
  #############################################################################
  num_classes=W.shape[1]
  num_train=X.shape[0]
  losses=np.zeros((num_train,1))
  for i in xrange(num_train):
    losses[i,0]= np.exp((scores[i,y[i]])-np.max(scores[i:i+1,:]))/np.sum(np.exp(scores[i:i+1,:]-np.tile(np.max(scores[i:i+1,:]),num_classes)))    
    for k in xrange(num_classes):
      if k==i:
        dW[:,y[i]:y[i]+1]+=np.exp(scores[i,y[i]])*((np.sum(np.exp(scores[i:i+1,:])))-np.exp(scores[i,y[i]]))*np.transpose(X[i:i+1,:])/np.square(np.sum(np.exp(scores[i:i+1,:])))
      else:
        dW[:,k:k+1]-=np.exp(scores[i,k])*np.transpose(X[i:i+1,:])/np.square(np.sum(np.exp(scores[i:i+1,:])))
  loss=-np.log(np.sum(losses,axis=0)/num_train)
  
  #############################################################################
  #                          END OF YOUR CODE                                 #
  #############################################################################

  return loss, dW


def softmax_loss_vectorized(W, X, y, reg):
  """
  Softmax loss function, vectorized version.

  Inputs and outputs are the same as softmax_loss_naive.
  """
  # Initialize the loss and gradient to zero.
  loss = 0.0
  dW = np.zeros_like(W)

  #############################################################################
  # TODO: Compute the softmax loss and its gradient using no explicit loops.  #
  # Store the loss in loss and the gradient in dW. If you are not careful     #
  # here, it is easy to run into numeric instability. Don't forget the        #
  # regularization!                                                           #
  #############################################################################
  pass
  #############################################################################
  #                          END OF YOUR CODE                                 #
  #############################################################################

  return loss, dW

