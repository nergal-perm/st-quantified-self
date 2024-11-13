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

{ #category : #'instance creation' }
SqsJournalEntry >> date: aDate [ 
	date := aDate
]

{ #category : #'view creation' }
SqsJournalEntry >> editorsContainer [
	| pane summaryEditor detailsEditor |
	pane := BrVerticalPane new matchParent
			background: Color random;
			yourself.
	summaryEditor := BrHorizontalPane new hMatchParent
			background: Color random;
			margin: (BlInsets all: 10);
			yourself.
	detailsEditor := BrHorizontalPane new hMatchParent
			background: Color random;
			margin: (BlInsets all: 10);
			yourself.
	pane
		addChild: summaryEditor;
		addChild: detailsEditor.
	^ pane
]

{ #category : #'view creation' }
SqsJournalEntry >> gtJournalViewFor: aView [
	<gtView>
		^ aView explicit
		title: 'Journal';
		priority: 10;
		stencil: [ self editorsContainer]
]
