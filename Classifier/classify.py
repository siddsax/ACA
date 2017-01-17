#code not written by me only understood the algo working behind it


class Classifier(object):
    def __init__(self):
        # ``defaultdict`` is an optimized dictionary-like object that
        # allows us to specify a default value when a key is accessed
        # that has not been previously set.
 
        self.features = defaultdict(int)
        self.labels = defaultdict(int)
        self.feature_counts = defaultdict(lambda: defaultdict(int))
        self.total_count = 0

####   Now we need to build the training method. This will simply update the counts of various items:        
    def train(self, features, labels):
    # what labels are these features associated with?
    for label in labels:
        # update the count of each feature for the given label
        for feature in features:
            self.feature_counts[feature][label] += 1
            self.features[feature] += 1
 
        # update the count of documents associated with this label
        self.labels[label] += 1
       
    # update the total count of documents processed
    self.total_count += 1
##### Believe it or not, the above is all the code we need to start training our classifier! Of course, we’re not done yet — we need to write the code to classify
##### new documents. Let’s start plugging the training data into some methods we can use to classify documents. Looking back at the formula we used 
##### to calculate the likelihood “money” indicated a spam document, let’s try to generate that with python:    
    def feature_probability(self, feature, label):
    # get the count of this feature in the given label, this would
    # be "25" for "money"/"spam", or "5" for "money"/"ham"
    feature_count = self.feature_counts[feature][label]
 
    # get the count of documents with this label (e.g. 100)
    label_count = self.labels[label]
 
    if feature_count and label_count:
        # divide by the count of all features in the given category
        return float(feature_count) / label_count
    return 0
 
    def weighted_probability(self, feature, label, weight=1.0, ap=0.5):
       # calculate the "initial" probability that the given feature will
       # appear in the label -- this is .25 for "money"/"spam"
       initial_prob = self.feature_probability(feature, label)
 
       # sum the counts of this feature across all labels -- e.g.,
       # how many times overall does the word "money" appear? (30)
       feature_total = self.features[feature]
 
       # calculate weighted avg -- this is slightly different than what
       # we did in the above example and helps give a more evenly
       # weighted result and prevents us returning "0"
       return float((weight * ap) + (feature_total * initial_prob)) / (weight + feature_total)
##### The above “weighted_probability” function allows us to calculate the probability that a feature is associated with a given label. Now it will get more interesting 
##### as we will be calculating  the probability that a set of features matches a label. To calculate this, simply multiply together all the probabilities of the individual features:    
def document_probability(self, features, label):
    # calculate the probability these features match the label
    p = 1
    for feature in features:
        p *= self.weighted_probability(feature, label)
    return p
##### The final step is to weight the probabilities of the individual features by the overall probability that a document has a given label.

 def probability(self, features, label):
    if not self.total_count:
        # avoid doing a divide by zero
        return 0
 
    # calculate the probability that a document will have the given
    # label -- in our example this is (100 / 200)
    label_prob = float(self.labels[label]) / self.total_count
 
    # get the probabilities of each feature for the given label
    doc_prob = self.document_probability(features, label)
 
    # weight the document probability by the label probability
    return doc_prob * label_prob
##### Now we can write a method to classify a set of features. This will calculate the probability for each label (i.e., the probability for spam and ham) 
##### and then return them sorted so the best match is first:

def classify(self, features, limit=5):
    # calculate the probability for each label
    probs = {}
    for label in self.labels.keys():
        probs[label] = self.probability(features, label)
 
    # sort the results so the highest probabilities come first
    return sorted(probs.items(), key=lambda (k,v): v, reverse=True)[:limit]
