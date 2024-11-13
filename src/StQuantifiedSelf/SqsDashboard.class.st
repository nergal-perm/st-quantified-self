Class {
	#name : #SqsDashboard,
	#superclass : #Object,
	#instVars : [
		'date'
	],
	#category : #StQuantifiedSelf
}

{ #category : #'instance creation' }
SqsDashboard class >> of: aDate [
	 ^ self new
	 	date: aDate
]

{ #category : #accessing }
SqsDashboard class >> today [
	^ SqsDashboard of: Date today yyyymmdd
]

{ #category : #widgets }
SqsDashboard >> calendarWidget [
	^ GtCalendarElement forDate: self date
]

{ #category : #accessing }
SqsDashboard >> date [
	^ date
]

{ #category : #accessing }
SqsDashboard >> date: aDate [ 
	date := aDate asDate
]

{ #category : #widgets }
SqsDashboard >> daySummaryEditorWidget [
	| snippetViewModel snippet |
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
	^ ((snippetViewModel snippetView needsEmbellishments: false) asElement
		snippetViewModel: snippetViewModel)
		vMatchParent;
		hExact: 650
]

{ #category : #'view creation' }
SqsDashboard >> gtDashboardFor: aView [
	<gtView>
	^ aView explicit
		title: 'Dashboard';
		priority: 10;
		stencil: [ | container calendar summary mainRow padding10px |
			padding10px := BlInsets all: 10.
			container := BrVerticalPane new
					matchParent;
					padding: padding10px;
					yourself.
			mainRow := BrHorizontalPane new
					matchParent;
					yourself.
			calendar := self calendarWidget
					aptitude: BrShadowAptitude;
					padding: padding10px;
					yourself.
			summary := self daySummaryEditorWidget
					padding: padding10px;
					yourself.
			mainRow addChild: calendar.
			mainRow addChild: summary.
			container addChild: mainRow.
			container ]
]

{ #category : #'view creation' }
SqsDashboard >> gtJournalFor: aView context: aContext [
	<gtView>
	self hasJournalEntry not ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Journal';
		priority: 10;
		stencil: [ self daySummaryEditorWidget ];
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
SqsDashboard >> hasJournalEntry [
	^ (self journalDirectory / self journalFileName) asFileReference exists
]

{ #category : #accessing }
SqsDashboard >> journalDirectory [
	| basePath |
	basePath := FileLocator home / '.secrets' / 'journal-vault.txt'.
	^ (basePath contents trimBoth, self date year asString) asFileReference
]

{ #category : #'view creation' }
SqsDashboard >> journalFile [
	^ self journalDirectory / (self date yyyymmdd , '.md')
]

{ #category : #accessing }
SqsDashboard >> journalFileName [
	^ self date yyyymmdd , '.md'
]
