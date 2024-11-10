Class {
	#name : #SqsDay,
	#superclass : #Object,
	#instVars : [
		'date'
	],
	#category : #StQuantifiedSelf
}

{ #category : #'instance creation' }
SqsDay class >> of: aDate [
	 ^ self new
	 	date: aDate
]

{ #category : #accessing }
SqsDay >> date [
	^ date
]

{ #category : #accessing }
SqsDay >> date: aDate [ 
	date := aDate asDate
]

{ #category : #'view creation' }
SqsDay >> gtJournalFor: aView context: aContext [
	<gtView>
	self hasJournalEntry not ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Journal';
		priority: 10;
		stencil: [ | snippet snippetViewModel |
			snippet := LeTextSnippet string: self journalFile contents.
			snippetViewModel := snippet asSnippetViewModel.
			snippetViewModel coderViewModel
				addShortcut: (BrEditorShortcut lineEnding
						combination: (LeSnippetElement keyboardShortcut: #NewLine)).
			snippetViewModel coderViewModel
				addShortcut: (BlShortcutWithAction new
						combination: BlKeyCombination primaryS;
						action: [ :anEvent | 
							self journalFile
								writeStreamDo: [ :stream | 
									stream truncate.
									(ZnNewLineWriterStream on: stream)
										nextPutAll: anEvent currentTarget text asString ] ]).
			((snippetViewModel snippetView needsEmbellishments: false) asElement
				snippetViewModel: snippetViewModel)
				vMatchParent;
				hExact: 650 ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save entry'
			action: [ :aToggle :aTab | 
				self journalFile
					writeStreamDo: [ :stream | 
						stream truncate.
						(ZnNewLineWriterStream on: stream)
							nextPutAll: aTab viewContentElement children first text asString ] ]
]

{ #category : #testing }
SqsDay >> hasJournalEntry [
	^ (self journalDirectory / self journalFileName) asFileReference exists
]

{ #category : #accessing }
SqsDay >> journalDirectory [
	| basePath |
	basePath := FileLocator home / '.secrets' / 'journal-vault.txt'.
	^ (basePath contents trimBoth, self date year asString) asFileReference
]

{ #category : #'view creation' }
SqsDay >> journalFile [
	^ self journalDirectory / (self date yyyymmdd , '.md')
]

{ #category : #accessing }
SqsDay >> journalFileName [
	^ self date yyyymmdd , '.md'
]
