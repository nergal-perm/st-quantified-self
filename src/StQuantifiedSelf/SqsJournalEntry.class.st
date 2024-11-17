Class {
	#name : #SqsJournalEntry,
	#superclass : #Object,
	#instVars : [
		'date',
		'rawData'
	],
	#category : #'StQuantifiedSelf-Journal'
}

{ #category : #'instance creation' }
SqsJournalEntry class >> for: aDate [
	^ self new
		date: aDate;
		yourself 
]

{ #category : #'instance creation' }
SqsJournalEntry class >> from: aResponse [
	^ self new
		rawData: aResponse;
		yourself.
]

{ #category : #initialization }
SqsJournalEntry >> date: aDate [ 
	date := aDate
]

{ #category : #accessing }
SqsJournalEntry >> rawData [
	^ rawData
]

{ #category : #accessing }
SqsJournalEntry >> rawData: aResponse [ 
	rawData := aResponse
]
