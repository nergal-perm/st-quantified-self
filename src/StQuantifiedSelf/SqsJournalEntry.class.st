Class {
	#name : #SqsJournalEntry,
	#superclass : #Object,
	#instVars : [
		'date'
	],
	#category : #'StQuantifiedSelf-Journal'
}

{ #category : #'instance creation' }
SqsJournalEntry class >> for: aDate [
	^ self new
		date: aDate;
		yourself 
]

{ #category : #initialization }
SqsJournalEntry >> date: aDate [ 
	date := aDate
]
