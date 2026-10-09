Experiment 10: Probabilistic Classification using Bayesian Learning
Aim
To implement Probabilistic Classification using the Gaussian Naive Bayes Algorithm on the Diabetes Dataset and predict whether a patient is diabetic or non-diabetic.

Software Required
Python 3.x
Pandas
NumPy
Matplotlib
Seaborn
Scikit-learn
Libraries Used
import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB

from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
Theory
What is Bayesian Learning?
Bayesian Learning is a probabilistic machine learning approach based on Bayes' Theorem. It uses prior knowledge and observed evidence to calculate the probability of an event.

Bayes' Theorem:

Where:

Term	Meaning
P(A)	Prior Probability
P(B)	Evidence Probability
P(B	A)
P(A	B)
What is Naive Bayes?
Naive Bayes is a supervised classification algorithm based on Bayes' Theorem.

It is called "Naive" because it assumes that all features are independent of each other.

Despite this assumption, it performs remarkably well on many real-world classification problems.

Objectives
Load and explore the Diabetes Dataset.
Visualize important medical features.
Split the dataset into training and testing sets.
Train a Gaussian Naive Bayes classifier.
Predict diabetic outcomes.
Evaluate model performance.
Analyze probability-based predictions.
Dataset Description
The Diabetes Dataset contains medical information used to predict diabetes.

Features
Feature	Description
Pregnancies	Number of pregnancies
Glucose	Blood glucose level
BloodPressure	Blood pressure
SkinThickness	Skin fold thickness
Insulin	Insulin level
BMI	Body Mass Index
DiabetesPedigreeFunction	Diabetes inheritance score
Age	Age of patient
Outcome	0 = Non-Diabetic, 1 = Diabetic
Methodology
Step 1: Load Dataset
Read the dataset from the local system.

path = r"C:\Users\rjesh\diabetes.csv"

df = pd.read_csv(path)

print(df.head())
Step 2: Explore Dataset
Display dataset dimensions.

print(df.shape)
Display column names.

print(df.columns)
Display dataset information.

print(df.info())
Observation
Dataset contains medical records.
Outcome is the target variable.
Most attributes are numerical.
Step 3: Data Visualization
Glucose Distribution
sns.histplot(
    df['Glucose'],
    bins=30,
    kde=True
)
Observation
Shows the distribution of blood glucose levels among patients.

BMI Distribution
sns.histplot(
    df['BMI'],
    bins=30,
    kde=True
)
Observation
Displays body mass index distribution.

Age Distribution
sns.histplot(
    df['Age'],
    bins=30,
    kde=True
)
Observation
Shows age variation within the dataset.

Outcome Distribution
sns.countplot(
    x=df['Outcome']
)
Observation
Displays the number of diabetic and non-diabetic patients.

Correlation Heatmap
sns.heatmap(
    df.corr(),
    annot=True,
    cmap='coolwarm'
)
Observation
Helps identify relationships among medical features.

Step 4: Split Features and Target
Feature Matrix
X = df.drop('Outcome', axis=1)
Target Variable
y = df['Outcome']
Step 5: Train-Test Split
Split dataset into training and testing sets.

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)
Parameter Description
Parameter	Meaning
test_size=0.2	20% testing data
random_state=42	Reproducible results
Step 6: Create Bayesian Model
Algorithm Used
Gaussian Naive Bayes

model = GaussianNB()
Why GaussianNB?
Because:

Dataset contains continuous numerical features.
Assumes Gaussian (normal) distribution.
Suitable for medical datasets.
Step 7: Train Model
model.fit(X_train, y_train)
The classifier learns probability distributions from the training data.

Step 8: Predictions
y_pred = model.predict(X_test)
The trained model predicts whether a patient is diabetic or non-diabetic.

Step 9: Accuracy Calculation
Formula
Accuracy is calculated as:

Accuracy =
Correct Predictions
-------------------
Total Predictions
Implementation:

accuracy = accuracy_score(
    y_test,
    y_pred
)

print("Accuracy:", accuracy)
Step 10: Confusion Matrix
Generate confusion matrix.

cm = confusion_matrix(
    y_test,
    y_pred
)
Visualize:

sns.heatmap(
    cm,
    annot=True,
    fmt='d',
    cmap='Blues'
)
Interpretation
Actual	Predicted	Meaning
0	0	True Negative
0	1	False Positive
1	0	False Negative
1	1	True Positive
Step 11: Classification Report
Generate detailed evaluation metrics.

print(
    classification_report(
        y_test,
        y_pred
    )
)
Metrics Included
Precision
Recall
F1 Score
Support
Step 12: Probability Prediction
One major advantage of Naive Bayes is probability estimation.

probabilities = model.predict_proba(X_test)

print(probabilities[:5])
Example Output:

[0.85 0.15]
Interpretation:

85% probability = Non-Diabetic
15% probability = Diabetic
This makes predictions more interpretable.

Step 13: Visualize Prediction Results
plt.figure(figsize=(10,5))

plt.plot(
    y_test.values[:30],
    label='Actual',
    marker='o'
)

plt.plot(
    y_pred[:30],
    label='Predicted',
    marker='x'
)

plt.legend()
plt.show()
Observation
The graph compares actual outcomes with predicted outcomes.

Closer overlap indicates better classification performance.

Results
Diabetes dataset was loaded successfully.
Medical features were explored and visualized.
Dataset was divided into training and testing sets.
Gaussian Naive Bayes classifier was trained successfully.
Predictions were generated for unseen data.
Accuracy, confusion matrix, and classification report were obtained.
Probability-based predictions were analyzed successfully.
Advantages of Naive Bayes
Fast training and prediction.
Works well with medical datasets.
Handles large datasets efficiently.
Probability-based prediction.
Easy implementation.
Limitations
Assumes feature independence.
Performance decreases if features are highly correlated.
Less effective when independence assumption is violated.
Applications
Medical Diagnosis
Disease Prediction
Spam Email Detection
Sentiment Analysis
Document Classification
Fraud Detection
Recommendation Systems
Conclusion
The Gaussian Naive Bayes classifier was successfully implemented on the Diabetes Dataset for probabilistic classification. The model predicted diabetic outcomes with good accuracy and provided probability estimates for each prediction. The experiment demonstrated the effectiveness of Bayesian learning in healthcare analytics and medical diagnosis applications.

Outcome
A probabilistic classification system was successfully developed using Gaussian Naive Bayes. The model accurately classified diabetic and non-diabetic patients and demonstrated how Bayesian learning can be applied to real-world healthcare datasets.

Viva Questions
Q1. What is Bayesian Learning?
Bayesian Learning uses probability theory and Bayes' Theorem for prediction and classification.

Q2. What is Naive Bayes?
Naive Bayes is a probabilistic classifier based on Bayes' Theorem.

Q3. Why is it called "Naive"?
Because it assumes all features are independent of one another.

Q4. Why was GaussianNB used?
Because the dataset contains continuous numerical features that can be modeled using a Gaussian distribution.

Q5. What is posterior probability?
The probability of an event after observing evidence.

Q6. What is prior probability?
The probability of an event before observing evidence.

Q7. What is likelihood in Bayes' Theorem?
The probability of observing evidence given a particular class.

Q8. What is the advantage of probability-based prediction?
It provides confidence levels for predictions, making decisions more interpretable.

Q9. Can Naive Bayes handle large datasets?
Yes, Naive Bayes is computationally efficient and scales well to large datasets.

Q10. Give one real-world application of Naive Bayes.
Spam email filtering is one of the most common applications of Naive Bayes classification.
